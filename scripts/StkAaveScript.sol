// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {StakedAaveV3} from '../src/contracts/StakedAaveV3.sol';
import {IERC20} from 'openzeppelin-contracts/contracts/token/ERC20/IERC20.sol';

abstract contract StkAaveScript {
  uint256 public constant UNSTAKE_WINDOW = 172800; // 2 days
  uint128 public constant DISTRIBUTION_DURATION = 3155692600; // 100 years

  function _deploy(
    address stakedToken,
    address rewardToken,
    address rewardsVault,
    address emissionManager
  ) internal returns (address) {
    StakedAaveV3 stkAaveToken = new StakedAaveV3(
      IERC20(stakedToken),
      IERC20(rewardToken),
      UNSTAKE_WINDOW,
      rewardsVault,
      emissionManager,
      DISTRIBUTION_DURATION
    );

    return address(stkAaveToken);
  }
}
