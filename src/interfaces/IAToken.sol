pragma solidity ^0.8.0;

interface IAToken {
  function getScaledUserBalanceAndSupply(address user)
    external
    view
    returns (uint256, uint256);
}
