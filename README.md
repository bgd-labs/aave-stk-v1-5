# $stkAAVE - Delegation compatible

<p align="center">
<img src="./stkaave-token-gov-v3.png" width="300">
</p>

<br>

Next iteration of the stkAAVE token (Aave Safety Module), optimized for its usage as voting asset on Aave Governance v3.

In addition to the inherited implementation from stkAAVE 1.5 (properties [HERE](https://github.com/bgd-labs/aave-stk-v1-5/blob/main/properties.md)), the new logic on stkAAVE respects the same properties as the new AAVE token, which can be found [HERE](https://github.com/bgd-labs/aave-token-v3/blob/main/properties.md)

<br>

## Setup

This repository requires having Foundry installed in the running machine. Instructions on how to do it [HERE](https://github.com/foundry-rs/foundry#installation).

After having installed Foundry:
1. Add a `.env` file with properly configured `RPC_MAINNET` and `FORK_BLOCK`, following the example on `.env.example` 
2. `make test` to run the simulation tests.

<br>

## Security

- Internal testing and review by the BGD Labs team, but in terms of logic and upgradeability considerations.
    - [Test suite](./test/)
    - [Storage layout diffs](./diffs/)
- Security review and properties checking (formal verification) by [Certora](https://www.certora.com/), service provider of the Aave DAO.
    - [Properties](./certora/)
    - [Reports](./audits/Formal_Verification_Report_stk_v3.pdf)

<br>

## Copyright

Copyright © 2023, Aave DAO, represented by its governance smart contracts.

Created by [BGD Labs](https://bgdlabs.com/).

[MIT license](./LICENSE)