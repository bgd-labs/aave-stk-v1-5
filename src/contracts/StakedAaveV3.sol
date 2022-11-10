// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;

// most imports are only here to force import order for better (i.e smaller) diff on flattening
import {Context} from '../lib/Context.sol';
import {IERC20} from '../interfaces/IERC20.sol';
import {ERC20} from '../lib/ERC20.sol';
import {ITransferHook} from '../interfaces/ITransferHook.sol';
import {DistributionTypes} from '../lib/DistributionTypes.sol';
import {Address} from '../lib/Address.sol';
import {SafeERC20} from '../lib/SafeERC20.sol';
import {VersionedInitializable} from '../utils/VersionedInitializable.sol';
import {IAaveDistributionManager} from '../interfaces/IAaveDistributionManager.sol';
import {AaveDistributionManager} from './AaveDistributionManager.sol';
import {IGovernancePowerDelegationToken} from '../interfaces/IGovernancePowerDelegationToken.sol';
import {GovernancePowerDelegationERC20} from '../lib/GovernancePowerDelegationERC20.sol';
import {GovernancePowerWithSnapshot} from '../lib/GovernancePowerWithSnapshot.sol';
import {StakedTokenV3} from './StakedTokenV3.sol';
import {IGhoVariableDebtToken} from '../interfaces/IGhoVariableDebtToken.sol';
import {StakedTokenV2} from './StakedTokenV2.sol';

/**
 * @title StakedAaveV3
 * @notice StakedTokenV3 with AAVE token as staked token
 * @author Aave
 **/
contract StakedAaveV3 is StakedTokenV3 {
  string internal constant NAME = 'Staked Aave';
  string internal constant SYMBOL = 'stkAAVE';
  uint8 internal constant DECIMALS = 18;

  // GHO
  IGhoVariableDebtToken public immutable GHO_DEBT_TOKEN;

  function REVISION() public pure virtual override returns (uint256) {
    return 4;
  }

  constructor(
    IERC20 stakedToken,
    IERC20 rewardToken,
    uint256 unstakeWindow,
    address rewardsVault,
    address emissionManager,
    uint128 distributionDuration,
    address governance,
    address ghoDebtToken
  )
    StakedTokenV3(
      stakedToken,
      rewardToken,
      unstakeWindow,
      rewardsVault,
      emissionManager,
      distributionDuration,
      NAME,
      SYMBOL,
      governance
    )
  {
    require(Address.isContract(address(ghoDebtToken)), 'GHO_MUST_BE_CONTRACT');
    GHO_DEBT_TOKEN = IGhoVariableDebtToken(ghoDebtToken);
  }

  /// @dev Modified version including GHO hook
  /// @inheritdoc StakedTokenV2
  function _beforeTokenTransfer(
    address from,
    address to,
    uint256 amount
  ) internal override {
    GHO_DEBT_TOKEN.updateDiscountDistribution(
      from,
      to,
      balanceOf(from),
      balanceOf(to),
      amount
    );
    super._beforeTokenTransfer(from, to, amount);
  }
}
