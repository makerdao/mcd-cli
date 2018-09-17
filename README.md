## MCD Command-line interface

```
McDai - Multi-collateral Dai

Usage: mcd [<options>] <command> [<args>]
   or: mcd help [<command>]

Commands:

   bite            Trigger liquidation of an unsafe urn
   bites           View recent bites
   dai             Dai balances
   debt            Get total dai issuance
   drip            Trigger stability fee collection
   flap            Trigger a flap auction
   flips           View flips and kick-off auctions
   flog            Release queued bad-debt for auction
   flop            Trigger a flop auction
   frob            CDP management
   frobs           View recent frobs
   gem             Gem balances
   help            Print help about mcd or one of its subcommands
   ilk             Get ilk state
   poke            Poke a spot price feed
   spot            Get the spot price for a given Ilk
   urn             Get urn state
   vice            Get total bad debt
   vow             Liquidator balances
```

## Install

First install dapp tools:

```
$ curl https://dapp.tools/install | sh
```

Then install the `mcd` package:

```bash
$ dapp pkg install mcd
```
