// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import {GovHelpers} from 'aave-helpers/GovHelpers.sol';
import {IStakedTokenV2} from '../src/interfaces/IStakedTokenV2.sol';
import {StakedTokenV3} from '../src/contracts/StakedTokenV3.sol';
import {IInitializableAdminUpgradeabilityProxy} from '../src/interfaces/IInitializableAdminUpgradeabilityProxy.sol';
import {BaseTest} from './BaseTest.sol';

contract CooldownValidation is BaseTest {
  function setUp() public {
    _setUp(false);
  }

  function test_cooldown() public {
    uint256 amount = 10 ether;
    _stake(amount);
    STAKE_CONTRACT.cooldown();

    vm.warp(block.timestamp + STAKE_CONTRACT.getCooldownSeconds() + 1);
    _redeem(amount);
  }

  function test_cooldownOver() public {
    uint256 amount = 10 ether;
    _stake(amount);
    STAKE_CONTRACT.cooldown();

    vm.warp(
      block.timestamp +
        STAKE_CONTRACT.getCooldownSeconds() +
        1 +
        STAKE_CONTRACT.UNSTAKE_WINDOW()
    );
    try STAKE_CONTRACT.redeem(address(this), amount) {} catch Error(
      string memory reason
    ) {
      require(
        keccak256(bytes(reason)) == keccak256(bytes('UNSTAKE_WINDOW_FINISHED'))
      );
    }
  }

  function test_cooldownNotReached() public {
    uint256 amount = 10 ether;
    _stake(amount);
    STAKE_CONTRACT.cooldown();

    vm.warp(block.timestamp + STAKE_CONTRACT.getCooldownSeconds());
    try STAKE_CONTRACT.redeem(address(this), amount) {} catch Error(
      string memory reason
    ) {
      require(
        keccak256(bytes(reason)) == keccak256(bytes('INSUFFICIENT_COOLDOWN'))
      );
    }
  }

  /**
   * Staking while in cooldown shouldn't affect cooldown amount
   */
  function test_stakeWhileCooldown() public {
    uint256 amount = 10 ether;
    _stake(amount);
    STAKE_CONTRACT.cooldown();
    (uint40 cooldownBefore, uint216 cooldownAmountBefore) = STAKE_CONTRACT
      .stakersCooldowns(address(this));

    _stake(amount);
    (uint40 cooldownAfter, uint216 cooldownAmountAfter) = STAKE_CONTRACT
      .stakersCooldowns(address(this));

    assertEq(cooldownBefore, cooldownAfter);
    assertEq(cooldownAmountBefore, cooldownAmountAfter);
  }

  /**
   * Receiving tokens while in cooldown shouldn't affect cooldown amount
   */
  function test_transferInWhileCooldown() public {
    uint256 amount = 10 ether;
    address user1 = address(41);
    address user2 = address(42);

    vm.startPrank(user1);
    _stake(amount, user1);
    STAKE_CONTRACT.cooldown();
    (uint40 cooldownBefore, uint216 cooldownAmountBefore) = STAKE_CONTRACT
      .stakersCooldowns(user1);

    vm.stopPrank();
    vm.startPrank(user2);
    _stake(amount, user2);
    STAKE_CONTRACT.transfer(user1, amount);
    vm.stopPrank();

    vm.startPrank(user1);
    (uint40 cooldownAfter, uint216 cooldownAmountAfter) = STAKE_CONTRACT
      .stakersCooldowns(user1);
    vm.stopPrank();

    assertEq(cooldownBefore, cooldownAfter);
    assertEq(cooldownAmountBefore, cooldownAmountAfter);
  }

  /**
   * Only able to redeem up to initial cooldown amount
   */
  function test_redeemMore() public {
    uint256 amount = 10 ether;
    address user1 = address(41);
    address user2 = address(42);

    vm.startPrank(user1);
    _stake(amount, user1);
    STAKE_CONTRACT.cooldown();

    vm.stopPrank();
    vm.startPrank(user2);
    _stake(amount, user2);
    STAKE_CONTRACT.transfer(user1, amount);
    vm.stopPrank();
    vm.warp(block.timestamp + STAKE_CONTRACT.getCooldownSeconds() + 1);

    vm.startPrank(user1);
    STAKE_CONTRACT.redeem(user1, 6 ether);
    assertEq(STAKE_CONTRACT.STAKED_TOKEN().balanceOf(user1), 6 ether);
    STAKE_CONTRACT.redeem(user1, 6 ether);
    assertEq(STAKE_CONTRACT.STAKED_TOKEN().balanceOf(user1), 10 ether); // 10 instead of 12 as max is adjusted
    try STAKE_CONTRACT.redeem(user1, 1) {} catch Error(string memory reason) {
      require(
        keccak256(bytes(reason)) == keccak256(bytes('UNSTAKE_WINDOW_FINISHED'))
      );
    }
  }

  /**
   * Sending tokens while in cooldown shouldn't affect cooldown amount as long as balanceOf is above cooldown amount
   */
  function test_transferAboveCooldown() public {
    uint256 amount = 10 ether;
    address user1 = address(41);
    address user2 = address(42);

    vm.startPrank(user1);
    _stake(amount, user1);
    // cooldown for 10
    STAKE_CONTRACT.cooldown();
    (uint40 cooldownBefore, uint216 cooldownAmountBefore) = STAKE_CONTRACT
      .stakersCooldowns(user1);
    // stake another 10
    _stake(amount, user1);
    // transfer out 10
    STAKE_CONTRACT.transfer(user2, amount);
    (uint40 cooldownAfter, uint216 cooldownAmountAfter) = STAKE_CONTRACT
      .stakersCooldowns(user1);
    vm.stopPrank();

    assertEq(cooldownBefore, cooldownAfter);
    assertEq(cooldownAmountBefore, cooldownAmountAfter);
  }

  /**
   * Sending tokens while in cooldown should decrease amount specified in cooldown snapshot
   */
  function test_transferBelowCooldown() public {
    address user1 = address(41);
    address user2 = address(42);

    vm.startPrank(user1);
    _stake(10 ether, user1);
    // cooldown for 10
    STAKE_CONTRACT.cooldown();
    (uint72 cooldownBefore, ) = STAKE_CONTRACT.stakersCooldowns(user1);
    // transfer out 5
    STAKE_CONTRACT.transfer(user2, 5 ether);
    (uint40 cooldownAfter, uint216 cooldownAmountAfter) = STAKE_CONTRACT
      .stakersCooldowns(user1);
    vm.stopPrank();

    assertEq(cooldownBefore, cooldownAfter);
    assertEq(cooldownAmountAfter, 5 ether);
  }

  /**
   * Sending all tokens while in cooldown should reset snapshot
   */
  function test_transferAllWhileInCooldown() public {
    address user1 = address(41);
    address user2 = address(42);

    vm.startPrank(user1);
    _stake(10 ether, user1);
    // cooldown for 10
    STAKE_CONTRACT.cooldown();

    // transfer out 10
    STAKE_CONTRACT.transfer(user2, 10 ether);
    (uint40 cooldownAfter, uint216 cooldownAmountAfter) = STAKE_CONTRACT
      .stakersCooldowns(user1);
    vm.stopPrank();

    assertEq(cooldownAfter, 0);
    assertEq(cooldownAmountAfter, 0);
  }
}
