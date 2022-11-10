// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import {GovHelpers} from 'aave-helpers/GovHelpers.sol';
import {StakedTokenV3} from '../src/contracts/StakedTokenV3.sol';
import {IInitializableAdminUpgradeabilityProxy} from '../src/interfaces/IInitializableAdminUpgradeabilityProxy.sol';
import {BaseTest} from './BaseTest.sol';

contract SlashingValidation is BaseTest {
  function setUp() public {
    _setUp(false);
  }

  function testInitializer() public {
    assertEq(STAKE_CONTRACT.getAdmin(SLASHING_ADMIN), slashingAdmin);
    assertEq(STAKE_CONTRACT.getAdmin(COOLDOWN_ADMIN), cooldownAdmin);
    assertEq(STAKE_CONTRACT.getAdmin(CLAIM_HELPER_ROLE), claimHelper);
    assertEq(STAKE_CONTRACT.getCooldownSeconds() != 0, true);
  }

  /**
   * @dev Reverts trying to stake 0 amount
   */
  function testFailStakeZero() public {
    uint256 amount = 0;
    STAKE_CONTRACT.stake(address(this), amount);
  }

  /**
   * @dev Verifies that the initial exchange rate is 1:1
   */
  function testExchangeRate1To1() public {
    assertEq(STAKE_CONTRACT.getExchangeRate(), 1 ether);
  }

  /**
   * @dev Verifies that after a deposit the initial exchange rate is still 1:1
   */
  function testEchangeRateStill1To1() public {
    uint256 amount = 10 ether;

    STAKE_CONTRACT.STAKED_TOKEN().approve(address(STAKE_CONTRACT), amount);
    STAKE_CONTRACT.stake(address(this), amount);

    assertEq(STAKE_CONTRACT.getExchangeRate(), 1 ether);
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

  function testSlashExchangeRate() internal {
    address receiver = address(42);
    uint256 amountToSlash = (STAKE_CONTRACT.totalSupply() * 2) / 10;

    // slash
    vm.startPrank(STAKE_CONTRACT.getAdmin(SLASHING_ADMIN));
    STAKE_CONTRACT.slash(receiver, amountToSlash);
    vm.stopPrank();

    assertEq(STAKE_CONTRACT.STAKED_TOKEN().balanceOf(receiver), amountToSlash);
    assertEq(STAKE_CONTRACT.getExchangeRate(), 0.8 ether);
  }

  /**
   * @dev Executes a slash of 20% of the asset and redeem
   */
  function testSlash20Redeem() public {
    uint256 amount = 10 ether;

    STAKE_CONTRACT.STAKED_TOKEN().approve(address(STAKE_CONTRACT), amount);
    STAKE_CONTRACT.stake(address(this), amount);

    _slash20();
    // redeem

    STAKE_CONTRACT.redeem(address(this), amount);
    assertEq(STAKE_CONTRACT.STAKED_TOKEN().balanceOf(address(this)), 8 ether);
  }

  /**
   * @dev Executes a slash of 20% of the asset and redeem
   */
  function testFailSlash20RedeemToLate() public {
    uint256 amount = 10 ether;

    STAKE_CONTRACT.STAKED_TOKEN().approve(address(STAKE_CONTRACT), amount);
    STAKE_CONTRACT.stake(address(this), amount);

    _slash20();
    _settleSlashing();
    STAKE_CONTRACT.redeem(address(this), amount);
    assertEq(STAKE_CONTRACT.STAKED_TOKEN().balanceOf(address(this)), 8 ether);
  }

  /**
   * @dev Stakes 1 more after 20% slash - expected to receive 1.25 stkAAVE
   */
  function testSlash20Stake() public {
    _slash20();
    _settleSlashing();
    uint256 amount = 1 ether;
    STAKE_CONTRACT.STAKED_TOKEN().approve(address(STAKE_CONTRACT), amount);
    STAKE_CONTRACT.stake(address(this), amount);
    assertEq(STAKE_CONTRACT.balanceOf(address(this)), 1.25 ether);
  }

  function testSlashTwice() public {
    _slash20();
    _settleSlashing();

    _slash20();
  }

  /**
   * @dev Tries to slash with an account that is not the slashing admin
   */
  function testFailSlash() public {
    address receiver = address(42);
    uint256 amountToSlash = (STAKE_CONTRACT.totalSupply() * 2) / 10;

    // slash
    STAKE_CONTRACT.slash(receiver, amountToSlash);
  }

  /**
   * @dev Tries to change the slash admin not being the slash admin
   */
  function testFailChangeSlashAdmin() public {
    address newAdmin = address(42);

    STAKE_CONTRACT.setPendingAdmin(SLASHING_ADMIN, newAdmin);
  }

  /**
   * @dev Tries to change the cooldown admin not being the cooldown admin
   */
  function testFailChangeCooldownAdmin() public {
    address newAdmin = address(42);

    STAKE_CONTRACT.setPendingAdmin(COOLDOWN_ADMIN, newAdmin);
  }

  /**
   * @dev Changes the pending slashing admin
   */
  function testChangeSlashAdmin() public {
    address newAdmin = address(42);

    vm.startPrank(STAKE_CONTRACT.getAdmin(SLASHING_ADMIN));
    STAKE_CONTRACT.setPendingAdmin(SLASHING_ADMIN, newAdmin);
    vm.stopPrank();

    assertEq(STAKE_CONTRACT.getPendingAdmin(SLASHING_ADMIN), newAdmin);
  }

  /**
   * @dev Tries to claim the pending slashing admin not being the pending admin
   */
  function testFailClaimSlashAdmin() public {
    STAKE_CONTRACT.claimRoleAdmin(SLASHING_ADMIN);
  }

  /**
   * @dev Claim the slashing admin role
   */
  function testClaimSlashAdmin() public {
    vm.startPrank(STAKE_CONTRACT.getAdmin(SLASHING_ADMIN));
    STAKE_CONTRACT.setPendingAdmin(SLASHING_ADMIN, address(this));
    vm.stopPrank();
    STAKE_CONTRACT.claimRoleAdmin(SLASHING_ADMIN);

    assertEq(STAKE_CONTRACT.getAdmin(SLASHING_ADMIN), address(this));
  }

  function testFailChangeMaxSlashingNoAdmin() public {
    STAKE_CONTRACT.setMaxSlashablePercentage(1000);
  }

  function testFailChangeMaxSlashingToHigh() public {
    vm.startPrank(STAKE_CONTRACT.getAdmin(SLASHING_ADMIN));
    STAKE_CONTRACT.setMaxSlashablePercentage(10001);
  }

  function testChangeMaxSlashing() public {
    vm.startPrank(STAKE_CONTRACT.getAdmin(SLASHING_ADMIN));
    STAKE_CONTRACT.setMaxSlashablePercentage(1000);
    assertEq(STAKE_CONTRACT.getMaxSlashablePercentage(), 1000);
  }

  function testSlashMoreThanMax() public {
    address receiver = address(42);

    uint256 expectedAmount = (STAKE_CONTRACT.previewRedeem(
      STAKE_CONTRACT.totalSupply()
    ) * STAKE_CONTRACT.getMaxSlashablePercentage()) / 10000;

    // slash
    vm.startPrank(STAKE_CONTRACT.getAdmin(SLASHING_ADMIN));
    uint256 amount = STAKE_CONTRACT.slash(receiver, type(uint256).max);
    vm.stopPrank();

    assertEq(amount, expectedAmount);
  }

  function test_refund() public {
    uint256 amount = 10 ether;

    STAKE_CONTRACT.STAKED_TOKEN().approve(address(STAKE_CONTRACT), amount);
    STAKE_CONTRACT.returnFunds(amount);
  }
}
