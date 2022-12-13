import "base.spec"

// exchange rate only changes as a result of
// slash() and returnFunds(), or in initialize()
// assumption here is that initialize() is run only once
// can we check?
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
