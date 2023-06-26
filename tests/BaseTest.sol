// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import {AaveMisc} from 'aave-address-book/AaveMisc.sol';
import {GovHelpers, AaveGovernanceV2} from 'aave-helpers/GovHelpers.sol';
import {ProxyHelpers} from 'aave-helpers/ProxyHelpers.sol';
import {StakedTokenV3} from '../src/contracts/StakedTokenV3.sol';
import {StakedAaveV3} from '../src/contracts/StakedAaveV3.sol';
import {IInitializableAdminUpgradeabilityProxy} from '../src/interfaces/IInitializableAdminUpgradeabilityProxy.sol';
import {IGhoVariableDebtTokenTransferHook} from '../src/interfaces/IGhoVariableDebtTokenTransferHook.sol';
import {ProposalPayloadStkAbpt, ProposalPayloadStkAave, GenericProposal} from '../src/contracts/ProposalPayload.sol';
import {ProxyAdmin, TransparentUpgradeableProxy} from 'openzeppelin-contracts/contracts/proxy/transparent/ProxyAdmin.sol';

contract BaseTest is Test {
  StakedAaveV3 STAKE_CONTRACT;

  uint256 constant SLASHING_ADMIN = 0;
  uint256 constant COOLDOWN_ADMIN = 1;
  uint256 constant CLAIM_HELPER_ROLE = 2;

  address slashingAdmin;
  address cooldownAdmin;
  address claimHelper;

  function _executeProposal(bool stkAAVE) internal {
    uint256 proposalId;
    GovHelpers.Payload[] memory payloads = new GovHelpers.Payload[](1);
    if (stkAAVE) {
      payloads[0] = GovHelpers.buildMainnet(
        address(new ProposalPayloadStkAave())
      );
      proposalId = GovHelpers.createProposal(
        AaveGovernanceV2.LONG_EXECUTOR,
        payloads,
        bytes32('1')
      );
    } else {
      payloads[0] = GovHelpers.buildMainnet(
        address(new ProposalPayloadStkAbpt())
      );
      proposalId = GovHelpers.createProposal(payloads, bytes32('1'));
    }
    GovHelpers.passVoteAndExecute(vm, proposalId);

    // ensure implementation is bricked
    address impl = ProxyHelpers
      .getInitializableAdminUpgradeabilityProxyImplementation(
        vm,
        address(STAKE_CONTRACT)
      );

    try
      StakedTokenV3(impl).initialize(
        GenericProposal.SLASHING_ADMIN,
        GenericProposal.COOLDOWN_ADMIN,
        GenericProposal.CLAIM_HELPER,
        GenericProposal.MAX_SLASHING,
        GenericProposal.COOLDOWN_SECONDS
      )
    {} catch Error(string memory reason) {
      require(
        keccak256(bytes(reason)) ==
          keccak256(bytes('Contract instance has already been initialized'))
      );
    }
  }

  function _setUp(bool stkAAVE) internal {
    vm.createSelectFork(vm.rpcUrl('mainnet'), 16890980);

    address stake = address(0);
    if (stkAAVE) {
      stake = 0x4da27a545c0c5B758a6BA100e3a049001de870f5;
    } else {
      stake = 0xa1116930326D21fB917d5A27F1E9943A9595fb47;
    }
    STAKE_CONTRACT = StakedAaveV3(address(StakedTokenV3(stake)));
    vm.startPrank(AaveMisc.ECOSYSTEM_RESERVE);
    _executeProposal(stkAAVE);
    vm.stopPrank();

    slashingAdmin = STAKE_CONTRACT.getAdmin(SLASHING_ADMIN);
    cooldownAdmin = STAKE_CONTRACT.getAdmin(COOLDOWN_ADMIN);
    claimHelper = STAKE_CONTRACT.getAdmin(CLAIM_HELPER_ROLE);
  }

  function _stake(uint256 amount) internal {
    _stake(amount, address(this));
  }

  function _stake(uint256 amount, address user) internal {
    deal(address(STAKE_CONTRACT.STAKED_TOKEN()), user, amount);
    STAKE_CONTRACT.STAKED_TOKEN().approve(address(STAKE_CONTRACT), amount);
    STAKE_CONTRACT.stake(user, amount);
  }

  function _redeem(uint256 amount) internal {
    STAKE_CONTRACT.redeem(address(this), amount);
    assertEq(STAKE_CONTRACT.STAKED_TOKEN().balanceOf(address(this)), amount);
  }

  function _slash20() internal {
    address receiver = address(42);
    uint256 amountToSlash = (STAKE_CONTRACT.previewRedeem(
      STAKE_CONTRACT.totalSupply()
    ) * 2) / 10;

    // slash
    vm.startPrank(STAKE_CONTRACT.getAdmin(SLASHING_ADMIN));
    STAKE_CONTRACT.slash(receiver, amountToSlash);
    vm.stopPrank();
  }

  function _settleSlashing() internal {
    vm.startPrank(slashingAdmin);
    STAKE_CONTRACT.settleSlashing();
    vm.stopPrank();
  }
}
