import "base.spec"

// stkAmount_t1 = amount * exchangeRate_t0 / 1e18
rule integrityOfStaking(address onBehalfOf, uint256 amount) {
    env e;
    require(amount < AAVE_MAX_SUPPLY());
    require(e.msg.sender != currentContract);

    uint256 balanceStakeTokenDepositorBefore = stake_token.balanceOf(e.msg.sender);
    uint256 balanceStakeTokenVaultBefore = stake_token.balanceOf(currentContract);
    uint256 balanceBefore = balanceOf(onBehalfOf);
    require(balanceStakeTokenDepositorBefore < AAVE_MAX_SUPPLY());
    require(balanceStakeTokenVaultBefore < AAVE_MAX_SUPPLY());
    require(balanceBefore < AAVE_MAX_SUPPLY());
    stake(e, onBehalfOf, amount);
    uint256 balanceAfter = balanceOf(onBehalfOf);
    uint256 balanceStakeTokenDepositorAfter = stake_token.balanceOf(e.msg.sender);
    uint256 balanceStakeTokenVaultAfter = stake_token.balanceOf(currentContract);

    uint128 currentExchangeRate = getExchangeRate();

    assert balanceAfter == balanceBefore + 
        amount * currentExchangeRate / EXCHANGE_RATE_FACTOR();
    assert balanceStakeTokenDepositorAfter == balanceStakeTokenDepositorBefore - amount;
    assert balanceStakeTokenVaultAfter == balanceStakeTokenVaultBefore + amount;
}

rule noStakingPostSlashingPeriod(address onBehalfOf, uint256 amount) {
    env e;
    require(inPostSlashingPeriod());
    stake@withrevert(e, onBehalfOf, amount);
    assert lastReverted, "shouldn not be able to stake in post slashing period";
}