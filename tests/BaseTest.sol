// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import {GovHelpers} from 'aave-helpers/GovHelpers.sol';
import {StakedTokenV3} from '../src/contracts/StakedTokenV3.sol';
import {StakedAaveV3} from '../src/contracts/StakedAaveV3.sol';
import {IInitializableAdminUpgradeabilityProxy} from '../src/interfaces/IInitializableAdminUpgradeabilityProxy.sol';
import {IGhoVariableDebtToken} from '../src/interfaces/IGhoVariableDebtToken.sol';

contract GhoDebtMock is IGhoVariableDebtToken {
  function updateDiscountDistribution(
    address sender,
    address recipient,
    uint256 senderDiscountTokenBalance,
    uint256 recipientDiscountTokenBalance,
    uint256 amount
  ) public {}
}

contract BaseTest is Test {
  StakedTokenV3 STAKE_CONTRACT;

  uint256 constant SLASHING_ADMIN = 0;
  uint256 constant COOLDOWN_ADMIN = 1;
  uint256 constant CLAIM_HELPER_ROLE = 2;

  address slashingAdmin = address(4);
  address cooldownAdmin = address(5);
  address claimHelper = address(6);

  function _deployImplementation(bool stkAAVE) internal returns (address) {
    if (stkAAVE) {
      GhoDebtMock ghoMock = new GhoDebtMock();
      return
        address(
          new StakedAaveV3(
            STAKE_CONTRACT.STAKED_TOKEN(),
            STAKE_CONTRACT.REWARD_TOKEN(),
            3000,
            STAKE_CONTRACT.REWARDS_VAULT(),
            STAKE_CONTRACT.EMISSION_MANAGER(),
            3155692600, // 100 years
            address(ghoMock)
          )
        );
    }
    return
      address(
        new StakedTokenV3(
          STAKE_CONTRACT.STAKED_TOKEN(),
          STAKE_CONTRACT.REWARD_TOKEN(),
          3000,
          STAKE_CONTRACT.REWARDS_VAULT(),
          STAKE_CONTRACT.EMISSION_MANAGER(),
          3155692600 // 100 years
        )
      );
  }

  function _setUp(bool stkAAVE) internal {
    vm.createSelectFork(vm.rpcUrl('ethereum'), 15896416);

    address admin = address(0);
    address stake = address(0);
    if (stkAAVE) {
      admin = GovHelpers.LONG_EXECUTOR;
      stake = 0x4da27a545c0c5B758a6BA100e3a049001de870f5;
    } else {
      admin = GovHelpers.SHORT_EXECUTOR;
      stake = 0xa1116930326D21fB917d5A27F1E9943A9595fb47;
    }
    STAKE_CONTRACT = StakedTokenV3(stake);
    address stkImpl = _deployImplementation(stkAAVE);
    vm.startPrank(admin);
    IInitializableAdminUpgradeabilityProxy stkProxy = IInitializableAdminUpgradeabilityProxy(
        address(STAKE_CONTRACT)
      );
    stkProxy.upgradeToAndCall(
      stkImpl,
      abi.encodeWithSignature(
        'initialize(address,address,address,uint256,uint256)',
        slashingAdmin,
        cooldownAdmin,
        claimHelper,
        3000,
        864000
      )
    );
    vm.stopPrank();
  }

  function _stake(uint256 amount) internal {
    deal(address(STAKE_CONTRACT.STAKED_TOKEN()), address(this), amount);
    STAKE_CONTRACT.STAKED_TOKEN().approve(address(STAKE_CONTRACT), amount);
    STAKE_CONTRACT.stake(address(this), amount);
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
