## Development Install

Clone the repo and use make to link/unlink the executables:

```
$ git clone git@github.com:makerdao/mcd-cli.git
$ cd mcd-cli
$ make install | uninstall
```

If you have `nix` installed you can install as a local package:

```
$ git clone git@github.com:makerdao/mcd-cli.git
$ nix-env -f mcd-cli -iA mcd
```

## Package Install

First install dapp tools:

```
$ curl https://dapp.tools/install | sh
```

Then install the `mcd` package:

```bash
$ dapp pkg install mcd
```

## Usage

List available commands:

```bash
$ mcd help
```

List all available options:

```bash
$ mcd --help
```

View help for a specific command:

```bash
$ mcd help <command>
```
