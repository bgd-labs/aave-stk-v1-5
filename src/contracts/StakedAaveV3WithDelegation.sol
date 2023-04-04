// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;

import {IERC20} from '../interfaces/IERC20.sol';
import {DistributionTypes} from '../lib/DistributionTypes.sol';
import {StakedTokenV3} from './StakedTokenV3.sol';
import {IGhoVariableDebtTokenTransferHook} from '../interfaces/IGhoVariableDebtTokenTransferHook.sol';
import {SafeCast} from '../lib/SafeCast.sol';
import {StakedAaveV3} from './StakedAaveV3.sol';
import {BaseDelegation} from 'aave-token-v3/BaseDelegation.sol';
import {IERC20WithPermit} from '../interfaces/IERC20WithPermit.sol';

/**
 * @title StakedAaveV3WithDelegation
 * @notice StakedTokenV3 with AAVE token as staked token
 * @author BGD Labs
 */
contract StakedAaveV3WithDelegation is StakedAaveV3, BaseDelegation {
  mapping(address => DelegationState) internal _delegatedState;

  function REVISION() public pure virtual override returns (uint256) {
    return 5;
  }

  constructor(
    IERC20 stakedToken,
    IERC20 rewardToken,
    uint256 unstakeWindow,
    address rewardsVault,
    address emissionManager,
    uint128 distributionDuration
  )
    StakedAaveV3(
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

  function _getDomainSeparator() internal view override returns (bytes32) {
    return DOMAIN_SEPARATOR;
  }

  function _getDelegationState(
    address user
  ) internal view override returns (DelegationState memory) {
    return _delegatedState[user];
  }

  function _getBalance(address user) internal view override returns (uint256) {
    return balanceOf(user);
  }

  function _setDelegationState(
    address user,
    DelegationState memory delegationState
  ) internal override {
    _delegatedState[user] = delegationState;
  }

  function _incrementNonces(address user) internal override returns (uint256) {
    unchecked {
      // Does not make sense to check because it's not realistic to reach uint256.max in nonce
      return _nonces[user]++;
    }
  }

  /**
   * @notice Overrides the parent _transfer to force validated transfer() and delegation balance transfers
   * @param from The source address
   * @param to The destination address
   * @param amount The amount getting transferred
   */
  function _transfer(address from, address to, uint128 amount) internal {
    _delegationChangeOnTransfer(
      from,
      to,
      _getBalance(from),
      _getBalance(to),
      amount
    );
    _transfer(from, to, uint256(amount));
  }
}
