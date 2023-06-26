// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import {AaveGovernanceV2, IAaveGovernanceV2} from 'aave-address-book/AaveGovernanceV2.sol';
import {GovHelpers} from 'aave-helpers/GovHelpers.sol';
import {StakedTokenV3} from '../src/contracts/StakedTokenV3.sol';
import {IInitializableAdminUpgradeabilityProxy} from '../src/interfaces/IInitializableAdminUpgradeabilityProxy.sol';
import {BaseTest} from './BaseTest.sol';
import {IGovernancePowerDelegationToken} from 'aave-token-v3/interfaces/IGovernancePowerDelegationToken.sol';

contract GovernanceValidation is BaseTest {
  function setUp() public {
    _setUp(true);
  }

  // FUZZ
  /**
   * @dev User votes on proposal after 10% being slashed
   */
  function test_voteAfterSlash(uint256 amount) public {
    uint256 slashingPercent = 10;
    vm.assume(amount < type(uint104).max);
    vm.assume(amount > 1 ether);
    _stake(amount);

    address receiver = address(42);
    uint256 amountToSlash = (STAKE_CONTRACT.totalSupply() * slashingPercent) /
      100;
    vm.startPrank(STAKE_CONTRACT.getAdmin(SLASHING_ADMIN));
    STAKE_CONTRACT.slash(receiver, amountToSlash);
    vm.stopPrank();

    uint256 power = STAKE_CONTRACT.getPowerCurrent(
      address(this),
      IGovernancePowerDelegationToken.GovernancePowerType.VOTING
    );

    assertLe(power, (amount * (100 - slashingPercent)) / 100);
    assertApproxEqRel(
      power,
      (amount * (100 - slashingPercent)) / 100,
      0.001e18
    ); // allow for 0.1% derivation
  }

  function test_delegateAfterSlash(uint256 amount) public {
    uint256 slashingPercent = 10;
    vm.assume(amount < type(uint128).max);
    vm.assume(amount > 1 ether);
    _stake(amount);
    address delegatee = address(100);
    STAKE_CONTRACT.delegate(delegatee);

    address receiver = address(42);
    uint256 amountToSlash = (STAKE_CONTRACT.totalSupply() * slashingPercent) /
      100;
    vm.startPrank(STAKE_CONTRACT.getAdmin(SLASHING_ADMIN));
    STAKE_CONTRACT.slash(receiver, amountToSlash);
    vm.stopPrank();

    uint256 power = STAKE_CONTRACT.getPowerCurrent(
      delegatee,
      IGovernancePowerDelegationToken.GovernancePowerType.VOTING
    );

    assertLe(power, (amount * (100 - slashingPercent)) / 100);
    assertApproxEqRel(
      power,
      (amount * (100 - slashingPercent)) / 100,
      0.001e18
    ); // allow for 0.1% derivation
  }
}
