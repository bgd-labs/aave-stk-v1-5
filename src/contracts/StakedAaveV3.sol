// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;

// most imports are only here to force import order for better (i.e smaller) diff on flattening
import {IGovernancePowerDelegationToken} from '../interfaces/IGovernancePowerDelegationToken.sol';
import {Context} from '../lib/Context.sol';
import {IERC20} from '../interfaces/IERC20.sol';
import {Address} from '../lib/Address.sol';
import {ERC20} from '../lib/ERC20.sol';
import {IStakedAave} from '../interfaces/IStakedAave.sol';
import {ITransferHook} from '../interfaces/ITransferHook.sol';
import {DistributionTypes} from '../lib/DistributionTypes.sol';
import {SafeERC20} from '../lib/SafeERC20.sol';
import {VersionedInitializable} from '../utils/VersionedInitializable.sol';
import {IAaveDistributionManager} from '../interfaces/IAaveDistributionManager.sol';
import {AaveDistributionManager} from './AaveDistributionManager.sol';
import {GovernancePowerDelegationERC20} from '../lib/GovernancePowerDelegationERC20.sol';
import {GovernancePowerWithSnapshot} from '../lib/GovernancePowerWithSnapshot.sol';
import {StakedTokenV3} from './StakedTokenV3.sol';

/**
 * @title StakedAaveV3
 * @notice StakedTokenV3 with AAVE token as staked token
 * @author Aave
 **/
contract StakedAaveV3 is StakedTokenV3 {
  string internal constant NAME = 'Staked Aave';
  string internal constant SYMBOL = 'stkAAVE';
  uint8 internal constant DECIMALS = 18;

  constructor(
    IERC20 stakedToken,
    IERC20 rewardToken,
    uint256 cooldownSeconds,
    uint256 unstakeWindow,
    address rewardsVault,
    address emissionManager,
    uint128 distributionDuration,
    address governance
  )
    public
    StakedTokenV3(
      stakedToken,
      rewardToken,
      cooldownSeconds,
      unstakeWindow,
      rewardsVault,
      emissionManager,
      distributionDuration,
      NAME,
      SYMBOL,
      governance
    )
  {}
}
