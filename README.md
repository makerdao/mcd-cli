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

## Installation

First install [dapp tools](https://dapp.tools):

```
$ curl https://dapp.tools/install | sh
```

Then install the `mcd` package:

```bash
$ dapp pkg install mcd
```

## Configuration

Mcd is built on top of [Seth](https://github.com/dapphub/dapptools/tree/master/src/seth) and uses the same network configuration options, which just like Seth, can be defined in the `~/sethrc` initialisation file.

Similar to Seth, `mcd` also supports transaction signing with Ledger hardware wallets and can run against both local and remote nodes.

Since `mcd` will always be used against a known deployment of the system, defaults can be loaded wherever possible. In most cases the only required configuration parameter is the `-C, --chain=<chain>` (`MCD_CHAIN`) option and `-F, --from=<address>` (`ETH_FROM`) sender account when not using a testnet.

Example `~/.sethrc`:

```sh
#!/usr/bin/env bash
export ETH_FROM=0xDecaffffffffffffffffffffffffffffffffffff
export MCD_CHAIN=kovan
```

#### Kovan

Run against the latest Kovan deployment by setting the `-C, --chain` option to `kovan`. Specify a sender account when sending transactions using the `-F, --from` option, or via the `ETH_FROM` env variable.
```
$ export ETH_FROM=0xDecaffffffffffffffffffffffffffffffffffff
$ mcd --chain=kovan dai join 100
```
#### Remote testchain

Run agaist remote testchain deployments by setting the `-C, --chain` option to the remote testchain Id. Mcd will auto-configure account settings via the testchain api so that no further configuration is required. To view a list of available testchains run:

```bash
$ mcd testnet chains`
```
Then set the chain option, or the chain env  variable to the appropriate testchain Id.
```bash
$ export MCD_CHAIN=12899149080555595289
$ mcd dai join 100
```

#### Local testnet

Run against a locally running instance of [Dapp testnet](https://github.com/dapphub/dapptools/tree/master/src/dapp) where the system has been deployed by setting the `C, --chain` option to `testnet`. Mcd will auto-configure account testings for `dapp testnet` so that no further configuration is required.

By default, Mcd assumes that the output of the testchain deployment script is available at `~/.dapp/testnet/8545/config/addresses.json`. Configuration addresses can be loaded from a different location by setting the `--config` (`MCD_CONFIG`) option.

```bash
$ export MCD_CONFIG=~/testchain-deployment-scripts/out/addresses.json
$ mcd -C testnet dai join 100
```
