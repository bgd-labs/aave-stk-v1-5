// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;

import {ITransferHook} from '../interfaces/ITransferHook.sol';

/**
 * @title ERC20WithSnapshot
 * @notice ERC20 including snapshots of balances on transfer-related actions
 * @author Aave
 **/
abstract contract GovernancePowerWithSnapshot {
  struct Snapshot {
    uint128 blockNumber;
    uint128 value;
  }
  /// @dev DEPRECATED
  mapping(address => mapping(uint256 => Snapshot)) public deprecated_votingSnapshots;
  /// @dev DEPRECATED
  mapping(address => uint256) public deprecated_votingSnapshotsCounts;
  /// @dev DEPRECATED
  ITransferHook public deprecated_aaveGovernance;
}
