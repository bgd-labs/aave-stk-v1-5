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
import {StakedTokenV3} from './StakedTokenV3.sol';
import {IGhoVariableDebtToken} from '../interfaces/IGhoVariableDebtToken.sol';
import {StakedTokenV2} from './StakedTokenV2.sol';
import {SafeCast} from '../lib/SafeCast.sol';

/**
 * @title StakedAaveV3
 * @notice StakedTokenV3 with AAVE token as staked token
 * @author BGD Labs
 */
contract StakedAaveV3 is StakedTokenV3 {
  using SafeCast for uint256;
  /// @notice GHO debt token to be used in the _beforeTokenTransfer hook
  IGhoVariableDebtToken public immutable GHO_DEBT_TOKEN;

  uint32 internal _exchangeRateSnapshotsCount;
  /// @notice Snapshots of the exchangeRate for a given block
  mapping(uint256 => ExchangeRateSnapshot) public _exchangeRateSnapshots;

  function REVISION() public pure virtual override returns (uint256) {
    return 4;
  }

  constructor(
    IERC20 stakedToken,
    IERC20 rewardToken,
    uint256 unstakeWindow,
    address rewardsVault,
    address emissionManager,
    uint128 distributionDuration,
    address ghoDebtToken
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
    require(Address.isContract(address(ghoDebtToken)), 'GHO_MUST_BE_CONTRACT');
    GHO_DEBT_TOKEN = IGhoVariableDebtToken(ghoDebtToken);
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
    GHO_DEBT_TOKEN.updateDiscountDistribution(
      from,
      to,
      balanceOf(from),
      balanceOf(to),
      amount
    );
    address votingFromDelegatee = _votingDelegates[from];
    address votingToDelegatee = _votingDelegates[to];

    if (votingFromDelegatee == address(0)) {
      votingFromDelegatee = from;
    }
    if (votingToDelegatee == address(0)) {
      votingToDelegatee = to;
    }

    _moveDelegatesByType(
      votingFromDelegatee,
      votingToDelegatee,
      amount,
      DelegationType.VOTING_POWER
    );

    address propPowerFromDelegatee = _propositionPowerDelegates[from];
    address propPowerToDelegatee = _propositionPowerDelegates[to];

    if (propPowerFromDelegatee == address(0)) {
      propPowerFromDelegatee = from;
    }
    if (propPowerToDelegatee == address(0)) {
      propPowerToDelegatee = to;
    }

    _moveDelegatesByType(
      propPowerFromDelegatee,
      propPowerToDelegatee,
      amount,
      DelegationType.PROPOSITION_POWER
    );
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
      ) * EXCHANGE_RATE_UNIT) /
      _binarySearchExchangeRate(
        _exchangeRateSnapshots,
        _exchangeRateSnapshotsCount,
        blockNumber
      );
  }

  /**
   * @dev Updates the exchangeRate and emits events accordingly
   * @param newExchangeRate the new exchange rate
   */
  function _updateExchangeRate(uint216 newExchangeRate) internal override {
    _exchangeRateSnapshots[_exchangeRateSnapshotsCount] = ExchangeRateSnapshot(
      block.number.toUint40(),
      newExchangeRate
    );
    ++_exchangeRateSnapshotsCount;
    super._updateExchangeRate(newExchangeRate);
  }

  function _binarySearchExchangeRate(
    mapping(uint256 => ExchangeRateSnapshot) storage snapshots,
    uint256 snapshotsCount,
    uint256 blockNumber
  ) internal view returns (uint256) {
    unchecked {
      // First check most recent balance
      if (snapshots[snapshotsCount - 1].blockNumber <= blockNumber) {
        return snapshots[snapshotsCount - 1].value;
      }

      uint256 lower = 0;
      uint256 upper = snapshotsCount - 1;
      while (upper > lower) {
        uint256 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
        ExchangeRateSnapshot memory snapshot = snapshots[center];
        if (snapshot.blockNumber == blockNumber) {
          return snapshot.value;
        } else if (snapshot.blockNumber < blockNumber) {
          lower = center;
        } else {
          upper = center - 1;
        }
      }
      return snapshots[lower].value;
    }
  }
}
