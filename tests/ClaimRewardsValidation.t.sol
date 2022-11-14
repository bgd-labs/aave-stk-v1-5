// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import {GovHelpers} from 'aave-helpers/GovHelpers.sol';
import {ProxyHelpers} from 'aave-helpers/ProxyHelpers.sol';
import {StakedTokenV3} from '../src/contracts/StakedTokenV3.sol';
import {IInitializableAdminUpgradeabilityProxy} from '../src/interfaces/IInitializableAdminUpgradeabilityProxy.sol';
import {BaseTest} from './BaseTest.sol';

contract ClaimRewardsValidation is BaseTest {
  function setUp() public {
    _setUp(true);
  }

  /**
   * @dev User stakes 10 ABPT: receives 10 stkABPT, StakedAave balance of ABPT is 10 and his rewards to claim are 0
   */
  function test_claimZero() public {
    uint256 amount = 10 ether;

    _stake(amount);
    assertEq(STAKE_CONTRACT.getTotalRewardsBalance(address(this)), 0);
  }

  /**
   * @dev User 1 claim half rewards
   */
  function test_claimHalf() public {
    uint256 amount = 10 ether;

    _stake(amount);

    vm.warp(block.timestamp + 60 * 60 * 24 * 100);

    uint256 balanceToClaim = STAKE_CONTRACT.getTotalRewardsBalance(
      address(this)
    );
    uint256 halfClaim = balanceToClaim / 2;
    STAKE_CONTRACT.claimRewards(address(this), halfClaim);
    assertEq(STAKE_CONTRACT.REWARD_TOKEN().balanceOf(address(this)), halfClaim);
    assertEq(
      STAKE_CONTRACT.getTotalRewardsBalance(address(this)),
      balanceToClaim - halfClaim
    );
  }

  /**
   * @dev User 1 claim more then available
   */
  function test_claimMore() public {
    uint256 amount = 10 ether;

    _stake(amount);

    vm.warp(block.timestamp + 60 * 60 * 24 * 100);

    uint256 balanceToClaim = STAKE_CONTRACT.getTotalRewardsBalance(
      address(this)
    );
    STAKE_CONTRACT.claimRewards(address(this), balanceToClaim * 2);
    assertEq(
      STAKE_CONTRACT.REWARD_TOKEN().balanceOf(address(this)),
      balanceToClaim
    );
    assertEq(STAKE_CONTRACT.getTotalRewardsBalance(address(this)), 0);
  }

  /**
   * @dev User 1 claim all
   */
  function test_claimAll() public {
    uint256 amount = 10 ether;

    _stake(amount);

    vm.warp(block.timestamp + 60 * 60 * 24 * 100);

    uint256 balanceToClaim = STAKE_CONTRACT.getTotalRewardsBalance(
      address(this)
    );
    STAKE_CONTRACT.claimRewards(address(this), balanceToClaim);
    assertEq(
      STAKE_CONTRACT.REWARD_TOKEN().balanceOf(address(this)),
      balanceToClaim
    );
    assertEq(STAKE_CONTRACT.getTotalRewardsBalance(address(this)), 0);
  }

  function test_claimRewardsAndStake() public {
    uint256 amount = 10 ether;

    _stake(amount);

    vm.warp(block.timestamp + 60 * 60 * 24 * 100);

    uint256 balanceBefore = STAKE_CONTRACT.balanceOf(address(this));
    uint256 balanceToClaim = STAKE_CONTRACT.getTotalRewardsBalance(
      address(this)
    );
    require(balanceToClaim != 0);
    STAKE_CONTRACT.claimRewardsAndStake(address(this), balanceToClaim);
    uint256 balanceAfter = STAKE_CONTRACT.balanceOf(address(this));
    assertEq(balanceAfter, balanceBefore + balanceToClaim);
  }
}
