if [[ "$1" ]]
then
    RULE="--rule $1"
fi

certoraRun harness/StakedAaveV3.sol \
    harness/mocks/DummyERC20Impl.sol \
    harness/mocks/AaveGovernance.sol \
    harness/mocks/GhoVariableDebt_Mock.sol \
    --link StakedAaveV3:STAKED_TOKEN=DummyERC20Impl \
    --link StakedAaveV3:REWARD_TOKEN=DummyERC20Impl \
    --link StakedAaveV3:GHO_DEBT_TOKEN=GhoVariableDebt_Mock \
    --link StakedAaveV3:_aaveGovernance=AaveGovernance \
    --verify StakedAaveV3:specs/staking.spec \
    $RULE \
    --solc solc8.1 \
    --staging \
    --optimistic_loop \
    --loop_iter 3 \
    --send_only \
    --msg "staking" 