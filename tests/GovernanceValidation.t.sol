// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import {AaveGovernanceV2, IAaveGovernanceV2, IGovernanceStrategy} from 'aave-address-book/AaveGovernanceV2.sol';
import {GovHelpers} from 'aave-helpers/GovHelpers.sol';
import {StakedTokenV3} from '../src/contracts/StakedTokenV3.sol';
import {IInitializableAdminUpgradeabilityProxy} from '../src/interfaces/IInitializableAdminUpgradeabilityProxy.sol';
import {BaseTest} from './BaseTest.sol';

contract GovernanceValidation is BaseTest {
  function setUp() public {
    _setUp(true);
  }

  function _createDummyProposal() internal returns (uint256) {
    address[] memory targets = new address[](1);
    targets[0] = 0xf42D0a1b03C0795021272a4793CD03dCb97581D3;
    uint256[] memory values = new uint256[](1);
    values[0] = 0;
    string[] memory signatures = new string[](1);
    signatures[0] = 'execute()';
    bytes[] memory calldatas = new bytes[](1);
    calldatas[0] = '';
    bool[] memory withDelegatecalls = new bool[](1);
    withDelegatecalls[0] = true;
    uint256 proposalId = GovHelpers.createTestProposal(
      vm,
      GovHelpers.SPropCreateParams(
        AaveGovernanceV2.SHORT_EXECUTOR,
        targets,
        values,
        signatures,
        calldatas,
        withDelegatecalls,
        0x54f91e12ea75ccaf9101fa8d59bf08b9edab7a745f16ca0ac26b668e47b93952
      )
    );
    IAaveGovernanceV2.ProposalWithoutVotes memory proposal = GovHelpers
      .getProposalById(proposalId);
    // perhaps do sth more precise for delay
    vm.warp(block.timestamp + 60 * 60 * 24 * 1);
    vm.roll(proposal.startBlock + 1);
    return proposalId;
  }

  /**
   *
   */
  function test_voteNoPower() public {
    uint256 proposalId = _createDummyProposal();
    AaveGovernanceV2.GOV.submitVote(proposalId, true);
    IAaveGovernanceV2.ProposalWithoutVotes memory proposal = GovHelpers
      .getProposalById(proposalId);

    assertEq(proposal.forVotes, 0);
  }

  /**
   * @dev User votes on proposal
   */
  function test_voteInitialExchangeRate() public {
    uint256 amount = 10 ether;

    _stake(amount);
    uint256 proposalId = _createDummyProposal();
    AaveGovernanceV2.GOV.submitVote(proposalId, true);
    IAaveGovernanceV2.ProposalWithoutVotes memory proposal = GovHelpers
      .getProposalById(proposalId);

    assertEq(proposal.forVotes, amount);
  }

  // FUZZ
  /**
   * @dev User votes on proposal after 10% being slashed
   */
  function test_voteAfterSlash(uint256 amount) public {
    uint256 slashingPercent = 10;
    vm.assume(amount < type(uint128).max);
    vm.assume(amount > 1 ether);
    _stake(amount);

    address receiver = address(42);
    uint256 amountToSlash = (STAKE_CONTRACT.totalSupply() * slashingPercent) /
      100;
    vm.startPrank(STAKE_CONTRACT.getAdmin(SLASHING_ADMIN));
    STAKE_CONTRACT.slash(receiver, amountToSlash);
    vm.stopPrank();

    IGovernanceStrategy strategy = IGovernanceStrategy(
      AaveGovernanceV2.GOV.getGovernanceStrategy()
    );
    uint256 power = strategy.getVotingPowerAt(address(this), block.number);

    assertLe(power, (amount * (100 - slashingPercent)) / 100);
    assertApproxEqRel(
      power,
      (amount * (100 - slashingPercent)) / 100,
      0.001e18
    ); // allow for 0.1% derivation
  }
}
