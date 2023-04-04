// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;

import {IERC20} from 'openzeppelin-contracts/contracts/token/ERC20/IERC20.sol';
import {DistributionTypes} from '../lib/DistributionTypes.sol';
import {StakedTokenV3} from './StakedTokenV3.sol';
import {IGhoVariableDebtTokenTransferHook} from '../interfaces/IGhoVariableDebtTokenTransferHook.sol';
import {SafeCast} from '../lib/SafeCast.sol';
import {IStakedAaveV3} from '../interfaces/IStakedAaveV3.sol';
import {IERC20WithPermit} from '../interfaces/IERC20WithPermit.sol';

/**
 * @title StakedAaveV3
 * @notice StakedTokenV3 with AAVE token as staked token
 * @author BGD Labs
 */
contract StakedAaveV3 is StakedTokenV3, IStakedAaveV3 {
  using SafeCast for uint256;

  uint32 internal deprecated_exchangeRateSnapshotsCount;
  /// @notice Snapshots of the exchangeRate for a given block
  mapping(uint256 => ExchangeRateSnapshot)
    public deprecated_exchangeRateSnapshots;

  /// @notice GHO debt token to be used in the _beforeTokenTransfer hook
  IGhoVariableDebtTokenTransferHook public ghoDebtToken;

  function REVISION() public pure virtual override returns (uint256) {
    return 4;
  }

  constructor(
    IERC20 stakedToken,
    IERC20 rewardToken,
    uint256 unstakeWindow,
    address rewardsVault,
    address emissionManager,
    uint128 distributionDuration
  )
    StakedTokenV3(
      stakedToken,
      rewardToken,
      unstakeWindow,
      rewardsVault,
      emissionManager,
      distributionDuration
    )
  {
    // brick initialize
    lastInitializedRevision = REVISION();
  }

  /**
   * @dev Called by the proxy contract
   */
  function initialize(
    address slashingAdmin,
    address cooldownPauseAdmin,
    address claimHelper,
    uint256 maxSlashablePercentage,
    uint256 cooldownSeconds
  ) external override initializer {
    _initialize(
      slashingAdmin,
      cooldownPauseAdmin,
      claimHelper,
      maxSlashablePercentage,
      cooldownSeconds
    );

    // needed to claimRewardsAndStake works without a custom approval each time
    STAKED_TOKEN.approve(address(this), type(uint256).max);
  }

  /// @inheritdoc IStakedAaveV3
  function setGHODebtToken(
    IGhoVariableDebtTokenTransferHook newGHODebtToken
  ) external {
    require(msg.sender == 0xEE56e2B3D491590B5b31738cC34d5232F378a8D5); // Short executor
    ghoDebtToken = newGHODebtToken;
    emit GHODebtTokenChanged(address(newGHODebtToken));
  }

  /// @inheritdoc IStakedAaveV3
  function claimRewardsAndStake(
    address to,
    uint256 amount
  ) external override returns (uint256) {
    return _claimRewardsAndStakeOnBehalf(msg.sender, to, amount);
  }

  /// @inheritdoc IStakedAaveV3
  function claimRewardsAndStakeOnBehalf(
    address from,
    address to,
    uint256 amount
  ) external override onlyClaimHelper returns (uint256) {
    return _claimRewardsAndStakeOnBehalf(from, to, amount);
  }

  /// @inheritdoc IStakedAaveV3
  function stakeWithPermit(
    address from,
    uint256 amount,
    uint256 deadline,
    uint8 v,
    bytes32 r,
    bytes32 s
  ) external override {
    IERC20WithPermit(address(STAKED_TOKEN)).permit(
      from,
      address(this),
      amount,
      deadline,
      v,
      r,
      s
    );
    _stake(from, from, amount);
  }

  /**
   * @dev Writes a snapshot before any operation involving transfer of value: _transfer, _mint and _burn
   * - On _transfer, it writes snapshots for both "from" and "to"
   * - On _mint, only for _to
   * - On _burn, only for _from
   * @param from the from address
   * @param to the to address
   * @param amount the amount to transfer
   */
  function _beforeTokenTransfer(
    address from,
    address to,
    uint256 amount
  ) internal override {
    IGhoVariableDebtTokenTransferHook cachedGhoDebtToken = ghoDebtToken;
    if (address(cachedGhoDebtToken) != address(0)) {
      try
        cachedGhoDebtToken.updateDiscountDistribution(
          from,
          to,
          balanceOf(from),
          balanceOf(to),
          amount
        )
      {} catch (bytes memory) {}
    }
  }
}
