# Staked Token Rev3. Specs

## Summary of StakedTokenV2Rev3/StakedTokenBptRev2 -> StakedTokenV3

The staked token is a token deployed on Ethereum, with the main utility of participating in the safety module.

There are currently two proxy contracts which utilize the stake token:

- [stkAAVE](https://etherscan.io/token/0x4da27a545c0c5b758a6ba100e3a049001de870f5) with the [StakedTokenV2Rev3 implementation](https://etherscan.io/address/0xe42f02713aec989132c1755117f768dbea523d2f#code)
- [stkABPT](https://etherscan.io/address/0xa1116930326D21fB917d5A27F1E9943A9595fb47#code) with the [StakedTokenBptRev2 implementation](https://etherscan.io/address/0x7183143a9e223a12a83d1e28c98f7d01a68993e8#code)

Together with all the standard ERC20 functionalities, the current implementation includes extra logic for:

- management & accounting of voting and proposition power
- management & accounting for safety module rewards

With the new iteration the StakedTokenV3 adds mechanics for slashing in the case of shortfall events.

## Glossary

**exchange rate** -> the rate to which you can redeem stkAAVE for AAVE

**slashing amount** -> the amount being slashed

## General rules

- Exchange rate should be 1 to 1, as long as no slashing event has occurred.

- $Account1 \ne Account2$

### Slashing

- `slash` should revert when amount exceeds max slashing amount

- `slash` should transfer `amount` of the staked tokens to the `destination` address

- after the slashing event occurred the `exchangeRate` should reflect the discount in the redeemable amount

$$
underlyingAmount_{t0} = n \\
totalSupply_{t0} = n \\
exchangeRate_{t0} = {underlyingAmount_{t0} \over totalSupply_{t0}} = 1 \\
slashAmount = 0.3*n \\
\Downarrow \\
underlyingAmount_{t1} = n - slash \\
totalSupply_{t1} = n \\
exchangeRate_{t1} = {underlyingAmount_{t0} \over totalSupply_{t0}} = {n - slash \over n}
$$

### Stake after slashing

- staking after a slashing should not penalize people entering the pool and therefore scale up the staked amount

$$
stkAmount_{t1} = {amount_{t1} \over exchangeRate_{t1}}
$$

### Redeem after slashing

- the redeemable amount should be scaled down by the correct exchange factor

$$
redeemAmount_{t1} = {stkAmount_{t0} * exchangeRate_{t1}}
$$

### Governance

### Changed events

- `Staked` and `Redeem` now both emit both `assets` and `shares` to be closer to eip-4616