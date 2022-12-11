
import "base.spec"

/* 
    This is a draft spec, written on a previous incomplete version of the code
   and it contains imprecise properties.
   probably will be deleted later
*/

// after staking the accrued rewards only go up
rule rewardsAfterStakingOnlyGoUp(address onBehalfOf, uint256 amount) {
    env e;
    uint256 rewardsBefore = stakerRewardsToClaim(onBehalfOf);
    stake(e, onBehalfOf, amount);
    uint256 rewardsAfter = stakerRewardsToClaim(onBehalfOf);

    assert rewardsAfter >= rewardsBefore;
}

// balance after staking only goes up and is >= the amount
// tokens are transferred correctly into the vault on stake
rule integrityOfStaking(address onBehalfOf, uint256 amount) {
    env e;
    require(amount < AAVE_MAX_SUPPLY());
    require(e.msg.sender != currentContract);

    uint256 balanceStakeTokenDepositorBefore = stake_token.balanceOf(e.msg.sender);
    uint256 balanceStakeTokenVaultBefore = stake_token.balanceOf(currentContract);
    require(balanceStakeTokenDepositorBefore < AAVE_MAX_SUPPLY());
    require(balanceStakeTokenVaultBefore < AAVE_MAX_SUPPLY());
    uint256 balanceBefore = balanceOf(onBehalfOf);
    stake(e, onBehalfOf, amount);
    uint256 balanceAfter = balanceOf(onBehalfOf);
    uint256 balanceStakeTokenDepositorAfter = stake_token.balanceOf(e.msg.sender);
    uint256 balanceStakeTokenVaultAfter = stake_token.balanceOf(currentContract);

    assert balanceAfter == balanceBefore + amount;
    assert balanceStakeTokenDepositorAfter == balanceStakeTokenDepositorBefore - amount;
    assert balanceStakeTokenVaultAfter == balanceStakeTokenVaultBefore + amount;
}

// stake contract holds a balance of stake tokens >= total supply

// the invariant doesn't work when staked onBehalfOf current contract
// invariant stakeTokenBalanceAtLeastTotalSupply()
//     stake_token.balanceOf(currentContract) >= totalSupply()

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

// if redeem succeeds, the cooldown is inside the unstake window
rule noRedeemOutOfUnstakeWindow(address to, uint256 amount){
    env e;

    uint256 cooldown = stakersCooldowns(e.msg.sender);
    redeem(e, to, amount);

    // assert cooldown is inside the unstake window 
    assert e.block.timestamp > cooldown + getCooldownSeconds() &&
        e.block.timestamp - (cooldown + getCooldownSeconds()) <= UNSTAKE_WINDOW();   
}

rule integrityOfRedeem(address to, uint256 amount){
    env e;
    require(amount < AAVE_MAX_SUPPLY());
    require(e.msg.sender != currentContract && to != currentContract);

    uint256 balanceStakeTokenToBefore = stake_token.balanceOf(to);
    uint256 balanceStakeTokenVaultBefore = stake_token.balanceOf(currentContract);
    require(balanceStakeTokenToBefore < AAVE_MAX_SUPPLY());
    require(balanceStakeTokenVaultBefore < AAVE_MAX_SUPPLY());
    uint256 balanceBefore = balanceOf(e.msg.sender);
    redeem(e, to, amount);
    uint256 balanceAfter = balanceOf(e.msg.sender);
    uint256 balanceStakeTokenToAfter = stake_token.balanceOf(to);
    uint256 balanceStakeTokenVaultAfter = stake_token.balanceOf(currentContract);

    if (amount > balanceBefore) {
        assert balanceAfter == 0;
        assert balanceStakeTokenToAfter == balanceStakeTokenToBefore + balanceBefore;
        assert balanceStakeTokenVaultAfter == balanceStakeTokenVaultBefore - balanceBefore;
    } else {
        assert balanceAfter == balanceBefore - amount;
        assert balanceStakeTokenToAfter == balanceStakeTokenToBefore + amount;
        assert balanceStakeTokenVaultAfter == balanceStakeTokenVaultBefore - amount;
    }
}