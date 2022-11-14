// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;

// most imports are only here to force import order for better (i.e smaller) diff on flattening
import {Context} from '../lib/Context.sol';
import {IERC20} from '../interfaces/IERC20.sol';
import {ERC20} from '../lib/ERC20.sol';
import {ITransferHook} from '../interfaces/ITransferHook.sol';
import {DistributionTypes} from '../lib/DistributionTypes.sol';
import {Address} from '../lib/Address.sol';
import {SafeERC20} from '../lib/SafeERC20.sol';
import {VersionedInitializable} from '../utils/VersionedInitializable.sol';
import {IAaveDistributionManager} from '../interfaces/IAaveDistributionManager.sol';
import {AaveDistributionManager} from './AaveDistributionManager.sol';
import {IGovernancePowerDelegationToken} from '../interfaces/IGovernancePowerDelegationToken.sol';
import {GovernancePowerDelegationERC20} from '../lib/GovernancePowerDelegationERC20.sol';
import {GovernancePowerWithSnapshot} from '../lib/GovernancePowerWithSnapshot.sol';
import {IERC20WithPermit} from '../interfaces/IERC20WithPermit.sol';
import {IStakedToken} from '../interfaces/IStakedToken.sol';
import {StakedTokenV2} from './StakedTokenV2.sol';
import {IStakedTokenV3} from '../interfaces/IStakedTokenV3.sol';
import {PercentageMath} from '../lib/PercentageMath.sol';
import {RoleManager} from '../utils/RoleManager.sol';

/**
 * @title StakedToken
 * @notice Contract to stake Aave token, tokenize the position and get rewards, inheriting from a distribution manager contract
 * @author Aave
 **/
contract StakedTokenV3 is StakedTokenV2, IStakedTokenV3, RoleManager {
  using SafeERC20 for IERC20;
  using PercentageMath for uint256;

  uint256 public constant SLASH_ADMIN_ROLE = 0;
  uint256 public constant COOLDOWN_ADMIN_ROLE = 1;
  uint256 public constant CLAIM_HELPER_ROLE = 2;
  uint128 public constant INITIAL_EXCHANGE_RATE = 1e18;
  uint256 public constant TOKEN_UNIT = 1e18;

  /// @notice Seconds between starting cooldown and being able to withdraw
  uint256 internal _cooldownSeconds;
  /// @notice The maximum amount of funds that can be slashed at any given time
  uint256 internal _maxSlashablePercentage;
  /// @notice Snapshots of the exchangeRate for a given block
  mapping(uint256 => Snapshot) public _exchangeRateSnapshots;
  uint120 internal _exchangeRateSnapshotsCount;
  /// @notice Mirror of latest snapshot value for cheaper access
  uint128 internal _currentExchangeRate;
  /// @notice Flag determining if there's an ongoing slashing event that needs to be settled
  bool public inPostSlashingPeriod;

  modifier onlySlashingAdmin() {
    require(
      msg.sender == getAdmin(SLASH_ADMIN_ROLE),
      'CALLER_NOT_SLASHING_ADMIN'
    );
    _;
  }

  modifier onlyCooldownAdmin() {
    require(
      msg.sender == getAdmin(COOLDOWN_ADMIN_ROLE),
      'CALLER_NOT_COOLDOWN_ADMIN'
    );
    _;
  }

  modifier onlyClaimHelper() {
    require(
      msg.sender == getAdmin(CLAIM_HELPER_ROLE),
      'CALLER_NOT_CLAIM_HELPER'
    );
    _;
  }

  constructor(
    IERC20 stakedToken,
    IERC20 rewardToken,
    uint256 unstakeWindow,
    address rewardsVault,
    address emissionManager,
    uint128 distributionDuration
  )
    StakedTokenV2(
      stakedToken,
      rewardToken,
      unstakeWindow,
      rewardsVault,
      emissionManager,
      distributionDuration
    )
  {}

  function REVISION() public pure virtual override returns (uint256) {
    return 3;
  }

  /**
   * @dev returns the revision of the implementation contract
   * @return The revision
   */
  function getRevision() internal pure virtual override returns (uint256) {
    return REVISION();
  }

  /**
   * @dev Called by the proxy contract
   **/
  function initialize(
    address slashingAdmin,
    address cooldownPauseAdmin,
    address claimHelper,
    uint256 maxSlashablePercentage,
    uint256 cooldownSeconds
  ) external initializer {
    InitAdmin[] memory initAdmins = new InitAdmin[](3);
    initAdmins[0] = InitAdmin(SLASH_ADMIN_ROLE, slashingAdmin);
    initAdmins[1] = InitAdmin(COOLDOWN_ADMIN_ROLE, cooldownPauseAdmin);
    initAdmins[2] = InitAdmin(CLAIM_HELPER_ROLE, claimHelper);

    _initAdmins(initAdmins);

    _setMaxSlashablePercentage(maxSlashablePercentage);
    _setCooldownSeconds(cooldownSeconds);
    _updateExchangeRate(INITIAL_EXCHANGE_RATE);

    // needed to claimRewardsAndStake works without a custom approval each time
    STAKED_TOKEN.approve(address(this), type(uint256).max);
  }

  /// @inheritdoc IStakedTokenV3
  function previewStake(uint256 assets) public view returns (uint256) {
    return (assets * _currentExchangeRate) / TOKEN_UNIT;
  }

  /// @inheritdoc IStakedToken
  function stake(address to, uint256 amount)
    external
    override(IStakedToken, StakedTokenV2)
  {
    _stake(msg.sender, to, amount);
  }

  /// @inheritdoc IStakedTokenV3
  function stakeWithPermit(
    address from,
    address to,
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
    _stake(from, to, amount);
  }

  /// @inheritdoc IStakedToken
  function redeem(address to, uint256 amount)
    external
    override(IStakedToken, StakedTokenV2)
  {
    _redeem(msg.sender, to, amount);
  }

  /// @inheritdoc IStakedTokenV3
  function redeemOnBehalf(
    address from,
    address to,
    uint256 amount
  ) external override onlyClaimHelper {
    _redeem(from, to, amount);
  }

  /// @inheritdoc IStakedToken
  function claimRewards(address to, uint256 amount)
    external
    override(IStakedToken, StakedTokenV2)
  {
    _claimRewards(msg.sender, to, amount);
  }

  /// @inheritdoc IStakedTokenV3
  function claimRewardsOnBehalf(
    address from,
    address to,
    uint256 amount
  ) external override onlyClaimHelper returns (uint256) {
    return _claimRewards(from, to, amount);
  }

  /// @inheritdoc IStakedTokenV3
  function claimRewardsAndStake(address to, uint256 amount)
    external
    override
    returns (uint256)
  {
    return _claimRewardsAndStakeOnBehalf(msg.sender, to, amount);
  }

  /// @inheritdoc IStakedTokenV3
  function claimRewardsAndStakeOnBehalf(
    address from,
    address to,
    uint256 amount
  ) external override onlyClaimHelper returns (uint256) {
    return _claimRewardsAndStakeOnBehalf(from, to, amount);
  }

  /// @inheritdoc IStakedTokenV3
  function claimRewardsAndRedeem(
    address to,
    uint256 claimAmount,
    uint256 redeemAmount
  ) external override {
    _claimRewards(msg.sender, to, claimAmount);
    _redeem(msg.sender, to, redeemAmount);
  }

  /// @inheritdoc IStakedTokenV3
  function claimRewardsAndRedeemOnBehalf(
    address from,
    address to,
    uint256 claimAmount,
    uint256 redeemAmount
  ) external override onlyClaimHelper {
    _claimRewards(from, to, claimAmount);
    _redeem(from, to, redeemAmount);
  }

  /// @inheritdoc IStakedTokenV3
  function getExchangeRate() public view override returns (uint128) {
    return _currentExchangeRate;
  }

  /// @inheritdoc IStakedTokenV3
  function previewRedeem(uint256 shares)
    public
    view
    override
    returns (uint256)
  {
    return (TOKEN_UNIT * shares) / _currentExchangeRate;
  }

  /// @inheritdoc IStakedTokenV3
  function slash(address destination, uint256 amount)
    external
    override
    onlySlashingAdmin
    returns (uint256)
  {
    require(!inPostSlashingPeriod, 'PREVIOUS_SLASHING_NOT_SETTLED');
    uint256 currentShares = totalSupply();
    uint256 balance = previewRedeem(currentShares);

    uint256 maxSlashable = balance.percentMul(_maxSlashablePercentage);

    if (amount > maxSlashable) {
      amount = maxSlashable;
    }

    inPostSlashingPeriod = true;
    _updateExchangeRate(_getExchangeRate(balance - amount, currentShares));

    STAKED_TOKEN.safeTransfer(destination, amount);

    emit Slashed(destination, amount);
    return amount;
  }

  /// @inheritdoc IStakedTokenV3
  function returnFunds(uint256 amount) external override {
    uint256 currentShares = totalSupply();
    uint256 assets = previewRedeem(currentShares);
    _updateExchangeRate(_getExchangeRate(assets + amount, currentShares));

    STAKED_TOKEN.safeTransferFrom(msg.sender, address(this), amount);
    emit FundsReturned(amount);
  }

  /// @inheritdoc IStakedTokenV3
  function settleSlashing() external override {
    inPostSlashingPeriod = false;
    emit SlashingSettled();
  }

  /// @inheritdoc IStakedTokenV3
  function setMaxSlashablePercentage(uint256 percentage)
    external
    override
    onlySlashingAdmin
  {
    _setMaxSlashablePercentage(percentage);
  }

  /// @inheritdoc IStakedTokenV3
  function getMaxSlashablePercentage()
    external
    view
    override
    returns (uint256)
  {
    return _maxSlashablePercentage;
  }

  /// @inheritdoc IStakedTokenV3
  function setCooldownSeconds(uint256 cooldownSeconds)
    external
    onlyCooldownAdmin
  {
    _setCooldownSeconds(cooldownSeconds);
  }

  /// @inheritdoc IStakedTokenV3
  function getCooldownSeconds() external view returns (uint256) {
    return _cooldownSeconds;
  }

  /// @dev sets the max slashable percentage
  /// @param percentage must be strictly lower 100% as otherwise the exchange rate calculation would result in 0 division
  function _setMaxSlashablePercentage(uint256 percentage) internal {
    require(
      percentage < PercentageMath.PERCENTAGE_FACTOR,
      'INVALID_SLASHING_PERCENTAGE'
    );

    _maxSlashablePercentage = percentage;
    emit MaxSlashablePercentageChanged(percentage);
  }

  function _setCooldownSeconds(uint256 cooldownSeconds) internal {
    _cooldownSeconds = cooldownSeconds;
    emit CooldownSecondsChanged(cooldownSeconds);
  }

  function _claimRewards(
    address from,
    address to,
    uint256 amount
  ) internal returns (uint256) {
    require(amount != 0, 'INVALID_ZERO_AMOUNT');
    uint256 newTotalRewards = _updateCurrentUnclaimedRewards(
      from,
      balanceOf(from),
      false
    );

    uint256 amountToClaim = (amount > newTotalRewards)
      ? newTotalRewards
      : amount;

    stakerRewardsToClaim[from] = newTotalRewards - amountToClaim;
    REWARD_TOKEN.safeTransferFrom(REWARDS_VAULT, to, amountToClaim);
    emit RewardsClaimed(from, to, amountToClaim);
    return amountToClaim;
  }

  function _claimRewardsAndStakeOnBehalf(
    address from,
    address to,
    uint256 amount
  ) internal returns (uint256) {
    require(REWARD_TOKEN == STAKED_TOKEN, 'REWARD_TOKEN_IS_NOT_STAKED_TOKEN');

    uint256 userUpdatedRewards = _updateCurrentUnclaimedRewards(
      from,
      balanceOf(from),
      true
    );
    uint256 amountToClaim = (amount > userUpdatedRewards)
      ? userUpdatedRewards
      : amount;

    if (amountToClaim != 0) {
      _claimRewards(from, address(this), amountToClaim);
      _stake(address(this), to, amountToClaim);
    }

    return amountToClaim;
  }

  function _stake(
    address from,
    address to,
    uint256 amount
  ) internal {
    require(inPostSlashingPeriod != true, 'SLASHING_ONGOING');
    require(amount != 0, 'INVALID_ZERO_AMOUNT');

    uint256 balanceOfUser = balanceOf(to);

    uint256 accruedRewards = _updateUserAssetInternal(
      to,
      address(this),
      balanceOfUser,
      totalSupply()
    );

    if (accruedRewards != 0) {
      emit RewardsAccrued(to, accruedRewards);
      stakerRewardsToClaim[to] = stakerRewardsToClaim[to] + accruedRewards;
    }

    stakersCooldowns[to] = getNextCooldownTimestamp(
      0,
      amount,
      to,
      balanceOfUser
    );

    uint256 sharesToMint = previewStake(amount);
    _mint(to, sharesToMint);

    STAKED_TOKEN.safeTransferFrom(from, address(this), amount);

    emit Staked(from, to, amount, sharesToMint);
  }

  /**
   * @dev Calculates the how is gonna be a new cooldown timestamp depending on the sender/receiver situation
   *  - If the timestamp of the sender is "better" or the timestamp of the recipient is 0, we take the one of the recipient
   *  - Weighted average of from/to cooldown timestamps if:
   *    # The sender doesn't have the cooldown activated (timestamp 0).
   *    # The sender timestamp is expired
   *    # The sender has a "worse" timestamp
   *  - If the receiver's cooldown timestamp expired (too old), the next is 0
   * @param fromCooldownTimestamp Cooldown timestamp of the sender
   * @param amountToReceive Amount
   * @param toAddress Address of the recipient
   * @param toBalance Current balance of the receiver
   * @return The new cooldown timestamp
   **/
  function getNextCooldownTimestamp(
    uint256 fromCooldownTimestamp,
    uint256 amountToReceive,
    address toAddress,
    uint256 toBalance
  ) public view override returns (uint256) {
    uint256 toCooldownTimestamp = stakersCooldowns[toAddress];
    if (toCooldownTimestamp == 0) {
      return 0;
    }

    uint256 minimalValidCooldownTimestamp = block.timestamp -
      _cooldownSeconds -
      UNSTAKE_WINDOW;

    if (minimalValidCooldownTimestamp > toCooldownTimestamp) {
      toCooldownTimestamp = 0;
    } else {
      uint256 adjustedFromCooldownTimestamp = (minimalValidCooldownTimestamp >
        fromCooldownTimestamp)
        ? block.timestamp
        : fromCooldownTimestamp;

      if (adjustedFromCooldownTimestamp < toCooldownTimestamp) {
        return toCooldownTimestamp;
      } else {
        toCooldownTimestamp =
          ((amountToReceive * adjustedFromCooldownTimestamp) +
            (toBalance * toCooldownTimestamp)) /
          (amountToReceive + toBalance);
      }
    }
    return toCooldownTimestamp;
  }

  /**
   * @dev Redeems staked tokens, and stop earning rewards
   * @param from Address to redeem from
   * @param to Address to redeem to
   * @param amount Amount to redeem
   **/
  function _redeem(
    address from,
    address to,
    uint256 amount
  ) internal {
    require(amount != 0, 'INVALID_ZERO_AMOUNT');
    //solium-disable-next-line
    uint256 cooldownStartTimestamp = stakersCooldowns[from];

    if (!inPostSlashingPeriod) {
      require(
        (block.timestamp > cooldownStartTimestamp + _cooldownSeconds),
        'INSUFFICIENT_COOLDOWN'
      );
      require(
        (block.timestamp - (cooldownStartTimestamp + _cooldownSeconds) <=
          UNSTAKE_WINDOW),
        'UNSTAKE_WINDOW_FINISHED'
      );
    }
    uint256 balanceOfFrom = balanceOf(from);

    uint256 amountToRedeem = (amount > balanceOfFrom) ? balanceOfFrom : amount;

    _updateCurrentUnclaimedRewards(from, balanceOfFrom, true);

    uint256 underlyingToRedeem = (amountToRedeem * TOKEN_UNIT) /
      _currentExchangeRate;

    _burn(from, amountToRedeem);

    if (balanceOfFrom - amountToRedeem == 0) {
      stakersCooldowns[from] = 0;
    }

    IERC20(STAKED_TOKEN).safeTransfer(to, underlyingToRedeem);

    emit Redeem(from, to, underlyingToRedeem, amountToRedeem);
  }

  /**
   * @dev Updates the exchangeRate and emits events accordingly
   * @param newExchangeRate the new exchange rate
   */
  function _updateExchangeRate(uint128 newExchangeRate) internal {
    _exchangeRateSnapshots[_exchangeRateSnapshotsCount] = Snapshot(
      uint128(block.number),
      newExchangeRate
    );
    ++_exchangeRateSnapshotsCount;
    _currentExchangeRate = newExchangeRate;
    emit ExchangeRateChanged(newExchangeRate);
  }

  /**
   * @dev calculates the exchange rate based on totalAssets and totalShares
   * @dev always rounds up to ensure 100% backing of shares by rounding in favor of the contract
   * @param totalAssets The total amount of assets staked
   * @param totalShares The total amount of shares
   * @return exchangeRate as 18 decimal precision uint128
   */
  function _getExchangeRate(uint256 totalAssets, uint256 totalShares)
    internal
    pure
    returns (uint128)
  {
    return uint128(((totalShares * TOKEN_UNIT) + TOKEN_UNIT) / totalAssets);
  }

  /**
   * @dev searches a snapshot by block number. Uses binary search.
   * @param blockNumber the block number being searched
   * @return exchangeRate at block number
   */
  function _searchExchangeRateByBlockNumber(uint256 blockNumber)
    internal
    view
    returns (uint256)
  {
    require(blockNumber <= block.number, 'INVALID_BLOCK_NUMBER');
    uint256 snapshotsCount = _exchangeRateSnapshotsCount;

    if (snapshotsCount == 0) {
      return INITIAL_EXCHANGE_RATE;
    }

    // First check most recent balance
    if (_exchangeRateSnapshots[snapshotsCount - 1].blockNumber <= blockNumber) {
      return _exchangeRateSnapshots[snapshotsCount - 1].value;
    }

    uint256 lower = 0;
    uint256 upper = snapshotsCount - 1;
    while (upper > lower) {
      uint256 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
      Snapshot memory snapshot = _exchangeRateSnapshots[center];
      if (snapshot.blockNumber == blockNumber) {
        return snapshot.value;
      } else if (snapshot.blockNumber < blockNumber) {
        lower = center;
      } else {
        upper = center - 1;
      }
    }
    return _exchangeRateSnapshots[lower].value;
  }

  /// @dev Modified version accounting for exchange rate at block
  /// @inheritdoc GovernancePowerDelegationERC20
  function _searchByBlockNumber(
    mapping(address => mapping(uint256 => Snapshot)) storage snapshots,
    mapping(address => uint256) storage snapshotsCounts,
    address user,
    uint256 blockNumber
  ) internal view override returns (uint256) {
    return
      (super._searchByBlockNumber(
        snapshots,
        snapshotsCounts,
        user,
        blockNumber
      ) * TOKEN_UNIT) / _searchExchangeRateByBlockNumber(blockNumber);
  }
}
