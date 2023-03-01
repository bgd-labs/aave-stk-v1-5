# Staked Token Rev3. Specs

## Summary of StakedTokenV2Rev3/StakedTokenBptRev2 -> StakedTokenV3

The staked token is a token deployed on Ethereum, with the main utility of participating in the safety module.

There are currently two proxy contracts which utilize the stake token:

- [stkAAVE](https://etherscan.io/token/0x4da27a545c0c5b758a6ba100e3a049001de870f5) with the [StakedTokenV2Rev3 implementation](https://etherscan.io/address/0xe42f02713aec989132c1755117f768dbea523d2f#code)
- [stkABPT](https://etherscan.io/address/0xa1116930326D21fB917d5A27F1E9943A9595fb47#code) with the [StakedTokenBptRev2 implementation](https://etherscan.io/address/0x7183143a9e223a12a83d1e28c98f7d01a68993e8#code)

Together with all the standard ERC20 functionalities, the current implementation includes extra logic for:

- entering and exiting the safety module
- management & accounting for safety module rewards
- management & accounting of voting and proposition power (only is the case of stkAAVE)

With the new iteration the StakedTokenV3 adds enhanced mechanics for slashing in the case of shortfall events.
Therefore a new `exchangeRate` is introduced which will reflect the ratio between stkToken and Token.
Initially this exchange rate will be initialized as `1e18` which reflects a `1:1` peg.

To account for a [vulnerability discovered by certora](https://github.com/bgd-labs/aave-stk-slashing-mgmt/issues/6) which would allow for gaming the cooldown eventually leading to prolonged withdrawal windows, this revision also contains refined cooldown mechanics. The cooldown no longer allows for redeeming `balanceOf(account)` at redeem, but is limited to `balanceOf(account)` at cooldown start.

In the case of StakedAaveV3 it also adds a hook for managing GHO discounts.

The new iteration will update the revision of:

- stkABPT from `2` to `3` via [StakedTokenV3.sol](./src/contracts/StakedTokenV3.sol) contract
- stkAAVE from `3` to `4` via [StakedAaveV3.sol](./src/contracts/StakedAaveV3.sol) contract

The new iteration also updates:

- solidity to version `0.8` and therefore removes `SafeMath`
- open zeppelin contracts to latest 0.8 compatible versions resulting in deprecation of `_decimals` on `ERC20`
- the `_governance` storage slot has been deprecated, as the transfer hook utilizing it has never been used

## Glossary

$_{t0}$: the state of the system before a transaction.

$_{t1}$: the state of the system after a transaction.

**account:** Ethereum address involved in a transaction on the system.

**exchange rate:** the rate to which you can redeem `stkToken` for `Token`

**total staked:** the amount of underlying staked into the `stkToken` (ignoring airdrops)

**LOWER_BOUND:** 1 unit of the staked asset (1 ether for 18 decimal assets)

**staking:** entering the pool

**redeeming:** leaving the pool

**slashing:** transfers specified amount of `Token` to the destination (altering the exchangeRate in favour of the pool)

**returnFunds:** injects amount of `Token` into the pool (altering the exchangeRate in favour of participants)

## General rules

- $Account1 \ne Account2$

- $assets = {shares \times 1e18 \over exchangeRate}$

- $shares = {assets \times exchangeRate \over 1e18}$

- initializer and constructor only initialize variables not previously initialized

## Cooldown

- `cooldown` should persist the accounts current `balance` and the `block.timestamp` within `stakersCooldowns[account]`.

- Calling `cooldown` whilst in an active cooldown will reset the cooldown-

## Exchange rate

The exchange rate is initialized as $1e18$ and only adjusted up & down based on `slash` and `returnFunds` actions.
This design was chosen opposed to a dynamic exchangeRate based on underlying as it:

- allows to clearly determine the voting & proposition power at any given block without totalSupply snapshots of every action.
- allows to clearly distinguish between participants on the pool and accounts who transferred funds by accident, so tokens can be rescued without altering the exchange rate.

## Slashing

- `slash` should transfer `amount` of the staked tokens to the `destination` address.

  - The maximum `amount` is determined by a `maxSlashingPercentage` which describes the ratio of total staked assets being available to slash.
  - If the specified `amount` exceeds the maximum, the maximum will be slashed instead.
  - The slashing will revert when less than `LOWER_BOUND` would be remaining after the slashing.

- After the slashing event occurred the `exchangeRate` should reflect the discount in the redeemable amount: $$exchangeRate_{t1}={totalStaked_{t0} - amount \over totalSupply_{t0}}$$.

- A slashing even will set `inPostSlashingPeriod` to `true`. The post slashing period lasts until it is settled by the slashing admin. For the post lashing period the following rules apply:
  - accounts can exit the pool immediately without a cooldown period.
  - no account can enter the pool.
  - no other slashing can occur.

### Staking

- `stake(amount)` should scale up the amount, so the pool always guarantees fair entry

$$
stkAmount_{t1} = {amount * exchangeRate_{t0} \over 1e18}
$$

- `stake(amount)` with a pending cooldown will no longer adjust the cooldown time.

### Redeeming

- The redeemable amount is determined as

  - `stakersCooldowns[account].amount` or
  - `balanceOf(account)` in case of an unsetteled slashing event (`inPostSlashingPeriod == true`)

- The redeemable amount should be scaled down, so the pool always guarantees fair exit

$$
amount_{t1} = {amount * 1e18 \over exchangeRate_{t0}}
$$

### Transfers

Transfers need to account for pending cooldown so you cannot use `transfer in/out` to game the cooldown.
Therefore:

- `transfer in` does not affect the `stakersCooldowns[account]`. If an account activated cooldown for `x` and receives `y` he should still only be eligible to redeem `x` as it was persisted into `stakersCooldowns[account].amount`
- `transfer out` needs to account for reduced funds on `redeem` as otherwise one could `bank` different exit windows on different `accounts` and use transfers for an early exit. Therefore given `cooldown()` at`t0` and end of withdrawal window `t1` the `stakersCooldowns[account].amount` needs to be down adjusted to the lowest `balanceOf` within the range of `t0` and `t1`. To archive this `transfer out` will discount the `stakersCooldowns[account].amount` to `min(stakersCooldowns[account].amount, balanceOf(account))`. In practice that means when calling `cooldown` with a balanceOf `100`, receiving `50`, sending `70` and receiving another `50` the `stakersCooldowns[account].amount` will be discounted to `80` as the minimum within `t0-t1` was `100 + 50 - 70 = 80`.

### Return funds

- `returnFunds` allows permissionless returning of funds to the system (e.g. when not all slashed funds were utilized to recover). Returned funds are injected into the exchangeRate and therefore mutualized over all accounts.

- To ensure only accounts affected by slashing will profit from `returnFunds`, entering the system is not possible until the slashing is settled by the slashingAdmin.

- To prevent spamming the system, and prevent extensive rounding errors, both the minimum amount returned, as well as the current shares (totalSupply of the stkToken) need to exceed `LOWER_BOUND`.

### Governance (only stkAAVE)

- The total power (of one type) of all users in the system is less or equal than the sum of balances of all stkAAVE holders (total staked): $$\sum powerOfAccount_i <= \sum balanceOf(account_i)$$.

- The governance voting and proposition power of an `address` is defined by the `powerAtBlock` adjusted by the `exchange rate at block`: $$power_{t0} = {stkAmount_{t0} * 1e18 \over exchangeRate_{t0}}$$.

- If an account is not receiving delegation of power (one type) from anybody, and that account is not delegating that power to anybody, the power of that account must be equal to its proportional AAVE balance.

## Airdrops

- The stkToken will only consider tokens staked via `stake` and injected via `returnFunds` for the exchangeRate. Tokens accidentally `airdropped` to the staking contract via transfer will not be mutualized and can in theory be rescued by governance.

## Changed events

- `Staked` and `Redeem` now both emit both `assets` and `shares` to be closer to eip-4616 standard
- `Cooldown` now emits both `account, amount` as the cooldown is for a specific amount

## Return types

- we decided to return actual types and not cast to e.g. `uint256` in view methods. This decision was taken to not allow false assumptions around max values when using these methods inside external contracts.
