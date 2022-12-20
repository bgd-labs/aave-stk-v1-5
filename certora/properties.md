## Properties

- correct discount rate based on staked AAVE, based on the whitepaper equation
- maximum amount of GHO available invariant
    ASghoT = sigma max(0, CB(n)t - LB(n)t

- borrow fails if the amount requested exceeds bucket capacity
- repay results in facilitator's bucket level decreased
- initial scaled balance on first borrow corresponds to the equations at 3.6.1
- non discounted interest accumulates properly
- discounted interest accumulates properly
- GHO oracle always returns 1

### StkAave properties

#### stake
- [v] after `stake()`: accruedRewards only go up
- [v] after `stake()`: balanceOf[user] is greater or equal to deposit amount
- [v] after `stake()`: staked token is transferred to the vault
- [v] after `stake()`: cooldown is updated

#### redeem
- [v] reverse properties on `redeem()`
- [v] can redeem if only if inside unstake window

#### cooldown
- [v] `cooldown()` correctness: updated with block timestamp

#### claimRewards
- [ ] `claimRewards()` correctness
- [ ] can't claim more than you earned

#### transfer
- [ ] _transfer properties: rewards and cooldown
- [ ] getnextcooldown correctness

#### delegation
- [ ] delegation updates

#### high level properties
- [v] vault holds at least as many stake tokens as totalSupply()



## BGD properties

### slashing

- transfer amount of staked underlying to _destination_ 
    - check balances
    - determine that amount doesn't violate _maxSlashingPercentage_
- after slashing:
    exchangeRate_t1 = (totalStaked_t0 - amount) / totalSupply_t0
- after slashing inPostSlashingPeriod = true:
    - accounts can exit immediately without cooldown
    - no account can enter
    - no other slashing can occur

### staking

- stkAmount_t1 = amount * exchangeRate_t0 / 1e18

### redeeming

- amount_t1 = amount * 1e18 / exchangeRate_t0

### returnFunds

- returned funds injected into the exchangeRate
- entering not possible until slashing is settled by slashingAdmin

### Governance

- sum of power of all accounts is eqlt to sum of all balances

- power_t0 = stkAmount_t0 * 1e18 / exchangeRate_t0

### Airdrops

- airdropped tokens (not through _stake_ or _returnFunds_) are not considered
  for the exchange rate, i.e. not mutualized

