// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;

interface IStakedToken {
  /**
   * @dev Allows staking a specified amount of STAKED_TOKEN
   * @param to The address to receiving the shares
   * @param amount The amount of assets to be staked
   **/
  function stake(address to, uint256 amount) external;

  /**
   * @dev Redeems shares, and stop earning rewards
   * @param to Address to redeem to
   * @param amount Amount of shares to redeem
   **/
  function redeem(address to, uint256 amount) external;

  function cooldown() external;

  /**
   * @dev Claims an `amount` of `REWARD_TOKEN` to the address `to`
   * @param to Address to send the claimed rewards
   * @param amount Amount to stake
   **/
  function claimRewards(address to, uint256 amount) external;
}
