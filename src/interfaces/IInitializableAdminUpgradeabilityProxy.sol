// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0;

interface IInitializableAdminUpgradeabilityProxy {
  function upgradeTo(address newImplementation) external;

  function upgradeToAndCall(address newImplementation, bytes calldata data)
    external
    payable;

  function implementation() external returns (address);

  function admin() external returns (address);

  function changeAdmin(address newAdmin) external;
}
