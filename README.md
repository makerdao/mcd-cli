## MCD Command-line interface

```
MCD - Multi-collateral Dai

Usage: mcd [<options>] <command> [<args>]
   or: mcd help [<command>]

Commands:

   bite            Trigger liquidation of an unsafe Urn
   bites           ReUrns
   dai             Dai management
   debt            Total dai issuance
   drip            Trigger stability fee accumulation
   flap            Trigger a flap auction
   flips           View flips and kick-off auctions
   flog            Release queued bad-debt for auction
   flop            Trigger a flop auction
   frob            Urn management
   frobs           Recent frobs
   gem             Collateral management
   help            Print help about mcd or one of its subcommands
   ilk             Ilk (collateral type) parameters
   poke            Update the spot price for a given Ilk
   unwrap          Unwrap WETH to ETH
   urn             CDP state
   vice            Total bad debt
   vow             Liquidator balances
   wrap            Wrap ETH to WETH
```

## Installation

First install [dapp tools](https://dapp.tools):

```sh
$ curl https://dapp.tools/install | sh
```

Then install the `mcd` package:

```sh
$ dapp pkg install mcd
```

## Configuration

Mcd is built on top of [Seth](https://github.com/dapphub/dapptools/tree/master/src/seth) and uses the same network configuration options, which just like Seth, can be defined in the `~/sethrc` initialisation file.

Similar to Seth, `mcd` also supports transaction signing with Ledger hardware wallets and can run against both local and remote nodes.

Since `mcd` will always be used against a known deployment of the system, defaults can be loaded wherever possible. In most cases the only required configuration parameter is the `-C, --chain=<chain>` (`MCD_CHAIN`) option and `-F, --from=<address>` (`ETH_FROM`) sender account when not using a testnet.

Example `~/.sethrc`:

```sh
#!/usr/bin/env bash
export ETH_FROM=0x4Ffa8667Fe2db498DCb95A322b448eA688Ce430c
export MCD_CHAIN=kovan
```

#### Kovan

Run against the latest Kovan deployment by setting the `-C, --chain` option to `kovan`. Specify a sender account when sending transactions using the `-F, --from` option, or via the `ETH_FROM` env variable.

```sh
$ export ETH_FROM=0x4Ffa8667Fe2db498DCb95A322b448eA688Ce430c
$ mcd --chain=kovan dai join 100
```

#### Remote testchain

Run agaist remote testchain deployments by setting the `-C, --chain` option to the remote testchain Id. Mcd will auto-configure account settings via the testchain api so that no further configuration is required. To view a list of available testchains run:

```sh
$ mcd testnet chains`
```

Then set the chain option, or the chain env  variable to the appropriate testchain Id.

```sh
$ export MCD_CHAIN=12899149080555595289
$ mcd dai join 100
```

#### Local testnet

Run against a locally running instance of [Dapp testnet](https://github.com/dapphub/dapptools/tree/master/src/dapp) where the system has been deployed by setting the `C, --chain` option to `testnet`. Mcd will auto-configure account testings for `dapp testnet` so that no further configuration is required.

By default, Mcd assumes that the output of the testchain deployment script is available at `~/.dapp/testnet/8545/config/addresses.json`. Configuration addresses can be loaded from a different location by setting the `--config` (`MCD_CONFIG`) option.

```sh
$ export MCD_CONFIG=~/testchain-deployment-scripts/out/addresses.json
$ mcd -C testnet dai join 100
```

---

## Ilk

Ilks are collateral types with corresponding risk parameters which have been approved by system governance. Use the `ilks` command to view the list off available Ilks.

```sh
$ mcd ilks
ILK      GEM    DESC

ETH-A    WETH   Ethereum
ETH-B    WETH   Ethereum
COL1-A   COL1   Token 1
```

Each Ilk has its own set of configuration parameters which can be viewed via the `ilk` command. The `I, --ilk=<id>` option is used to scope commands to a particular Ilk:

```sh
$ mcd --ilk=ETH-A ilk
Art  40.000000000000000000                      Total debt (DAI)
rate 1.000080370887129123082627939              WETH DAI exchange rate
spot 99.333333333333333333333333333             WETH price with safety mat (USD)
line 1000.0000000000000000000000000000000000000 Debt ceiling (DAI)
dust 0.0000000000000000000000000000000000000000 Debt floor (DAI)
flip 0x9d905effff127a01da3b38124f8da88e766eb8dd Flip auction contract
chop 1.000000000000000000000000000              Liquidation penalty
lump 10000.000000000000000000                   Flip auction lot size
tax  1.000000000782997609082909351              Stability fee
rho  1552802862                                 Last drip timestamp
pip  0x98312e16f5b2c0def872a1f7484a8456e5a67a3b Price feed contract
mat  1.500000000000000000000000000              Liquidation ratio
```

Individial ilk values can be retrieved by adding the parameter name as an argument to the `ilk` command:

```sh
$ mcd --ilk=ETH-A ilk spot
99.333333333333333333333333333
```

## Gem

Gems are collateral tokens. Collateral is added and removed from the via adapters, which abstract away the differences between various token behaviours. Use `gem [<subcommand>]` to manage collateral balances for any given Ilk.

```sh
gem --ilk=<id> symbol             Gem symbol e.g. WETH
gem --ilk=<id> balance            Print balances for a given urn (default: ETH_FROM)
gem --ilk=<id> join <wad>         Add collateral to a given Urn (default: ETH_FROM)
gem --ilk=<id> exit <wad> [<guy>] Remove collateral from an Urn (default: ETH_FROM)
```

The `join` command can add collateral from the sender account to any specified Urn. The `exit` command can remove collateral from a specified Urn, provided that the sender controls the private key associated with that Urn.

By default, `ETH_FROM` is used to determine which Urn should be credited with collateral. Use `U, --urn=<address>` to optionally credit an Urn other than the default.

```sh
$ mcd --ilk=ETH-A --urn=0x123456789abcdef0123456789abcdef012345678 join 100
```

The `exit` command can remove collateral from a specified Urn, provided that the sender controls the private key associated with that Urn. The `exit` command can also withdraw collateral to an account other than `ETH_FROM` buy passing the destination address as an additional argument:

```sh
$ mcd --ilk=ETH-A exit 100 0xDecaf00000000000000000000000000000000000
```

## Urn

Urns represent Cdp state for any given Urn address.

Use the `urn` command to view Urn state for any given Ilk:

```sh
$ mcd --ilk=ETH-A urn
ilk  ETH-A                                    Collateral type
urn  4Ffa8667Fe2db498DCb95A322b448eA688Ce430c Owner
ink  204.000000000000000000                   Locked collateral (WETH)
art  40.000000000000000000                    Outstanding debt (DAI)
spot 99.333333333333333333333333333           Price with safety mat (USD)
rate 1.000080370887129123082627939            WETH DAI exchange rate
fill 50655                                    Collateralisation ratio (%)
```

By default, `ETH_FROM` is used to determine which Urn to query. Use the `U, --urn=<address>` option to query Urns at other indexes.

#### Urn management

Urn state (`urn.ink` and `urn.art`) is managed via the `frob <dink> <dart>` command, where `dink` and `dart` are delta amounts by which `ink` (Locked collateral) and `art` (Outstanding debt) should be changed. For example, to lock 100 WETH and draw 400 Dai on the ETH-A Ilk:

```sh
$ mcd --ilk=ETH-A frob 100 400
```

To reduce outstanding debt by 200 Dai whilst keeping the amount of locked collateral constant:


```sh
$ mcd --ilk=ETH-A frob -- 0 -200
```

## Dai

Similar to Gem adapters, a Dai adapter is used to exchange Vat Dai for ERC20 token Dai which can then be used outside the system. Use `dai [<subcommand>]` to manage dai balances.

```sh
dai balance    Print balances for a given urn (default: ETH_FROM)
dai join <wad> Exchange DSToken Dai for Vat Dai
dai exit <wad> Exchange Vat Dai for DSToken Dai
```

Once Dai has been drawn on an Urn, it can be withdrawn for use outside the system using `dai exit`. Dai can be returned to repay Urn debt via `dai join`.

The `dai balance` command displays the internal system (vat) balance and the external (ext) token balance:

```sh
$ mcd dai balance
vat 1030.003120998308631176024235912000000000000000000 Vat balance
ext 0.000000000000000000 ERC20 balance
```

Individial balance values can be retrieved by adding `vat` or `ext` as an argument to the `balance` command:

```
$ mcd dai balance vat
1030.003120998308631176024235912000000000000000000
```
## Examples

Note: examples assume that `ETH_FROM` is set to an address controlled by the user, and that the `MCD_CHAIN` env variable has been set to a vaild chain identifier.

### 1. Native Urn - lock 100 ETH & draw 500 Dai

Note: The system doesn't handle ETH directly but instead uses WETH to represent ETH collateral. For convenience, the `wrap` and `unwrap` commands are provided for exchanging ETH to WETH and visa versa.

```sh
# i) Wrap
$ mcd wrap 100
eth  900.000000000000000000
weth 100.000000000000000000

# ii) Gem join
$ mcd --ilk=ETH-A gem join 100
$ Grant approval to move WETH to the Vat? [Y/n]: Y
vat 100.000000000000000000 Free collateral (WETH)
ink   0.000000000000000000 Locked collateral (WETH)
ext   0.000000000000000000 External account balance (WETH)
ext 900.000000000000000000 External account balance (ETH)

# iii) Lock & Draw
$ mcd --ilk=ETH-A frob 100 500
ilk  ETH-A                                    Collateral type
urn  41dc7BaBdEE52047e00F5F55973F3122985E7eBc Owner
ink  100.000000000000000000                   Locked collateral (WETH)
art  500.000000000000000000                   Outstanding debt (DAI)
spot 100.000000000000000000000000000          Price with safety mat (USD)
rate 1.000000000000000000000000000            WETH DAI exchange rate
fill 2000                                     Collateralization Ratio (%)

# iv) Withdraw Dai
$ mcd dai exit 500
vat 0.000060682318362511884962000000000000000000000 Vat balance
ext 500.000000000000000000 ERC20 balance
```
