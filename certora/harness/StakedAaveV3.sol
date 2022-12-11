// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;

// most imports are only here to force import order for better (i.e smaller) diff on flattening
import {Context} from '../../src/lib/Context.sol';
import {IERC20} from '../../src/interfaces/IERC20.sol';
import {ERC20} from '../../src/lib/ERC20.sol';
import {ITransferHook} from '../../src/interfaces/ITransferHook.sol';
import {DistributionTypes} from '../../src/lib/DistributionTypes.sol';
import {Address} from '../../src/lib/Address.sol';
import {SafeERC20} from '../../src/lib/SafeERC20.sol';
import {VersionedInitializable} from '../../src/utils/VersionedInitializable.sol';
import {IAaveDistributionManager} from '../../src/interfaces/IAaveDistributionManager.sol';
import {AaveDistributionManager} from './AaveDistributionManager.sol';
import {IGovernancePowerDelegationToken} from '../../src/interfaces/IGovernancePowerDelegationToken.sol';
import {GovernancePowerDelegationERC20} from '../../src/lib/GovernancePowerDelegationERC20.sol';
import {GovernancePowerWithSnapshot} from '../../src/lib/GovernancePowerWithSnapshot.sol';
import {StakedTokenV3} from './StakedTokenV3.sol';
import {IGhoVariableDebtToken} from '../../src/interfaces/IGhoVariableDebtToken.sol';
import {StakedTokenV2} from './StakedTokenV2.sol';

/**
 * @title StakedAaveV3
 * @notice StakedTokenV3 with AAVE token as staked token
 * @author BGD Labs
 */
contract StakedAaveV3 is StakedTokenV3 {
  /// @notice GHO debt token to be used in the _beforeTokenTransfer hook
  /* solhint-disable var-name-mixedcase */ 
  IGhoVariableDebtToken public immutable GHO_DEBT_TOKEN;

  /// @notice Snapshots of the exchangeRate for a given block
  mapping(uint256 => Snapshot) public _exchangeRateSnapshots;
  uint120 internal _exchangeRateSnapshotsCount;

  /* solhint-disable func-name-mixedcase */
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
      ) * TOKEN_UNIT) /
      _binarySearch(
        _exchangeRateSnapshots,
        _exchangeRateSnapshotsCount,
        blockNumber
      );
  }

  /**
   * @dev Updates the exchangeRate and emits events accordingly
   * @param newExchangeRate the new exchange rate
   */
  function _updateExchangeRate(uint128 newExchangeRate) internal override {
    _exchangeRateSnapshots[_exchangeRateSnapshotsCount] = Snapshot(
      uint128(block.number),
      newExchangeRate
    );
    ++_exchangeRateSnapshotsCount;
    super._updateExchangeRate(newExchangeRate);
  }
}
