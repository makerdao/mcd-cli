## MCD Command-line interface

```
McDai - Multi-collateral Dai

Usage: mcd [<options>] <command> [<args>]
   or: mcd help [<command>]

Commands:

   bite            Trigger liquidation of an unsafe urn (CDP)
   bites           Recent bites
   dai             Dai management
   drip            Trigger stability fee collection
   flap            Trigger a flap auction
   flips           View flips and kick-off auctions
   flog            Release queued bad-debt for auction
   flop            Trigger a flop auction
   frob            Urn (CDP) management
   frobs           Recent frobs
   gem             Collateral management
   help            Print help about mcd or one of its subcommands
   ilk             Ilk (collateral type) parameters
   poke            Update the price feed for a given Ilk
   urn             CDP state
   vice            Total bad debt
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

### Example - open a CDP and withdraw Dai

```bash
$ mcd --ilk=ETH join 100

$ mcd --ilk=ETH gem balance
vat   100 Free collateral
ink   0   Locked collateral
ext   900 ERC20 account balance

$ mcd --ilk=ETH frob 99 7
ilk   ETH                                                              CDP type identifier
urn   43335d187cfab85d415678095495d06e779bd0f5000000000000000000000000 CDP identifier
ink   99.0000000000000000000                                           Locked collateral (ETH)
art   7.00000000000000000000                                           Outstanding debt (DAI)
spot  99.3333333333333333333                                           Price with safety margin (USD)

$ mcd --ilk=ETH gem balance
vat   1   Free collateral
ink   99  Locked collateral
ext   900 ERC20 account balance

$ mcd dai balance
vat   7.00000000000000000000 Vat balance
ext   0.00000000000000000000 ERC20 account balance

$ mcd dai exit 7

$ mcd dai balance
vat   0.00000000000000000000 Vat balance
ext   7.00000000000000000000 ERC20 account balance
```

### Example - query Ilk state

```bash
$ mcd --chain kovan --ilk=ETH ilk
spot 99.333333333333333333333333333             ETH price with safety margin (USD)
line 10000.000000000000000000                   Debt ceiling (DAI)
take 1.000000000000000000000000000              ETH exchange rate
rate 1.000000000000000000000000000              DAI exchange rate
Ink  300.000000000000000000                     Total (ETH)
Art  800.000000000000000000                     Total (DAI)
flip 0x4a4a09a0085d954db878337094d3387ab9001f03 Flip auction contract
chop 1.000000000000000000000000000              Liquidation penalty
lump 1000000000.000000000000000000              Flip auction lot size
tax  1.000000000000000000000000000              Stability fee
rho  1549580478                                 Last drip timestamp
pip  0xa40daac0caac0c4fc4a97b7f50876252f8a08253 Price feed contract
mat  1.500000000000000000000000000              Liquidation ratio
```
