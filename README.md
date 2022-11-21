# WIP: Stake token rev 3

Repository contains a new revision of `StakedTokenV3` and `StakedAaveV3`.

Thew new `StakedTokenV3` includes en enhanced mechanism to facility slashing of the underlying by tracking the `exchangeRate` between $stkToken \leftrightarrow Token$.

The slashing itself must be performed by a slashingAdmin which initially will be the governance short executor. The slashing will result in transferring part of the underlying to a specified address and starting the slashing process by setting a `inPostSlashingPeriod` flag.

While being in post lashing period, no other slashing can be performed. While accounts can exit the pool no-one can enter the pool in that period.

The community can then use (parts of) the funds for recovery. Once the recovery is finished potentially remaining funds should be returned to the pool and mutualized by the remaining stakers.

Once the slashing is officially settled, accounts can reenter the pool and a new slashing can occur.

The `StakedAaveV3` extends on top of `StakedTokenV3` , by adding hooks for managing the GHO discounts via a transferHook.

A more detailed description can be found [here](./properties.md)

An export of storage layout changes can be found [here](./storage.md)

## Development

### Install

```sh
cp .env.example .env
forge install
```

### Test

```sh
forge test
```

### Diff

Generate a code & storage layout diff.

```sh
npm run diff
```
