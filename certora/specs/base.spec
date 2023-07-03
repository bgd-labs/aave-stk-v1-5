using DummyERC20Impl as stake_token;
using DummyERC20Impl as reward_token;

methods {

    function stake_token.balanceOf(address) external returns (uint256) envfree;

    // public variables
    function REWARDS_VAULT() external returns (address) envfree;
    function UNSTAKE_WINDOW() external returns (uint256) envfree;
    function LOWER_BOUND() external returns (uint256) envfree;
    //    function INITIAL_EXCHANGE_RATE() external returns (uint216) envfree;

    // envfree
    function balanceOf(address) external returns (uint256) envfree;
    function cooldownAmount(address) external returns (uint216) envfree;
    function cooldownTimestamp(address) external returns (uint40) envfree;
    function totalSupply() external returns (uint256) envfree;
    function stakerRewardsToClaim(address) external returns (uint256) envfree;
    function stakersCooldowns(address) external returns (uint40, uint216) envfree;
    function getCooldownSeconds() external returns (uint256) envfree;
    function getExchangeRate() external returns (uint216) envfree;
    function inPostSlashingPeriod() external returns (bool) envfree;
    function getMaxSlashablePercentage() external returns (uint256) envfree;
    function getAssetGlobalIndex(address) external returns (uint256) envfree;
    function getUserPersonalIndex(address, address) external returns (uint256) envfree;
    function previewStake(uint256) external returns (uint256) envfree;
    function previewRedeem(uint256) external returns (uint256) envfree;
    function _.permit(address, address, uint256, uint256, uint8, bytes32, bytes32) external => NONDET;
    function _.permit(address, address, uint256, uint256, uint8, bytes32, bytes32) internal => NONDET;

    // address, block, delegation type
    function _votingSnapshotsCounts(address) external returns (uint256) envfree;
    //function _updateCurrentUnclaimedRewards(address, uint256, bool) external returns (uint256) envfree;

    // view but not envfree - uses block.timestamp
    function getNextCooldownTimestamp(uint256,uint256,address,uint256) external;
    function getPowerAtBlock(address,uint256,uint8) external returns (uint256);

    // state changing operations
    function initialize(address,address,address,uint256,uint256) external;
    function stake(address,uint256) external;
    function redeem(address,uint256) external;
    function slash(address,uint256) external returns (uint256);
    function returnFunds(uint256) external;

    // variable debt token
    function _.updateDiscountDistribution(address, address, uint256, uint256, uint256) external => NONDET;
}

definition AAVE_MAX_SUPPLY() returns uint256 = 16000000 * 10^18;
definition EXCHANGE_RATE_FACTOR() returns uint256 = 10^18;
definition PERCENTAGE_FACTOR() returns uint256 = 10^4;

// a reasonable assumption that slashing is below 99%
definition MAX_EXCHANGE_RATE() returns uint256 = 100 * 10^18;
definition MAX_PERCENTAGE() returns mathint = 100 * PERCENTAGE_FACTOR();
definition INITIAL_EXCHANGE_RATE_F() returns uint216 = 10^18;
definition MAX_COOLDOWN() returns uint256 = 2302683158; //20 years from now

definition VOTING_POWER() returns uint8 = 0;
definition PROPOSITION_POWER() returns uint8 = 1;


definition claimRewards_funcs(method f) returns bool =
(
    f.selector == sig:claimRewards(address, uint256).selector ||
    f.selector == sig:claimRewardsOnBehalf(address, address, uint256).selector ||
    f.selector == sig:claimRewardsAndStake(address, uint256).selector ||
    f.selector == sig:claimRewardsAndStakeOnBehalf(address, address, uint256).selector ||
    f.selector == sig:claimRewardsAndRedeem(address, uint256, uint256).selector ||
    f.selector == sig:claimRewardsAndRedeemOnBehalf(address, address, uint256, uint256).selector
);

definition redeem_funcs(method f) returns bool =
(
    f.selector == sig:redeem(address, uint256).selector ||
    f.selector == sig:redeemOnBehalf(address, address, uint256).selector ||
    f.selector == sig:claimRewardsAndRedeem(address, uint256, uint256).selector ||
    f.selector == sig:claimRewardsAndRedeemOnBehalf(address, address, uint256, uint256).selector
);
