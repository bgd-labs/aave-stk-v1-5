import "base.spec"

// exchange rate only changes as a result of
// slash() and returnFunds(), or in initialize()
// assumption here is that initialize() is run only once
// can we check?
rule exchangeRateStateTransition(method f){
    env e;
    calldataarg args;
    uint128 exchangeRateBefore = getExchangeRate();
    f(e, args);
    uint128 exchangeRateAfter = getExchangeRate();
    assert exchangeRateBefore != exchangeRateAfter =>
        f.selector == slash(address,uint256).selector ||
        f.selector == returnFunds(uint256).selector ||
        f.selector == initialize(address,address,address,uint256,uint256).selector;
}