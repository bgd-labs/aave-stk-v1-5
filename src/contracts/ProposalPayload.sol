// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;

import {AaveGovernanceV2} from 'aave-address-book/AaveGovernanceV2.sol';
import {ProxyAdmin, TransparentUpgradeableProxy} from 'openzeppelin-contracts/contracts/proxy/transparent/ProxyAdmin.sol';
import {StakedAaveV3} from './StakedAaveV3.sol';
import {StakedTokenV3} from './StakedTokenV3.sol';
import {IERC20} from '../interfaces/IERC20.sol';
import {IInitializableAdminUpgradeabilityProxy} from '../interfaces/IInitializableAdminUpgradeabilityProxy.sol';
import {IGhoVariableDebtToken} from '../interfaces/IGhoVariableDebtToken.sol';

contract GhoDebtMock is IGhoVariableDebtToken {
  function updateDiscountDistribution(
    address sender,
    address recipient,
    uint256 senderDiscountTokenBalance,
    uint256 recipientDiscountTokenBalance,
    uint256 amount
  ) public {}
}

contract GenericProposal {
  address public constant SLASHING_ADMIN = AaveGovernanceV2.SHORT_EXECUTOR;

  address public constant COOLDOWN_ADMIN = AaveGovernanceV2.SHORT_EXECUTOR;

  address public constant CLAIM_HELPER = AaveGovernanceV2.SHORT_EXECUTOR;

  uint256 public constant MAX_SLASHING = 3000; // 30%

  uint256 public constant COOLDOWN_SECONDS = 864000; // 10 days

  uint256 public constant UNSTAKE_WINDOW = 172800; // 2 days

  uint128 public constant DISTRIBUTION_DURATION = 3155692600; // 100 years
}

/**
 * @title ProposalPayloadStkAave
 * @notice Proposal for upgrading the StkAave implementation
 * @author BGD Labs
 **/
contract ProposalPayloadStkAave is GenericProposal {
  address public constant STAKE_AAVE =
    0x4da27a545c0c5B758a6BA100e3a049001de870f5;

  function execute() external {
    // 1. deploy new proxy
    ProxyAdmin newAdmin = new ProxyAdmin();
    // 2. move ownership of current token to new proxy
    IInitializableAdminUpgradeabilityProxy(STAKE_AAVE).changeAdmin(
      address(newAdmin)
    );
    // ~ ARBITRARY STEP NEEDS TO BE REMOVED ONCE GHO IS LIVE ~
    GhoDebtMock ghoMock = new GhoDebtMock();
    // 3. deploy newimplementation
    StakedAaveV3 newImpl = new StakedAaveV3(
      IERC20(0x7Fc66500c84A76Ad7e9c93437bFc5Ac33E2DDaE9),
      IERC20(0x7Fc66500c84A76Ad7e9c93437bFc5Ac33E2DDaE9),
      UNSTAKE_WINDOW,
      0x25F2226B597E8F9514B3F68F00f494cF4f286491,
      0xEE56e2B3D491590B5b31738cC34d5232F378a8D5,
      DISTRIBUTION_DURATION,
      address(ghoMock)
    );
    // 4. initialize for safety reasons
    newImpl.initialize(
      SLASHING_ADMIN,
      COOLDOWN_ADMIN,
      CLAIM_HELPER,
      MAX_SLASHING,
      COOLDOWN_SECONDS
    );
    // 5. upgrade & initialize on proxy
    newAdmin.upgradeAndCall(
      TransparentUpgradeableProxy(payable(STAKE_AAVE)),
      address(newImpl),
      abi.encodeWithSignature(
        'initialize(address,address,address,uint256,uint256)',
        SLASHING_ADMIN,
        COOLDOWN_ADMIN,
        CLAIM_HELPER,
        MAX_SLASHING,
        COOLDOWN_SECONDS
      )
    );
  }
}

/**
 * @title ProposalPayloadStkAbpt
 * @notice Proposal for upgrading the StkAbpt implementation
 * @author BGD Labs
 **/
contract ProposalPayloadStkAbpt is GenericProposal {
  address public constant STAKE_ABPT =
    0xa1116930326D21fB917d5A27F1E9943A9595fb47;

  function execute() external {
    // 1. deploy new proxy
    ProxyAdmin newAdmin = new ProxyAdmin();
    // 2. move ownership of current token to new proxy
    IInitializableAdminUpgradeabilityProxy(STAKE_ABPT).changeAdmin(
      address(newAdmin)
    );
    // 3. deploy newimplementation
    StakedTokenV3 newImpl = new StakedTokenV3(
      IERC20(0x41A08648C3766F9F9d85598fF102a08f4ef84F84),
      IERC20(0x7Fc66500c84A76Ad7e9c93437bFc5Ac33E2DDaE9),
      UNSTAKE_WINDOW,
      0x25F2226B597E8F9514B3F68F00f494cF4f286491,
      0xEE56e2B3D491590B5b31738cC34d5232F378a8D5,
      DISTRIBUTION_DURATION
    );
    // 4. initialize for safety reasons
    newImpl.initialize(
      SLASHING_ADMIN,
      COOLDOWN_ADMIN,
      CLAIM_HELPER,
      MAX_SLASHING,
      COOLDOWN_SECONDS
    );
    // 5. upgrade & initialize on proxy
    newAdmin.upgradeAndCall(
      TransparentUpgradeableProxy(payable(STAKE_ABPT)),
      address(newImpl),
      abi.encodeWithSignature(
        'initialize(address,address,address,uint256,uint256)',
        SLASHING_ADMIN,
        COOLDOWN_ADMIN,
        CLAIM_HELPER,
        MAX_SLASHING,
        COOLDOWN_SECONDS
      )
    );
  }
}
