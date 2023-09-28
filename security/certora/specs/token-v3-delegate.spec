

/*
    This is a specification file for the verification of delegation features.
    This file was adapted from AaveTokenV3.sol smart contract to STK-3.0 smart contract.
    This file is run by the command line: 
          certoraRun --send_only certora/conf/token-v3-delegate.conf
    It uses the harness file: certora/harness/StakedAaveV3Harness.sol
*/

import "base.spec";


methods {
    function _.mul_div_munged(uint256 x, uint256 denominator) external =>
        mul_div(x,denominator) expect uint256 ALL;
    function _.mul_div_munged(uint256 x, uint256 denominator) internal =>
        mul_div(x,denominator) expect uint256 ALL;
}


ghost mul_div(mathint , mathint) returns uint256 {
    axiom
        (forall mathint den. mul_div(0,den)==0)
        &&
        (forall mathint a. forall mathint b. forall mathint deno.
         (mul_div(a+b,deno) + 0 == mul_div(a,deno) + mul_div(b,deno)) ||
         (mul_div(a+b,deno) + 0 == mul_div(a,deno) + mul_div(b,deno)+1) ||
         (mul_div(a+b,deno) + 0 == mul_div(a,deno) + mul_div(b,deno)-1)
        );
}




function normalizeNew(uint256 amount) returns mathint {
    return mul_div(amount / DELEGATED_POWER_DIVIDER() * DELEGATED_POWER_DIVIDER(),getExchangeRate());
}




/*
    @Rule

    @Description:
        If an account is not receiving delegation of power (one type) from anybody,
        and that account is not delegating that power to anybody, the power of that account
        must be equal to its token balance.

    @Note:

    @Link:
*/

rule powerWhenNotDelegating(address account) {
    uint256 balance = balanceOf(account);
    bool isDelegatingVoting = getDelegatingVoting(account);
    bool isDelegatingProposition = getDelegatingProposition(account);
    uint72 dvb = getDelegatedVotingBalance(account);
    uint72 dpb = getDelegatedPropositionBalance(account);

    uint256 votingPower = getPowerCurrent(account, VOTING_POWER());
    uint256 propositionPower = getPowerCurrent(account, PROPOSITION_POWER());

    assert dvb == 0 && !isDelegatingVoting => votingPower == mul_div(balance,getExchangeRate());
    assert dpb == 0 && !isDelegatingProposition => propositionPower == mul_div(balance,getExchangeRate());
}


/**
    Account1 and account2 are not delegating power
*/

/*
    @Rule

    @Description:
        Verify correct voting power on token transfers, when both accounts are not delegating

    @Note:

    @Link:
*/

rule vpTransferWhenBothNotDelegating(address alice, address bob, address charlie, uint256 amount) {
    env e;
    require alice != bob && bob != charlie && alice != charlie;

    bool isAliceDelegatingVoting = getDelegatingVoting(alice);
    bool isBobDelegatingVoting = getDelegatingVoting(bob);

    // both accounts are not delegating
    require !isAliceDelegatingVoting && !isBobDelegatingVoting;

    mathint alicePowerBefore = getPowerCurrent(alice, VOTING_POWER());
    mathint bobPowerBefore = getPowerCurrent(bob, VOTING_POWER());
    mathint charliePowerBefore = getPowerCurrent(charlie, VOTING_POWER());

    transferFrom(e, alice, bob, amount);

    mathint alicePowerAfter = getPowerCurrent(alice, VOTING_POWER());
    mathint bobPowerAfter = getPowerCurrent(bob, VOTING_POWER());
    mathint charliePowerAfter = getPowerCurrent(charlie, VOTING_POWER());

    assert charliePowerAfter == charliePowerBefore;
    assert upto_1(alicePowerAfter, alicePowerBefore - mul_div(amount,getExchangeRate()));
    assert upto_1(bobPowerAfter, bobPowerBefore + mul_div(amount,getExchangeRate()));
}

/*
    @Rule

    @Description:
        Verify correct proposition power on token transfers, when both accounts are not delegating

    @Note:

    @Link:
*/

rule ppTransferWhenBothNotDelegating(address alice, address bob, address charlie, uint256 amount) {
    env e;
    require alice != bob && bob != charlie && alice != charlie;

    bool isAliceDelegatingProposition = getDelegatingProposition(alice);
    bool isBobDelegatingProposition = getDelegatingProposition(bob);

    require !isAliceDelegatingProposition && !isBobDelegatingProposition;

    mathint alicePowerBefore = getPowerCurrent(alice, PROPOSITION_POWER());
    mathint bobPowerBefore = getPowerCurrent(bob, PROPOSITION_POWER());
    mathint charliePowerBefore = getPowerCurrent(charlie, PROPOSITION_POWER());

    transferFrom(e, alice, bob, amount);

    mathint alicePowerAfter = getPowerCurrent(alice, PROPOSITION_POWER());
    mathint bobPowerAfter = getPowerCurrent(bob, PROPOSITION_POWER());
    mathint charliePowerAfter = getPowerCurrent(charlie, PROPOSITION_POWER());

    assert charliePowerAfter == charliePowerBefore;
    assert upto_1(alicePowerAfter, alicePowerBefore - mul_div(amount,getExchangeRate()));
    assert upto_1(bobPowerAfter, bobPowerBefore + mul_div(amount,getExchangeRate()));
}

/*
    @Rule

    @Description:
        Verify correct voting power after Alice delegates to Bob, when 
        both accounts were not delegating

    @Note:

    @Link:
*/

rule vpDelegateWhenBothNotDelegating(address alice, address bob, address charlie) {
    env e;
    require alice == e.msg.sender;
    require alice != 0 && bob != 0 && charlie != 0;
    require alice != bob && bob != charlie && alice != charlie;

    bool isAliceDelegatingVoting = getDelegatingVoting(alice);
    bool isBobDelegatingVoting = getDelegatingVoting(bob);

    require !isAliceDelegatingVoting && !isBobDelegatingVoting;

    mathint aliceBalance = balanceOf(alice);
    mathint bobBalance = balanceOf(bob);

    mathint alicePowerBefore = getPowerCurrent(alice, VOTING_POWER());
    mathint bobPowerBefore = getPowerCurrent(bob, VOTING_POWER());
    mathint charliePowerBefore = getPowerCurrent(charlie, VOTING_POWER());

    delegate(e, bob);

    mathint alicePowerAfter = getPowerCurrent(alice, VOTING_POWER());
    mathint bobPowerAfter = getPowerCurrent(bob, VOTING_POWER());
    mathint charliePowerAfter = getPowerCurrent(charlie, VOTING_POWER());

    assert getVotingDelegate(alice) == bob;
    assert charliePowerAfter == charliePowerBefore;
    assert upto_1(alicePowerAfter, alicePowerBefore - mul_div(aliceBalance,getExchangeRate()) );
    assert upto_1(bobPowerAfter, bobPowerBefore + normalizeNew(balanceOf(alice)));
}

/*
    @Rule

    @Description:
        Verify correct proposition power after Alice delegates to Bob, when 
        both accounts were not delegating

    @Note:

    @Link:
*/

rule ppDelegateWhenBothNotDelegating(address alice, address bob, address charlie) {
    env e;
    require alice == e.msg.sender;
    require alice != 0 && bob != 0 && charlie != 0;
    require alice != bob && bob != charlie && alice != charlie;

    bool isAliceDelegatingProposition = getDelegatingProposition(alice);
    bool isBobDelegatingProposition = getDelegatingProposition(bob);

    require !isAliceDelegatingProposition && !isBobDelegatingProposition;

    mathint aliceBalance = balanceOf(alice);
    mathint bobBalance = balanceOf(bob);

    mathint alicePowerBefore = getPowerCurrent(alice, PROPOSITION_POWER());
    mathint bobPowerBefore = getPowerCurrent(bob, PROPOSITION_POWER());
    mathint charliePowerBefore = getPowerCurrent(charlie, PROPOSITION_POWER());

    delegate(e, bob);

    mathint alicePowerAfter = getPowerCurrent(alice, PROPOSITION_POWER());
    mathint bobPowerAfter = getPowerCurrent(bob, PROPOSITION_POWER());
    mathint charliePowerAfter = getPowerCurrent(charlie, PROPOSITION_POWER());

    assert getPropositionDelegate(alice) == bob;
    assert charliePowerAfter == charliePowerBefore;
    assert upto_1(alicePowerAfter, alicePowerBefore - mul_div(aliceBalance,getExchangeRate()) );
    assert upto_1(bobPowerAfter, bobPowerBefore + normalizeNew(balanceOf(alice)));
}

/**
    Account1 is delegating power to delegatee1, account2 is not delegating power to anybody
*/

/*
    @Rule

    @Description:
        Verify correct voting power after a token transfer from Alice to Bob, when 
        Alice was delegating and Bob wasn't

    @Note:

    @Link:
*/

rule vpTransferWhenOnlyOneIsDelegating(address alice, address bob, address charlie, uint256 amount) {
    env e;
    require alice != bob && bob != charlie && alice != charlie;

    bool isAliceDelegatingVoting = getDelegatingVoting(alice);
    bool isBobDelegatingVoting = getDelegatingVoting(bob);
    address aliceDelegate = getVotingDelegate(alice);
    require aliceDelegate != alice && aliceDelegate != 0 && aliceDelegate != bob && aliceDelegate != charlie;

    require isAliceDelegatingVoting && !isBobDelegatingVoting;

    mathint alicePowerBefore = getPowerCurrent(alice, VOTING_POWER());
    // no delegation of anyone to Alice
    require alicePowerBefore == 0;

    mathint bobPowerBefore = getPowerCurrent(bob, VOTING_POWER());
    mathint charliePowerBefore = getPowerCurrent(charlie, VOTING_POWER());
    mathint aliceDelegatePowerBefore = getPowerCurrent(aliceDelegate, VOTING_POWER());
    uint256 aliceBalanceBefore = balanceOf(alice);

    transferFrom(e, alice, bob, amount);

    mathint alicePowerAfter = getPowerCurrent(alice, VOTING_POWER());
    mathint bobPowerAfter = getPowerCurrent(bob, VOTING_POWER());
    mathint charliePowerAfter = getPowerCurrent(charlie, VOTING_POWER());
    mathint aliceDelegatePowerAfter = getPowerCurrent(aliceDelegate, VOTING_POWER());
    uint256 aliceBalanceAfter = balanceOf(alice);

    assert alicePowerBefore == alicePowerAfter;
    assert charliePowerBefore == charliePowerAfter;
    assert upto_1(bobPowerAfter, bobPowerBefore + mul_div(amount,getExchangeRate()));
    assert upto_2
        (aliceDelegatePowerAfter,
         aliceDelegatePowerBefore - normalizeNew(aliceBalanceBefore) + normalizeNew(aliceBalanceAfter)
        );
}

/*
    @Rule

    @Description:
        Verify correct proposition power after a token transfer from Alice to Bob, when 
        Alice was delegating and Bob wasn't

    @Note:

    @Link:
*/

rule ppTransferWhenOnlyOneIsDelegating(address alice, address bob, address charlie, uint256 amount) {
    env e;
    require alice != bob && bob != charlie && alice != charlie;

    bool isAliceDelegatingProposition = getDelegatingProposition(alice);
    bool isBobDelegatingProposition = getDelegatingProposition(bob);
    address aliceDelegate = getPropositionDelegate(alice);
    require aliceDelegate != alice && aliceDelegate != 0 && aliceDelegate != bob && aliceDelegate != charlie;

    require isAliceDelegatingProposition && !isBobDelegatingProposition;

    mathint alicePowerBefore = getPowerCurrent(alice, PROPOSITION_POWER());
    // no delegation of anyone to Alice
    require alicePowerBefore == 0;

    mathint bobPowerBefore = getPowerCurrent(bob, PROPOSITION_POWER());
    mathint charliePowerBefore = getPowerCurrent(charlie, PROPOSITION_POWER());
    mathint aliceDelegatePowerBefore = getPowerCurrent(aliceDelegate, PROPOSITION_POWER());
    uint256 aliceBalanceBefore = balanceOf(alice);

    transferFrom(e, alice, bob, amount);

    mathint alicePowerAfter = getPowerCurrent(alice, PROPOSITION_POWER());
    mathint bobPowerAfter = getPowerCurrent(bob, PROPOSITION_POWER());
    mathint charliePowerAfter = getPowerCurrent(charlie, PROPOSITION_POWER());
    mathint aliceDelegatePowerAfter = getPowerCurrent(aliceDelegate, PROPOSITION_POWER());
    uint256 aliceBalanceAfter = balanceOf(alice);

    // still zero
    assert alicePowerBefore == alicePowerAfter;
    assert charliePowerBefore == charliePowerAfter;
    assert upto_1(bobPowerAfter, bobPowerBefore + mul_div(amount,getExchangeRate()));
    assert upto_2
        (aliceDelegatePowerAfter,
         aliceDelegatePowerBefore - normalizeNew(aliceBalanceBefore) + normalizeNew(aliceBalanceAfter)
        );
}


/*
    @Rule

    @Description:
        Verify correct voting power after Alice stops delegating, when 
        Alice was delegating and Bob wasn't

    @Note:

    @Link:
*/
rule vpStopDelegatingWhenOnlyOneIsDelegating(address alice, address charlie) {
    env e;
    require alice != charlie;
    require alice == e.msg.sender;

    bool isAliceDelegatingVoting = getDelegatingVoting(alice);
    address aliceDelegate = getVotingDelegate(alice);

    require isAliceDelegatingVoting && aliceDelegate != alice && aliceDelegate != 0 && aliceDelegate != charlie;

    mathint alicePowerBefore = getPowerCurrent(alice, VOTING_POWER());
    mathint charliePowerBefore = getPowerCurrent(charlie, VOTING_POWER());
    mathint aliceDelegatePowerBefore = getPowerCurrent(aliceDelegate, VOTING_POWER());

    delegate(e, 0);

    mathint alicePowerAfter = getPowerCurrent(alice, VOTING_POWER());
    mathint charliePowerAfter = getPowerCurrent(charlie, VOTING_POWER());
    mathint aliceDelegatePowerAfter = getPowerCurrent(aliceDelegate, VOTING_POWER());

    assert charliePowerAfter == charliePowerBefore;
    assert upto_1(alicePowerAfter, alicePowerBefore + mul_div(balanceOf(alice), getExchangeRate()));
    assert upto_1(aliceDelegatePowerAfter, aliceDelegatePowerBefore-normalizeNew(balanceOf(alice)));
}

/*
    @Rule

    @Description:
        Verify correct proposition power after Alice stops delegating, when 
        Alice was delegating and Bob wasn't

    @Note:

    @Link:
*/
rule ppStopDelegatingWhenOnlyOneIsDelegating(address alice, address charlie) {
    env e;
    require alice != charlie;
    require alice == e.msg.sender;

    bool isAliceDelegatingProposition = getDelegatingProposition(alice);
    address aliceDelegate = getPropositionDelegate(alice);

    require isAliceDelegatingProposition && aliceDelegate != alice && aliceDelegate != 0 && aliceDelegate != charlie;

    mathint alicePowerBefore = getPowerCurrent(alice, PROPOSITION_POWER());
    mathint charliePowerBefore = getPowerCurrent(charlie, PROPOSITION_POWER());
    mathint aliceDelegatePowerBefore = getPowerCurrent(aliceDelegate, PROPOSITION_POWER());

    delegate(e, 0);

    mathint alicePowerAfter = getPowerCurrent(alice, PROPOSITION_POWER());
    mathint charliePowerAfter = getPowerCurrent(charlie, PROPOSITION_POWER());
    mathint aliceDelegatePowerAfter = getPowerCurrent(aliceDelegate, PROPOSITION_POWER());

    assert charliePowerAfter == charliePowerBefore;
    assert upto_1(alicePowerAfter, alicePowerBefore+mul_div(balanceOf(alice), getExchangeRate()));
    assert upto_1(aliceDelegatePowerAfter, aliceDelegatePowerBefore - normalizeNew(balanceOf(alice)));
}

/*
    @Rule

    @Description:
        Verify correct voting power after Alice delegates

    @Note:

    @Link:
*/
rule vpChangeDelegateWhenOnlyOneIsDelegating(address alice, address delegate2, address charlie) {
    env e;
    require alice != charlie && alice != delegate2 && charlie != delegate2;
    require alice == e.msg.sender;

    bool isAliceDelegatingVoting = getDelegatingVoting(alice);
    address aliceDelegate = getVotingDelegate(alice);
    require aliceDelegate != alice && aliceDelegate != 0 && aliceDelegate != delegate2 && 
        delegate2 != 0 && delegate2 != charlie && aliceDelegate != charlie;

    require isAliceDelegatingVoting;

    mathint alicePowerBefore = getPowerCurrent(alice, VOTING_POWER());
    mathint charliePowerBefore = getPowerCurrent(charlie, VOTING_POWER());
    mathint aliceDelegatePowerBefore = getPowerCurrent(aliceDelegate, VOTING_POWER());
    mathint delegate2PowerBefore = getPowerCurrent(delegate2, VOTING_POWER());

    delegate(e, delegate2);

    mathint alicePowerAfter = getPowerCurrent(alice, VOTING_POWER());
    mathint charliePowerAfter = getPowerCurrent(charlie, VOTING_POWER());
    mathint aliceDelegatePowerAfter = getPowerCurrent(aliceDelegate, VOTING_POWER());
    mathint delegate2PowerAfter = getPowerCurrent(delegate2, VOTING_POWER());
    address aliceDelegateAfter = getVotingDelegate(alice);

    assert alicePowerBefore == alicePowerAfter;
    assert aliceDelegateAfter == delegate2;
    assert charliePowerAfter == charliePowerBefore;
    assert upto_1(aliceDelegatePowerAfter, aliceDelegatePowerBefore - normalizeNew(balanceOf(alice)));
    assert upto_1(delegate2PowerAfter, delegate2PowerBefore + normalizeNew(balanceOf(alice)));
}

/*
    @Rule

    @Description:
        Verify correct proposition power after Alice delegates

    @Note:

    @Link:
*/
rule ppChangeDelegateWhenOnlyOneIsDelegating(address alice, address delegate2, address charlie) {
    env e;
    require alice != charlie && alice != delegate2 && charlie != delegate2;
    require alice == e.msg.sender;

    bool isAliceDelegatingVoting = getDelegatingProposition(alice);
    address aliceDelegate = getPropositionDelegate(alice);
    require aliceDelegate != alice && aliceDelegate != 0 && aliceDelegate != delegate2 && 
        delegate2 != 0 && delegate2 != charlie && aliceDelegate != charlie;

    require isAliceDelegatingVoting;

    mathint alicePowerBefore = getPowerCurrent(alice, PROPOSITION_POWER());
    mathint charliePowerBefore = getPowerCurrent(charlie, PROPOSITION_POWER());
    mathint aliceDelegatePowerBefore = getPowerCurrent(aliceDelegate, PROPOSITION_POWER());
    mathint delegate2PowerBefore = getPowerCurrent(delegate2, PROPOSITION_POWER());

    delegate(e, delegate2);

    mathint alicePowerAfter = getPowerCurrent(alice, PROPOSITION_POWER());
    mathint charliePowerAfter = getPowerCurrent(charlie, PROPOSITION_POWER());
    mathint aliceDelegatePowerAfter = getPowerCurrent(aliceDelegate, PROPOSITION_POWER());
    mathint delegate2PowerAfter = getPowerCurrent(delegate2, PROPOSITION_POWER());
    address aliceDelegateAfter = getPropositionDelegate(alice);

    assert alicePowerBefore == alicePowerAfter;
    assert aliceDelegateAfter == delegate2;
    assert charliePowerAfter == charliePowerBefore;
    assert upto_1(aliceDelegatePowerAfter,aliceDelegatePowerBefore - normalizeNew(balanceOf(alice)));
    assert upto_1(delegate2PowerAfter,delegate2PowerBefore + normalizeNew(balanceOf(alice)));
}

/*
    @Rule

    @Description:
        Verify correct voting power after Alice transfers to Bob, when only Bob was delegating

    @Note:

    @Link:
*/

rule vpOnlyAccount2IsDelegating(address alice, address bob, address charlie, uint256 amount) {
    env e;
    require alice != bob && bob != charlie && alice != charlie;

    bool isAliceDelegatingVoting = getDelegatingVoting(alice);
    bool isBobDelegatingVoting = getDelegatingVoting(bob);
    address bobDelegate = getVotingDelegate(bob);
    require bobDelegate != bob && bobDelegate != 0 && bobDelegate != alice && bobDelegate != charlie;

    require !isAliceDelegatingVoting && isBobDelegatingVoting;

    mathint alicePowerBefore = getPowerCurrent(alice, VOTING_POWER());
    mathint bobPowerBefore = getPowerCurrent(bob, VOTING_POWER());
    require bobPowerBefore == 0;
    mathint charliePowerBefore = getPowerCurrent(charlie, VOTING_POWER());
    mathint bobDelegatePowerBefore = getPowerCurrent(bobDelegate, VOTING_POWER());
    uint256 bobBalanceBefore = balanceOf(bob);

    transferFrom(e, alice, bob, amount);

    mathint alicePowerAfter = getPowerCurrent(alice, VOTING_POWER());
    mathint bobPowerAfter = getPowerCurrent(bob, VOTING_POWER());
    mathint charliePowerAfter = getPowerCurrent(charlie, VOTING_POWER());
    mathint bobDelegatePowerAfter = getPowerCurrent(bobDelegate, VOTING_POWER());
    uint256 bobBalanceAfter = balanceOf(bob);

    assert bobPowerAfter == 0;
    assert charliePowerAfter == charliePowerBefore;
    assert upto_1(alicePowerAfter, alicePowerBefore - mul_div(amount,getExchangeRate()));
    assert upto_2
        (bobDelegatePowerAfter,
         bobDelegatePowerBefore - normalizeNew(bobBalanceBefore) + normalizeNew(bobBalanceAfter));

}

/*
    @Rule

    @Description:
        Verify correct proposition power after Alice transfers to Bob, when only Bob was delegating

    @Note:

    @Link:
*/

rule ppOnlyAccount2IsDelegating(address alice, address bob, address charlie, uint256 amount) {
    env e;
    require alice != bob && bob != charlie && alice != charlie;

    bool isAliceDelegating = getDelegatingProposition(alice);
    bool isBobDelegating = getDelegatingProposition(bob);
    address bobDelegate = getPropositionDelegate(bob);
    require bobDelegate != bob && bobDelegate != 0 && bobDelegate != alice && bobDelegate != charlie;

    require !isAliceDelegating && isBobDelegating;

    mathint alicePowerBefore = getPowerCurrent(alice, PROPOSITION_POWER());
    mathint bobPowerBefore = getPowerCurrent(bob, PROPOSITION_POWER());
    require bobPowerBefore == 0;
    mathint charliePowerBefore = getPowerCurrent(charlie, PROPOSITION_POWER());
    mathint bobDelegatePowerBefore = getPowerCurrent(bobDelegate, PROPOSITION_POWER());
    uint256 bobBalanceBefore = balanceOf(bob);

    transferFrom(e, alice, bob, amount);

    mathint alicePowerAfter = getPowerCurrent(alice, PROPOSITION_POWER());
    mathint bobPowerAfter = getPowerCurrent(bob, PROPOSITION_POWER());
    mathint charliePowerAfter = getPowerCurrent(charlie, PROPOSITION_POWER());
    mathint bobDelegatePowerAfter = getPowerCurrent(bobDelegate, PROPOSITION_POWER());
    uint256 bobBalanceAfter = balanceOf(bob);

    assert bobPowerAfter == 0;
    assert charliePowerAfter == charliePowerBefore;
    assert upto_1(alicePowerAfter, alicePowerBefore - mul_div(amount,getExchangeRate()));
    assert upto_2
        (bobDelegatePowerAfter,
         bobDelegatePowerBefore - normalizeNew(bobBalanceBefore) + normalizeNew(bobBalanceAfter));

}


/*
    @Rule

    @Description:
        Verify correct voting power after Alice transfers to Bob, when both Alice
        and Bob were delegating

    @Note:

    @Link:
*/
rule vpTransferWhenBothAreDelegating(address alice, address bob, address charlie, uint256 amount) {
    env e;
    require alice != bob && bob != charlie && alice != charlie;

    bool isAliceDelegatingVoting = getDelegatingVoting(alice);
    bool isBobDelegatingVoting = getDelegatingVoting(bob);
    require isAliceDelegatingVoting && isBobDelegatingVoting;
    address aliceDelegate = getVotingDelegate(alice);
    address bobDelegate = getVotingDelegate(bob);
    require aliceDelegate != alice && aliceDelegate != 0 && aliceDelegate != bob && aliceDelegate != charlie;
    require bobDelegate != bob && bobDelegate != 0 && bobDelegate != alice && bobDelegate != charlie;
    require aliceDelegate != bobDelegate;

    mathint alicePowerBefore = getPowerCurrent(alice, VOTING_POWER());
    mathint bobPowerBefore = getPowerCurrent(bob, VOTING_POWER());
    mathint charliePowerBefore = getPowerCurrent(charlie, VOTING_POWER());
    mathint aliceDelegatePowerBefore = getPowerCurrent(aliceDelegate, VOTING_POWER());
    mathint bobDelegatePowerBefore = getPowerCurrent(bobDelegate, VOTING_POWER());
    uint256 aliceBalanceBefore = balanceOf(alice);
    uint256 bobBalanceBefore = balanceOf(bob);

    transferFrom(e, alice, bob, amount);

    mathint alicePowerAfter = getPowerCurrent(alice, VOTING_POWER());
    mathint bobPowerAfter = getPowerCurrent(bob, VOTING_POWER());
    mathint charliePowerAfter = getPowerCurrent(charlie, VOTING_POWER());
    mathint aliceDelegatePowerAfter = getPowerCurrent(aliceDelegate, VOTING_POWER());
    mathint bobDelegatePowerAfter = getPowerCurrent(bobDelegate, VOTING_POWER());
    uint256 aliceBalanceAfter = balanceOf(alice);
    uint256 bobBalanceAfter = balanceOf(bob);

    assert alicePowerAfter == alicePowerBefore;
    assert bobPowerAfter == bobPowerBefore;
    assert upto_2(aliceDelegatePowerAfter,
                  aliceDelegatePowerBefore - normalizeNew(aliceBalanceBefore) + normalizeNew(aliceBalanceAfter));
    assert upto_2(bobDelegatePowerAfter,
                  bobDelegatePowerBefore - normalizeNew(bobBalanceBefore) + normalizeNew(bobBalanceAfter));
}

/*
    @Rule

    @Description:
        Verify correct proposition power after Alice transfers to Bob, when both Alice
        and Bob were delegating

    @Note:

    @Link:
*/
rule ppTransferWhenBothAreDelegating(address alice, address bob, address charlie, uint256 amount) {
    env e;
    require alice != bob && bob != charlie && alice != charlie;

    bool isAliceDelegating = getDelegatingProposition(alice);
    bool isBobDelegating = getDelegatingProposition(bob);
    require isAliceDelegating && isBobDelegating;
    address aliceDelegate = getPropositionDelegate(alice);
    address bobDelegate = getPropositionDelegate(bob);
    require aliceDelegate != alice && aliceDelegate != 0 && aliceDelegate != bob && aliceDelegate != charlie;
    require bobDelegate != bob && bobDelegate != 0 && bobDelegate != alice && bobDelegate != charlie;
    require aliceDelegate != bobDelegate;

    mathint alicePowerBefore = getPowerCurrent(alice, PROPOSITION_POWER());
    mathint bobPowerBefore = getPowerCurrent(bob, PROPOSITION_POWER());
    mathint charliePowerBefore = getPowerCurrent(charlie, PROPOSITION_POWER());
    mathint aliceDelegatePowerBefore = getPowerCurrent(aliceDelegate, PROPOSITION_POWER());
    mathint bobDelegatePowerBefore = getPowerCurrent(bobDelegate, PROPOSITION_POWER());
    uint256 aliceBalanceBefore = balanceOf(alice);
    uint256 bobBalanceBefore = balanceOf(bob);

    transferFrom(e, alice, bob, amount);

    mathint alicePowerAfter = getPowerCurrent(alice, PROPOSITION_POWER());
    mathint bobPowerAfter = getPowerCurrent(bob, PROPOSITION_POWER());
    mathint charliePowerAfter = getPowerCurrent(charlie, PROPOSITION_POWER());
    mathint aliceDelegatePowerAfter = getPowerCurrent(aliceDelegate, PROPOSITION_POWER());
    mathint bobDelegatePowerAfter = getPowerCurrent(bobDelegate, PROPOSITION_POWER());
    uint256 aliceBalanceAfter = balanceOf(alice);
    uint256 bobBalanceAfter = balanceOf(bob);

    assert alicePowerAfter == alicePowerBefore;
    assert bobPowerAfter == bobPowerBefore;
    assert upto_2(aliceDelegatePowerAfter,
                  aliceDelegatePowerBefore - normalizeNew(aliceBalanceBefore) + normalizeNew(aliceBalanceAfter));
    assert upto_2(bobDelegatePowerAfter,
                  bobDelegatePowerBefore - normalizeNew(bobBalanceBefore) + normalizeNew(bobBalanceAfter));
}

/*
    @Rule

    @Description:
        Verify that an account's delegate changes only as a result of a call to
        the delegation functions

    @Note:

    @Link:
*/
rule votingDelegateChanges(address alice, method f) {
    env e;
    calldataarg args;

    address aliceVotingDelegateBefore = getVotingDelegate(alice);
    address alicePropDelegateBefore = getPropositionDelegate(alice);

    f(e, args);

    address aliceVotingDelegateAfter = getVotingDelegate(alice);
    address alicePropDelegateAfter = getPropositionDelegate(alice);

    // only these four function may change the delegate of an address
    assert aliceVotingDelegateAfter != aliceVotingDelegateBefore || alicePropDelegateBefore != alicePropDelegateAfter =>
        f.selector == sig:delegate(address).selector || 
        f.selector == sig:delegateByType(address,IGovernancePowerDelegationToken.GovernancePowerType).selector ||
        f.selector == sig:metaDelegate(address,address,uint256,uint8,bytes32,bytes32).selector ||
        f.selector == sig:metaDelegateByType(address,address,IGovernancePowerDelegationToken.GovernancePowerType,uint256,uint8,bytes32,bytes32).selector;
}

/*
    @Rule

    @Description:
        Verify that an account's voting and proposition power changes only as a result of a call to
        the delegation, transfer, slash, returnFunds, and redeem/stake methods.

    @Note:

    @Link:
*/
rule votingPowerChanges(address alice, method f) {
    env e;
    calldataarg args;

    uint aliceVotingPowerBefore = getPowerCurrent(alice, VOTING_POWER());
    uint alicePropPowerBefore = getPowerCurrent(alice, PROPOSITION_POWER());

    f(e, args);

    uint aliceVotingPowerAfter = getPowerCurrent(alice, VOTING_POWER());
    uint alicePropPowerAfter = getPowerCurrent(alice, PROPOSITION_POWER());

    // only these four function may change the power of an address
    assert aliceVotingPowerAfter != aliceVotingPowerBefore || alicePropPowerAfter != alicePropPowerBefore =>
        f.selector == sig:delegate(address).selector || 
        f.selector == sig:delegateByType(address,IGovernancePowerDelegationToken.GovernancePowerType).selector ||
        f.selector == sig:metaDelegate(address,address,uint256,uint8,bytes32,bytes32).selector ||
        f.selector == sig:metaDelegateByType(address,address,IGovernancePowerDelegationToken.GovernancePowerType,uint256,uint8,bytes32,bytes32).selector ||
        f.selector == sig:transfer(address,uint256).selector ||
        f.selector == sig:transferFrom(address,address,uint256).selector ||
        f.selector == sig:slash(address,uint256).selector ||
        f.selector == sig:returnFunds(uint256).selector ||
        is_redeem_method(f) ||
        is_stake_method(f)


        ;
}    

/*
    @Rule

    @Description:
        Verify that only delegate() and metaDelegate() may change both voting and
        proposition delegates of an account at once.

    @Note:

    @Link:
*/
rule delegationTypeIndependence(address who, method f) filtered { f -> !f.isView } {
    address _delegateeV = getVotingDelegate(who);
    address _delegateeP = getPropositionDelegate(who);
    
    env e;
    calldataarg arg;
    f(e, arg);
    
    address delegateeV_ = getVotingDelegate(who);
    address delegateeP_ = getPropositionDelegate(who);
    assert _delegateeV != delegateeV_ && _delegateeP != delegateeP_ =>
        (f.selector == sig:delegate(address).selector ||
         f.selector == sig:metaDelegate(address,address,uint256,uint8,bytes32,bytes32).selector
        ),"one delegatee type stays the same, unless delegate or delegateBySig was called";
}

/*
    @Rule

    @Description:
        Verifies that delegating twice to the same delegatee changes the delegatee's
        voting power only once.

    @Note:

    @Link:
*/
rule cantDelegateTwice(address _delegate) {
    env e;

    address delegateBeforeV = getVotingDelegate(e.msg.sender);
    address delegateBeforeP = getPropositionDelegate(e.msg.sender);
    require delegateBeforeV != _delegate && delegateBeforeV != e.msg.sender && delegateBeforeV != 0;
    require delegateBeforeP != _delegate && delegateBeforeP != e.msg.sender && delegateBeforeP != 0;
    require _delegate != e.msg.sender && _delegate != 0 && e.msg.sender != 0;
    require getDelegationMode(e.msg.sender) == FULL_POWER_DELEGATED();

    mathint votingPowerBefore = getPowerCurrent(_delegate, VOTING_POWER());
    mathint propPowerBefore = getPowerCurrent(_delegate, PROPOSITION_POWER());
    
    delegate(e, _delegate);
    
    mathint votingPowerAfter = getPowerCurrent(_delegate, VOTING_POWER());
    mathint propPowerAfter = getPowerCurrent(_delegate, PROPOSITION_POWER());

    delegate(e, _delegate);

    mathint votingPowerAfter2 = getPowerCurrent(_delegate, VOTING_POWER());
    mathint propPowerAfter2 = getPowerCurrent(_delegate, PROPOSITION_POWER());

    assert upto_1 (votingPowerAfter, votingPowerBefore + normalizeNew(balanceOf(e.msg.sender)));
    assert upto_1 (propPowerAfter, propPowerBefore + normalizeNew(balanceOf(e.msg.sender)));
    assert votingPowerAfter2 == votingPowerAfter && propPowerAfter2 == propPowerAfter;
}

/*
    @Rule

    @Description:
        transfer and transferFrom change voting/proposition power identically

    @Note:

    @Link:
*/
rule transferAndTransferFromPowerEquivalence(address bob, uint amount) {
    env e1;
    env e2;
    storage init = lastStorage;

    address alice;
    require alice == e1.msg.sender;

    uint aliceVotingPowerBefore = getPowerCurrent(alice, VOTING_POWER());
    uint alicePropPowerBefore = getPowerCurrent(alice, PROPOSITION_POWER());

    transfer(e1, bob, amount);

    uint aliceVotingPowerAfterTransfer = getPowerCurrent(alice, VOTING_POWER());
    uint alicePropPowerAfterTransfer = getPowerCurrent(alice, PROPOSITION_POWER());

    transferFrom(e2, alice, bob, amount) at init;

    uint aliceVotingPowerAfterTransferFrom = getPowerCurrent(alice, VOTING_POWER());
    uint alicePropPowerAfterTransferFrom = getPowerCurrent(alice, PROPOSITION_POWER());

    assert aliceVotingPowerAfterTransfer == aliceVotingPowerAfterTransferFrom &&
           alicePropPowerAfterTransfer == alicePropPowerAfterTransferFrom;

}
