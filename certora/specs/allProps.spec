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

// should be updated for exchange rate
rule stakeTokenBalanceAtLeastTotalSupply(method f) {
    env e;
    calldataarg args;
    require(e.msg.sender != currentContract);
    require(REWARDS_VAULT() != currentContract);
    uint256 totalBefore = totalSupply();
    uint256 stakeTokenBalanceBefore = stake_token.balanceOf(currentContract);
    require(stakeTokenBalanceBefore >= totalBefore);
    f(e, args);
    uint256 totalAfter = totalSupply();
    uint256 stakeTokenBalanceAfter = stake_token.balanceOf(currentContract);
    assert stakeTokenBalanceAfter >= totalAfter;
}

rule exchangeRateStateTransition(method f){
    env e;
    calldataarg args;
    uint128 exchangeRateBefore = getExchangeRate();
    require(exchangeRateBefore < MAX_EXCHANGE_RATE());
    f(e, args);
    uint128 exchangeRateAfter = getExchangeRate();
    assert exchangeRateBefore != exchangeRateAfter =>
        f.selector == slash(address,uint256).selector ||
        f.selector == returnFunds(uint256).selector ||
        f.selector == initialize(address,address,address,uint256,uint256).selector;

    require(f.selector != initialize(address,address,address,uint256,uint256).selector);
    
    // these properties require finetuning, because of overflow and 
    // rounding by 1 that the contract does

    assert f.selector == slash(address,uint256).selector =>
        exchangeRateAfter >= exchangeRateBefore;
    assert f.selector == returnFunds(uint256).selector =>
        exchangeRateAfter <= exchangeRateBefore;
}


rule noSlashingMoreThanMax(uint256 amount, address recipient){
    env e;
    uint vaultBalanceBefore = stake_token.balanceOf(currentContract);
    require(vaultBalanceBefore < AAVE_MAX_SUPPLY());
    require(getMaxSlashablePercentage() >= PERCENTAGE_FACTOR() &&
        getMaxSlashablePercentage() <= MAX_PERCENTAGE());
    uint256 maxSlashable = vaultBalanceBefore * getMaxSlashablePercentage() / PERCENTAGE_FACTOR();
    
    require (amount > maxSlashable);
    require (recipient != currentContract);
    slash(e, recipient, amount);
    uint vaultBalanceAfter = stake_token.balanceOf(currentContract);

    assert vaultBalanceBefore - vaultBalanceAfter == maxSlashable;
}

rule integrityOfSlashing(address to, uint256 amount){
    env e;
    require(amount < AAVE_MAX_SUPPLY());
    require(e.msg.sender != currentContract && to != currentContract);
    require(getMaxSlashablePercentage() >= PERCENTAGE_FACTOR() &&
        getMaxSlashablePercentage() <= MAX_PERCENTAGE());

    uint256 balanceStakeTokenToBefore = stake_token.balanceOf(to);
    uint256 balanceStakeTokenVaultBefore = stake_token.balanceOf(currentContract);
    require(balanceStakeTokenToBefore < AAVE_MAX_SUPPLY());
    require(balanceStakeTokenVaultBefore < AAVE_MAX_SUPPLY());
    slash(e, to, amount);
    uint256 balanceStakeTokenToAfter = stake_token.balanceOf(to);
    uint256 balanceStakeTokenVaultAfter = stake_token.balanceOf(currentContract);
    uint256 maxSlashable = balanceStakeTokenVaultBefore * getMaxSlashablePercentage() / PERCENTAGE_FACTOR();

    uint256 amountToSlash;
    if (amount > maxSlashable) {
        amountToSlash = maxSlashable;
    } else {
        amountToSlash = amount;
    }

    assert balanceStakeTokenToAfter == balanceStakeTokenToBefore + amountToSlash;
    assert balanceStakeTokenVaultAfter == balanceStakeTokenVaultBefore - amountToSlash;
    assert inPostSlashingPeriod();
    require(totalSupply() > 0);

    // doesn't work - should be proven with invariant or dedicated rule for exchange rate change
    assert getExchangeRate() == (balanceStakeTokenVaultBefore - amountToSlash) / totalSupply();
}

rule integrityOfReturnFunds(uint256 amount){
    env e;
    require(amount < AAVE_MAX_SUPPLY());
    require(e.msg.sender != currentContract);

    uint256 balanceStakeTokenSenderBefore = stake_token.balanceOf(e.msg.sender);
    uint256 balanceStakeTokenVaultBefore = stake_token.balanceOf(currentContract);
    require(balanceStakeTokenSenderBefore < AAVE_MAX_SUPPLY());
    require(balanceStakeTokenVaultBefore < AAVE_MAX_SUPPLY());
    returnFunds(e, amount);
    uint256 balanceStakeTokenSenderAfter = stake_token.balanceOf(e.msg.sender);
    uint256 balanceStakeTokenVaultAfter = stake_token.balanceOf(currentContract);

    assert balanceStakeTokenSenderAfter == balanceStakeTokenSenderBefore - amount;
    assert balanceStakeTokenVaultAfter == balanceStakeTokenVaultBefore + amount;
}

rule noEntryUntilSlashingSettled(uint256 amount){
    env e;
    require(stake_token.balanceOf(e.msg.sender) >= amount);
    require(amount > 0);
    require(e.msg.sender != currentContract && e.msg.sender != 0);

    stake@withrevert(e, e.msg.sender, amount);

    assert lastReverted <=> inPostSlashingPeriod();
}

// transfer tokens to the contract and assert the exchange rate doesn't change
rule airdropNotMutualized(uint256 amount){
    env e;
    uint256 exchangeRateBefore = getExchangeRate();
    stake_token.transfer(e, currentContract, amount);
    uint256 exchangeRateAfter = getExchangeRate();
    assert exchangeRateBefore == exchangeRateAfter;
}

// if redeem succeeds, the cooldown is inside the unstake window
rule noRedeemOutOfUnstakeWindow(address to, uint256 amount){
    env e;

    uint256 cooldown = stakersCooldowns(e.msg.sender);
    redeem(e, to, amount);

    // assert cooldown is inside the unstake window or it's a post slashing period
    assert inPostSlashingPeriod() ||
     (e.block.timestamp > cooldown + getCooldownSeconds() &&
        e.block.timestamp - (cooldown + getCooldownSeconds()) <= UNSTAKE_WINDOW());   
}

rule integrityOfRedeem(address to, uint256 amount){
    env e;
    require(amount < AAVE_MAX_SUPPLY());
    require(e.msg.sender != currentContract && to != currentContract);

    uint256 balanceStakeTokenToBefore = stake_token.balanceOf(to);
    uint256 balanceStakeTokenVaultBefore = stake_token.balanceOf(currentContract);
    uint256 balanceBefore = balanceOf(e.msg.sender);
    require(balanceStakeTokenToBefore < AAVE_MAX_SUPPLY());
    require(balanceStakeTokenVaultBefore < AAVE_MAX_SUPPLY());
    require (balanceBefore < AAVE_MAX_SUPPLY());
    redeem(e, to, amount);
    uint256 balanceAfter = balanceOf(e.msg.sender);
    uint256 balanceStakeTokenToAfter = stake_token.balanceOf(to);
    uint256 balanceStakeTokenVaultAfter = stake_token.balanceOf(currentContract);

    uint256 currentExchangeRate = getExchangeRate();
    uint256 amountToRedeem;
    if (amount > balanceBefore) {
        amountToRedeem = balanceBefore * EXCHANGE_RATE_FACTOR() / getExchangeRate();
    } else {
        amountToRedeem = amount * EXCHANGE_RATE_FACTOR() / getExchangeRate();
    }

    assert balanceStakeTokenToAfter == balanceStakeTokenToBefore + amountToRedeem;
    assert balanceStakeTokenVaultAfter == balanceStakeTokenVaultBefore - amountToRedeem;
    if (amount > balanceBefore) {
        assert balanceAfter == 0;
    } else {
        assert balanceAfter == balanceBefore - amount;
    }

}

rule redeemDuringPostSlashing(address to, uint256 amount){
    env e;

    require(inPostSlashingPeriod());
    require(amount > 0);
    require(amount <= balanceOf(e.msg.sender));

    uint256 underlyingToRedeem = amount * EXCHANGE_RATE_FACTOR() / getExchangeRate();
    require(stake_token.balanceOf(currentContract) >= underlyingToRedeem);

    redeem@withrevert(e, to, amount);

    assert !lastReverted;

}


/*Governance (only stkAAVE)
The total power (of one type) of all users in the system is less 
or equal than the sum of balances of all stkAAVE holders (total staked):

The governance voting and proposition power of an address is 
defined by the powerAtBlock adjusted by the exchange rate at block:
 

If an account is not receiving delegation of power (one type) from anybody, 
and that account is not delegating that power to anybody, the power of that 
account must be equal to its proportional AAVE balance.
*/

