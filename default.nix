{ pkgs ? import <nixpkgs> {}
, dappPkgs ? import (pkgs.fetchgit {
    url = "https://github.com/dapphub/dapptools";
    rev = "seth/0.9.0";
    sha256 = "0axzqm035060agwja47plzr89r82pkzzqvd73w4j91dxxkrdvl7a";
    fetchSubmodules = true;
  }) {}
}:

dappPkgs.callPackage ./mcd-cli.nix {}
