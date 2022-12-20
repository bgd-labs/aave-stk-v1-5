import "base.spec"

ghost mathint totalStaked {
    init_state axiom totalStaked == 0;
}

ghost uint128 exchangeRate {
    init_state axiom exchangeRate == INITIAL_EXCHANGE_RATE();
}

// hook example
// hook Sstore _balances[KEY address user].delegationState uint8 new_state (uint8 old_state) STORAGE {
//     totalStaked = totalStaked - old_state + new_state;
// }

hook Sstore _currentExchangeRate uint128 new_rate (uint128 old_rate) STORAGE {
    exchangeRate = new_rate;
}

invariant exchangeRateCorrectness()
    getExchangeRate() == 
        stake_token.balanceOf(currentContract) * EXCHANGE_RATE_FACTOR() / totalSupply() {
        preserved {
            require (totalSupply() < AAVE_MAX_SUPPLY());
            require (stake_token.balanceOf(currentContract) < AAVE_MAX_SUPPLY());
        }
    }

