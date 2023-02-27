// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import {SafeCast} from '../src/lib/SafeCast.sol';

contract ExchangeRateMock is Test {
  using SafeCast for uint256;

  uint256 public constant TOKEN_UNIT = 1e18;

  uint216 internal _currentExchangeRate;

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
    returns (uint216)
  {
    return
      (((totalShares * TOKEN_UNIT) + totalAssets - 1) / totalAssets)
        .toUint216();
  }

  /**
   * @dev Updates the exchangeRate and emits events accordingly
   * @param newExchangeRate the new exchange rate
   */
  function _updateExchangeRate(uint216 newExchangeRate) internal virtual {
    _currentExchangeRate = newExchangeRate;
  }
}

contract ExchangeRateTest is Test, ExchangeRateMock {
  /**
   * Test to account for https://github.com/bgd-labs/aave-stk-slashing-mgmt/issues/8
   */
  function test_firstDepositor() public {
    _currentExchangeRate = 1 ether;
    uint256 initialAmount = 1 ether;
    uint256 refundAmount = 501 ether;

    _updateExchangeRate(
      _getExchangeRate(initialAmount + refundAmount, initialAmount)
    );
    _testRefund(refundAmount, initialAmount);

    assertLe(previewRedeem(initialAmount), refundAmount + initialAmount);
  }

  // FUZZ
  /**
   * Quantifying issue on function returnFunds(uint256 amount)  by fuzzing internal exchangeRateCalculation
   * @param amount uint256 amount of funds returned
   * @param shares uint256 totalSupply()
   * Under the following conditions:
   * - 1:1 exchangeRate
   * - a single returnFunds, returning no more than 10^9 of current funds
   * The overall error will not succeed 10^-9 of total assets
   */
  function test_returnFunds(uint96 amount, uint96 shares) public {
    vm.assume(shares >= 1 ether);
    vm.assume(amount >= 1 ether);
    vm.assume(amount <= uint256(shares) * 1 gwei);
    _testRefund(amount, shares);
  }

  /**
   * Quantifying issue on function slash(uint256 amount) by fuzzing internal exchangeRateCalculation
   * @param amount uint256 amount of funds returned
   * @param shares uint256 totalSupply()
   * Under the following conditions:
   * - 1:1 exchangeRate
   * - a single slashing, slashing no more than 99% of assets
   * The overall error will not succeed 10^-9 of total assets
   */
  function test_slash(uint96 amount, uint96 shares) public {
    vm.assume(shares >= 1 ether);
    vm.assume(amount > 0);
    vm.assume(amount < (uint256(shares) * 99) / 100);
    _currentExchangeRate = 1 ether;

    _updateExchangeRate(_getExchangeRate(shares - amount, shares));

    assertLe(previewRedeem(shares), shares - amount);
    assertApproxEqAbs(
      previewRedeem(shares),
      shares - amount,
      (shares - amount) / 1 gwei
    );
  }

  function _testRefund(uint256 amount, uint256 shares) public {
    _currentExchangeRate = 1 ether;

    _updateExchangeRate(_getExchangeRate(shares + amount, shares));
    assertLe(previewRedeem(shares), shares + amount);
    assertApproxEqAbs(
      previewRedeem(shares),
      shares + amount,
      (shares + amount) / 1 gwei
    );
  }
}
