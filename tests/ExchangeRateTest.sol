// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import {StakedTokenV3} from '../src/contracts/StakedTokenV3.sol';
import {BaseTest} from './BaseTest.sol';

contract ExchangeRateMock {
  uint256 public constant TOKEN_UNIT = 1e18;

  uint128 internal _currentExchangeRate;

  function previewRedeem(uint256 shares) public view returns (uint256) {
    return (TOKEN_UNIT * shares) / _currentExchangeRate;
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
   * @dev Updates the exchangeRate and emits events accordingly
   * @param newExchangeRate the new exchange rate
   */
  function _updateExchangeRate(uint128 newExchangeRate) internal virtual {
    _currentExchangeRate = newExchangeRate;
  }
}

contract ExchangeRateTest is Test, ExchangeRateMock {
  /**
   * Quantifying issue on returnFunds
   * function returnFunds(uint256 amount) external override
   * @param amount uint256 amount of funds returned
   * @param shares uint256 totalSupply()
   * For this purpose assuming a start with 1:1 exchangeRate
   */
  function test_returnFunds(uint128 amount, uint128 shares) public {
    vm.assume(amount != 0);
    vm.assume(shares != 0);
    _currentExchangeRate = 1 ether;

    _updateExchangeRate(_getExchangeRate(shares + amount, shares));

    console.log(_currentExchangeRate);
    assertLe(previewRedeem(shares), shares + amount);
  }

  /**
   * Quantifying issue on returnFunds
   * function returnFunds(uint256 amount) external override
   * @param amount uint256 amount of funds returned
   * @param shares uint256 totalSupply()
   * For this purpose assuming a start with 1:1 exchangeRate
   */
  function test_slash(uint128 amount, uint128 shares) public {
    vm.assume(amount != 0);
    vm.assume(shares != 0);
    vm.assume(amount < shares);
    _currentExchangeRate = 1 ether;

    _updateExchangeRate(_getExchangeRate(shares - amount, shares));

    console.log(_currentExchangeRate);
    assertLe(previewRedeem(shares), shares - amount);
  }
}
