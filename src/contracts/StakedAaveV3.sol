// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;

// most imports are only here to force import order for better (i.e smaller) diff on flattening
import {IGovernancePowerDelegationToken} from '../interfaces/IGovernancePowerDelegationToken.sol';
import {Context} from '../lib/Context.sol';
import {IERC20} from '../interfaces/IERC20.sol';
import {Address} from '../lib/Address.sol';
import {ERC20} from '../lib/ERC20.sol';
import {ITransferHook} from '../interfaces/ITransferHook.sol';
import {DistributionTypes} from '../lib/DistributionTypes.sol';
import {SafeERC20} from '../lib/SafeERC20.sol';
import {VersionedInitializable} from '../utils/VersionedInitializable.sol';
import {IAaveDistributionManager} from '../interfaces/IAaveDistributionManager.sol';
import {AaveDistributionManager} from './AaveDistributionManager.sol';
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

  constructor(
    IERC20 stakedToken,
    IERC20 rewardToken,
    uint256 cooldownSeconds,
    uint256 unstakeWindow,
    address rewardsVault,
    address emissionManager,
    uint128 distributionDuration,
    address governance,
    address ghoDebtToken
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
  {
    GHO_DEBT_TOKEN = IGhoVariableDebtToken(ghoDebtToken);
  }

  /// @dev Modified version including GHO hook
  /// @inheritdoc StakedTokenV2
  function _beforeTokenTransfer(
    address from,
    address to,
    uint256 amount
  ) internal override {
    if (Address.isContract(address(GHO_DEBT_TOKEN))) {
      GHO_DEBT_TOKEN.updateDiscountDistribution(
        from,
        to,
        balanceOf(from),
        balanceOf(to),
        amount
      );
    }

    address votingFromDelegatee = _votingDelegates[from];
    address votingToDelegatee = _votingDelegates[to];

    if (votingFromDelegatee == address(0)) {
      votingFromDelegatee = from;
    }
    if (votingToDelegatee == address(0)) {
      votingToDelegatee = to;
    }

    _moveDelegatesByType(
      votingFromDelegatee,
      votingToDelegatee,
      amount,
      DelegationType.VOTING_POWER
    );

    address propPowerFromDelegatee = _propositionPowerDelegates[from];
    address propPowerToDelegatee = _propositionPowerDelegates[to];

    if (propPowerFromDelegatee == address(0)) {
      propPowerFromDelegatee = from;
    }
    if (propPowerToDelegatee == address(0)) {
      propPowerToDelegatee = to;
    }

    _moveDelegatesByType(
      propPowerFromDelegatee,
      propPowerToDelegatee,
      amount,
      DelegationType.PROPOSITION_POWER
    );

    // caching the aave governance address to avoid multiple state loads
    ITransferHook aaveGovernance = _aaveGovernance;
    if (address(aaveGovernance) != address(0)) {
      aaveGovernance.onTransfer(from, to, amount);
    }
  }
}
