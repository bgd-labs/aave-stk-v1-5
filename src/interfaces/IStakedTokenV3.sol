// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;

import {IStakedToken} from './IStakedToken.sol';

interface IStakedTokenV3 is IStakedToken {
  event Staked(
    address indexed from,
    address indexed to,
    uint256 assets,
    uint256 shares
  );
  event Redeem(
    address indexed from,
    address indexed to,
    uint256 assets,
    uint256 shares
  );
  event MaxSlashablePercentageChanged(uint256 newPercentage);
  event Slashed(address indexed destination, uint256 amount);
  event SlashingExitWindowDurationChanged(uint256 windowSeconds);
  event CooldownSecondsChanged(uint256 cooldownSeconds);
  event ExchangeRateChanged(uint128 exchangeRate);
  event FundsReturned(uint256 amount);
  event SlashingSettled();

  /**
   * @dev Returns the current exchange rate
   * @return exchangeRate as 18 decimal precision uint128
   **/
  function exchangeRate() external view returns (uint128);

  /**
   * @dev Executes a slashing of the underlying of a certain amount, transferring the seized funds
   * to destination. Decreasing the amount of underlying will automatically adjust the exchange rate.
   * A call to `slash` will start a slashing event which has to be settled via `settleSlashing`.
   * As long as the slashing event is ongoing, stake and slash are deactivated.
   * @param destination the address where seized funds will be transferred
   * @param amount the amount
   **/
  function slash(address destination, uint256 amount) external;

  /**
   * @dev Settles an ongoing slashing event
   */
  function settleSlashing() external;

  /**
   * @dev Pulls STAKE_TOKEN and distributes them amonst current stakers by altering the exchange rate.
   * This method is permissionless and intendet to be used after a slashing event to return potential excess funds.
   * @param amount amount of STAKE_TOKEN to pull.
   */
  function returnFunds(uint256 amount) external;

  /**
   * @dev Getter of the cooldown seconds
   * @return cooldownSeconds the amount of seconds between starting the cooldown and being able to redeem
   */
  function getCooldownSeconds() external view returns (uint256);

  /**
   * @dev Setter of cooldown seconds
   * Can only be called by the cooldown admin
   * @param cooldownSeconds the new amount of seconds you have to wait between starting the cooldown and being able to redeem
   */
  function setCooldownSeconds(uint256 cooldownSeconds) external;

  /**
   * @dev Getter of the max slashable percentage of the total staked amount.
   * @return percentage the maximum slashable percentage
   */
  function getMaxSlashablePercentage() external view returns (uint256);

  /**
   * @dev Setter of max slashable percentage of the total staked amount.
   * Can only be called by the slashing admin
   * @param percentage the new maximum slashable percentage
   */
  function setMaxSlashablePercentage(uint256 percentage) external;

  /**
   * @dev Allows staking a certain amount of STAKED_TOKEN with gasless approvals (permit)
   * @param to The address to receiving the shares
   * @param amount The amount to be staked
   * @param deadline The permit execution deadline
   * @param v The v component of the signed message
   * @param r The r component of the signed message
   * @param s The s component of the signed message
   **/
  function stakeWithPermit(
    address from,
    address to,
    uint256 amount,
    uint256 deadline,
    uint8 v,
    bytes32 r,
    bytes32 s
  ) external;

  /**
   * @dev Claims an `amount` of `REWARD_TOKEN` to the address `to` on behalf of the user. Only the claim helper contract is allowed to call this function
   * @param from The address of the user from to claim
   * @param to Address to send the claimed rewards
   * @param amount Amount to claim
   **/
  function claimRewardsOnBehalf(
    address from,
    address to,
    uint256 amount
  ) external returns (uint256);

  /**
   * @dev Redeems shares for a user. Only the claim helper contract is allowed to call this function
   * @param from Address to redeem from
   * @param to Address to redeem to
   * @param amount Amount of shares to redeem
   **/
  function redeemOnBehalf(
    address from,
    address to,
    uint256 amount
  ) external;

  /**
   * @dev Claims an `amount` of `REWARD_TOKEN` and restakes
   * @param to Address to stake to
   * @param amount Amount to claim
   **/
  function claimRewardsAndStake(address to, uint256 amount)
    external
    returns (uint256);

  /**
   * @dev Claims an `amount` of `REWARD_TOKEN` and redeem
   * @param claimAmount Amount to claim
   * @param redeemAmount Amount to redeem
   * @param to Address to claim and unstake to
   **/
  function claimRewardsAndRedeem(
    address to,
    uint256 claimAmount,
    uint256 redeemAmount
  ) external;

  /**
   * @dev Claims an `amount` of `REWARD_TOKEN` and restakes. Only the claim helper contract is allowed to call this function
   * @param from The address of the from from which to claim
   * @param to Address to stake to
   * @param amount Amount to claim
   **/
  function claimRewardsAndStakeOnBehalf(
    address from,
    address to,
    uint256 amount
  ) external returns (uint256);

  /**
   * @dev Claims an `amount` of `REWARD_TOKEN` and redeem. Only the claim helper contract is allowed to call this function
   * @param from The address of the from
   * @param to Address to claim and unstake to
   * @param claimAmount Amount to claim
   * @param redeemAmount Amount to redeem
   **/
  function claimRewardsAndRedeemOnBehalf(
    address from,
    address to,
    uint256 claimAmount,
    uint256 redeemAmount
  ) external;
}
