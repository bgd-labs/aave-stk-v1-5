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
    // address, block, delegation type
    getPowerAtBlock(address,uint256,uint8) returns (uint256) envfree

    // view but not envfree - uses block.timestamp
    getNextCooldownTimestamp(uint256,uint256,address,uint256)
    
    // state changing operations
    initialize(address,address,address,uint256,uint256)
    stake(address,uint256)
    redeem(address,uint256)
    slash(address,uint256) returns (uint256)
    returnFunds(uint256)
}

definition AAVE_MAX_SUPPLY() returns uint256 = 16000000 * 10^18;
definition EXCHANGE_RATE_FACTOR() returns uint256 = 10^18;
definition PERCENTAGE_FACTOR() returns uint256 = 10^4;

// a reasonable assumption that slashing is below 99%
definition MAX_EXCHANGE_RATE() returns uint256 = 100 * 10^18;
definition MAX_PERCENTAGE() returns uint256 = 100 * PERCENTAGE_FACTOR();
definition INITIAL_EXCHANGE_RATE() returns uint256 = 10^18;

definition VOTING_POWER() returns uint8 = 0;
definition PROPOSITION_POWER() returns uint8 = 1;
