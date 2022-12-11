using DummyERC20Impl as stake_token

methods {

    stake_token.balanceOf(address) returns (uint256) envfree

    // public variables
    REWARDS_VAULT() returns (address) envfree
    UNSTAKE_WINDOW() returns (uint256) envfree

    // envfree 
    balanceOf(address) returns (uint256) envfree
    totalSupply() returns (uint256) envfree
    stakerRewardsToClaim(address) returns (uint256) envfree
    stakersCooldowns(address) returns (uint256) envfree
    getCooldownSeconds() returns (uint256) envfree
    getExchangeRate() returns (uint128) envfree
    inPostSlashingPeriod() returns (bool) envfree
    getMaxSlashablePercentage() returns (uint256) envfree

    // view but not envfree - uses block.timestamp
    getNextCooldownTimestamp(uint256,uint256,address,uint256)
    
    // state changing operations
    stake(address,uint256)
    redeem(address,uint256)
    slash(address,uint256) returns (uint256)
    returnFunds(uint256)
}

definition AAVE_MAX_SUPPLY() returns uint256 = 16000000 * 10^18;
definition EXCHANGE_RATE_FACTOR() returns uint256 = 10^18;