pragma solidity ^0.8.0;

interface IControllerAaveEcosystemReserve {
  function approve(
    address token,
    address recipient,
    uint256 amount
  ) external;
}
