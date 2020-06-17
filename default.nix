{ makerpkgs ? import (fetchGit {
    url = "https://github.com/makerdao/makerpkgs";
    rev = "524798094c6dc9b7bd58d2f88e12d457ca7e9d60";
  }) {}
}:

makerpkgs.callPackage ./mcd-cli.nix {}
