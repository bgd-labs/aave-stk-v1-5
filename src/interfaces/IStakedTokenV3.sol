// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;

import {IStakedToken} from './IStakedToken.sol';

interface IStakedTokenV3 is IStakedToken {
  struct CooldownTimes {
    uint40 cooldownSeconds;
    uint40 slashingExitWindowSeconds;
  }

  event Staked(
    address indexed from,
    address indexed to,
    uint256 amount,
    uint256 shares
  );
  event Redeem(
    address indexed from,
    address indexed to,
    uint256 amount,
    uint256 shares
  );
  event CooldownPauseChanged(bool pause);
  event MaxSlashablePercentageChanged(uint256 newPercentage);
  event Slashed(address indexed destination, uint256 amount);
  event CooldownPauseAdminChanged(address indexed newAdmin);
  event SlashingAdminChanged(address indexed newAdmin);
  event SlashingExitWindowDurationChanged(uint256 windowSeconds);
  event CooldownSecondsChanged(uint256 cooldownSeconds);

  function exchangeRate() external view returns (uint256);

  function getCooldownPaused() external view returns (bool);

  function setCooldownPause(bool paused) external;

  function slash(address destination, uint256 amount) external;

  function getSlashingExitWindowSeconds() external view returns (uint40);

  function setSlashingExitWindowSeconds(uint40 slashingExitWindowSeconds)
    external;

  function getCooldownSeconds() external view returns (uint40);

  function setCooldownSeconds(uint40 cooldownSeconds) external;

  function getMaxSlashablePercentage() external view returns (uint256);

  function setMaxSlashablePercentage(uint256 percentage) external;

  function stakeWithPermit(
    address from,
    address to,
    uint256 amount,
    uint256 deadline,
    uint8 v,
    bytes32 r,
    bytes32 s
  ) external;

  function claimRewardsOnBehalf(
    address from,
    address to,
    uint256 amount
  ) external returns (uint256);

  function redeemOnBehalf(
    address from,
    address to,
    uint256 amount
  ) external;

  function claimRewardsAndStake(address to, uint256 amount)
    external
    returns (uint256);

  function claimRewardsAndRedeem(
    address to,
    uint256 claimAmount,
    uint256 redeemAmount
  ) external;

  function claimRewardsAndStakeOnBehalf(
    address from,
    address to,
    uint256 amount
  ) external returns (uint256);

  function claimRewardsAndRedeemOnBehalf(
    address from,
    address to,
    uint256 claimAmount,
    uint256 redeemAmount
  ) external;
}
