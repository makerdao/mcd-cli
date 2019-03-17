## MCD Command-line interface

```
MCD - Multi-collateral Dai

Usage: mcd [<options>] <command> [<args>]
   or: mcd help [<command>]

Commands:

   bite            Trigger liquidation of an unsafe Urn
   bites           ReUrns
   cdp             Cdp managerment
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
export ETH_FROM=0x4Ffa8667Fe2db498DCb95A322b448eA688Ce430c
export MCD_CHAIN=kovan
```

#### Kovan

Run against the latest Kovan deployment by setting the `-C, --chain` option to `kovan`. Specify a sender account when sending transactions using the `-F, --from` option, or via the `ETH_FROM` env variable.
```
$ export ETH_FROM=0x4Ffa8667Fe2db498DCb95A322b448eA688Ce430c
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

---

## Ilk

Ilks are collateral types with corresponding risk parameters which have been approved by system governance. Use the `ilks` command to view the list off available Ilks.

```bash
$ mcd ilks
ILK      GEM    DESC

ETH-A    WETH   Ethereum
ETH-B    WETH   Ethereum
COL1-A   COL1   Token 1
```

Each Ilk has its own set of configuration parameters which can be viewed via the `ilk` command. The `I, --ilk=<id>` option is used to scope commands to a particular Ilk:

```bash
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

```
$ mcd --ilk=ETH-A ilk spot
99.333333333333333333333333333
```

## Gem

Gems are collateral tokens. Collateral is added and removed from the via adapters, which abstract away the differences between various token behaviours. Use `gem [<subcommand>]` to manage collateral balances for any given Ilk.

```bash
gem --ilk=<id> symbol             Gem symbol e.g. WETH
gem --ilk=<id> balance            Print balances for a given urn (default: ETH_FROM)
gem --ilk=<id> join <wad>         Add collateral to a given Urn (default: ETH_FROM)
gem --ilk=<id> exit <wad> [<guy>] Remove collateral from an Urn (default: ETH_FROM)
```

The `join` command can add collateral from the sender account to any specified Urn. The `exit` command can remove collateral from a specified Urn, provided that the sender controls the private key associated with that Urn.

By default, `ETH_FROM` is used to determine which Urn should be credited with collateral. Use `U, --urn=<index>` to optionally credit an Urn other than the default.

```
$ mcd --ilk=ETH-A --urn=0x123456789abcdef0123456789abcdef012345678 join 100
```

The `exit` command can remove collateral from a specified Urn, provided that the sender controls the private key associated with that Urn. The `exit` command can also withdraw collateral to an account other than `ETH_FROM` buy passing the destination address as an additional argument:

```
$ mcd --ilk=ETH-A exit 100 0xDecaf00000000000000000000000000000000000
```

## Urn

Urns represent Cdp state for any given Urn index, where an Urn index consists of an address component (the public key of the account that owns the Urn) and an optional index component.

Use the `urn` command to view Urn state for any given Ilk:

```bash
$ mcd --ilk=ETH-A urn
ilk  ETH-A                                                            Collateral type
urn  4Ffa8667Fe2db498DCb95A322b448eA688Ce430c000000000000000000000000 Urn index
ink  204.000000000000000000                                           Locked collateral (WETH)
art  40.000000000000000000                                            Outstanding debt (DAI)
spot 99.333333333333333333333333333                                   Price with safety mat (USD)
rate 1.000080370887129123082627939                                    WETH DAI exchange rate
fill 50655                                                            Collateralisation ratio (%)
```

By default, `ETH_FROM` is used to determine which Urn to query. Use the `U, --urn=<index>` option to query Urns at other indexes.

#### Urn management

Urn state (`urn.ink` and `urn.art`) is managed via the `frob <dink> <dart>` command, where `dink` and `dart` are delta amounts by which `ink` (Locked collateral) and `art` (Outstanding debt) should be changed. For example, to lock 100 WETH and draw 400 Dai on the ETH-A Ilk:

```bash
$ mcd --ilk=ETH-A frob 100 400
```

To reduce outstanding debt by 200 Dai whilst keeping the amount of locked collateral constant:


```bash
$ mcd --ilk=ETH-A frob -- 0 -200
```

## Dai

Similar to Gem adapters, a Dai adapter is used to exchange Vat Dai for ERC20 token Dai which can be used outside the system. Use `dai [<subcommand>]` to manage dai balances.

```bash
dai balance    Print balances for a given urn (default: ETH_FROM)
dai join <wad> Exchange DSToken Dai for Vat Dai
dai exit <wad> Exchange Vat Dai for DSToken Dai
```

Once Dai has been drawn on an Urn, it can be withdrawn for use outside the system using `dai exit`. Dai can be returned to repay Urn debt via `dai join`.

The `dai balance` command displays the internal system (vat) balance and the external (ext) token balance:

```bash
$ mcd dai balance
vat 1030.003120998308631176024235912000000000000000000 Vat balance
ext 0.000000000000000000 ERC20 balance
```

Individial balance values can be retrieved by adding `vat` or `ext` as an argument to the `balance` command:

```
$ mcd dai balance vat
1030.003120998308631176024235912000000000000000000
```

## Cdp

The `cdp` command makes uses the [Cdp Manager](https://github.com/makerdao/dss-cdp-manager) to allow Urns to be treated as non-fungible tokens with a unique NFT identifier:

```bash
$ cdp --ilk=ETH-A open
cdp 42 opened
```

Once a Cdp has been opened it can be managed via its unique <id> identiier rather than the `I, --ilk` and `U, urn` options. The identifier can be either be passed via the `--cdp` option flag or as the first argument to the `cdp` command. Hence these commands are equivilent:

```bash
$ mcd --cdp=42 gem join 100
# or
$ mcd cdp 42 gem join
```

All of the native Mcd functionality can be applied to Cdp's simply by supplying a Cdp identifier to the appropriate command:

```bash
$ mcd --cdp=42 gem join <wad>     Add collateral
$ mcd --cdp=42 gem exit <wad>     Remove collateral
$ mcd --cdp=42 dai join <wad>     Add Dai
$ mcd --cdp=42 dai exit <wad>     Remove Dai
$ mcd --cdp=42 frob <dink> <dart> Manage Cdp state
```

Cdp Manger-specific functionality is also available via cdp`subcommands:

```
cdp ls                      List Cdps
cdp count                   Cdp count
cdp open                    Open a new Cdp
cdp <id> owner              Get Cdp owner address
cdp <id> give <address>     Change Cdp owner
```

### Cdp Portal

The Cdp Portal uses a proxy contract for improved UX on the front-end. The `--proxy` option is available for compatability with Cdps created via the Cdp Portal:

```bash
$ mcd --proxy --cdp=42 frob 500 200
```

This will send calls via the registered proxy for `ETH_FROM`, matching  the behaviour of the Cdp portal. If the sender doesn't yet have a registered proxy, an option will be presented to create one.


