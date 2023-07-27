// SPDX-License-Identifier: MIT

/**

  This is an extension of the AaveTokenV3 with added getters on the _balances fields

 */

pragma solidity ^0.8.0;


import {StakedAaveV3} from '../munged/src/contracts/StakedAaveV3.sol';
import {IERC20} from 'openzeppelin-contracts/contracts/token/ERC20/IERC20.sol';

import {DelegationMode} from 'aave-token-v3/DelegationAwareBalance.sol';
import {BaseDelegation} from 'aave-token-v3/BaseDelegation.sol';

contract AaveTokenV3Harness is StakedAaveV3 {
    constructor(IERC20 stakedToken, IERC20 rewardToken, uint256 unstakeWindow, address rewardsVault,
                address emissionManager, uint128 distributionDuration)
        StakedAaveV3(stakedToken, rewardToken, unstakeWindow, rewardsVault,
                    emissionManager, distributionDuration) {}

    // Returns amount of the cooldown initiated by the user.
    function cooldownAmount(address user) public view returns (uint216) {
        return stakersCooldowns[user].amount;
    }

    // Returns timestamp of the cooldown initiated by the user.
    function cooldownTimestamp(address user) public view returns (uint40) {
        return stakersCooldowns[user].timestamp;
    }

    // Returns the asset's emission per second from the sturct
    function getAssetEmissionPerSecond(address token) public view returns (uint128) {
        return assets[token].emissionPerSecond;
    }

    // Returns the asset's last updated timestamp from the sturct
    function getAssetLastUpdateTimestamp(address token) public view returns (uint128) {
        return assets[token].lastUpdateTimestamp;
    }

    // Returns the asset's global index from the sturct
    function getAssetGlobalIndex(address token) public view returns (uint256) {
        return assets[token].index;
    }

    // Returns the user's personal index for the specific asset
    function getUserPersonalIndex(address token, address user) public view returns (uint256) {
        return assets[token].users[user];
    }

    function _getExchangeRateWrapper(uint256 totalAssets, uint256 totalShares) public pure returns (uint216) {
        return _getExchangeRate(totalAssets, totalShares);
    }






    // returns user's token balance, used in some community rules
    function getBalance(address user) public view returns (uint104) {
        return _balances[user].balance;
    }
    
    // returns user's delegated proposition balance
    function getDelegatedPropositionBalance(address user) public view returns (uint72) {
        return _balances[user].delegatedPropositionBalance;
    }

    // returns user's delegated voting balance
    function getDelegatedVotingBalance(address user) public view returns (uint72) {
        return _balances[user].delegatedVotingBalance;
    }

    //returns user's delegating proposition status
    function getDelegatingProposition(address user) public view returns (bool) {
        return
            _balances[user].delegationMode == DelegationMode.PROPOSITION_DELEGATED ||
            _balances[user].delegationMode == DelegationMode.FULL_POWER_DELEGATED;
    }
    
    // returns user's delegating voting status
    function getDelegatingVoting(address user) public view returns (bool) {
        return
            _balances[user].delegationMode == DelegationMode.VOTING_DELEGATED ||
            _balances[user].delegationMode == DelegationMode.FULL_POWER_DELEGATED;
    }
    
    // returns user's voting delegate
    function getVotingDelegate(address user) public view returns (address) {
        return _votingDelegatee[user];
    }
    
    // returns user's proposition delegate
    function getPropositionDelegate(address user) public view returns (address) {
        return _propositionDelegatee[user];
    }
    
    // returns user's delegation state
    function getDelegationMode(address user) public view returns (DelegationMode) {
        return _balances[user].delegationMode;
    }

  function __getPowerCurrent(address user, GovernancePowerType delegationType)
    public
    view
    virtual
    returns (uint256)
  {
      return BaseDelegation.getPowerCurrent(user,delegationType);
  }
}
