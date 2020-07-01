#!/bin/sh

# Based on the Nix install script
# This script installs Nix, Cachix, and mcd-cli

{ # Prevent execution if this script was only partially downloaded

  set -e

  oops() {
    echo >&2 "${0##*/}: error:" "$@"
    exit 1
  }

  if [ "$(id -u)" -eq 0 ]; then
    oops "please run this script as a regular user"
  fi

  if [ -z "$HOME" ]; then
    oops "\$HOME is not set"
  fi

  if [ -z "$USER" ]; then
    oops "\$USER is not set"
  fi

  have() { command -v "$1" >/dev/null; }

  # We don't handle NixOS yet
  { have nixos-version; } && {
    echo >&2 "We love that you are running NixOS! <3"
    echo >&2 "We're working on having this script work on NixOS, but for the moment"
    echo >&2 "go to https://github.com/makerdao/mcd-cli/ and follow manual installation instructions."
    exit 1
  }

  # Don't auto update Nix v1.
  { have nix-shell && ! have nix; } && {
    echo >&2 "You seem to be running a Nix version lower than 2.0"
    echo >&2 "Please upgrade to Nix v2 before running this script"
    echo >&2 "You can run \`curl -sS https://nixos.org/nix/install | sh\`"
    exit 1
  }

  { have git; } || oops "you need to install Git before running this script"
  { have curl; } || oops "you need to install curl before running this script"

  { have nix; } || {
    echo "mcd-cli uses the Nix package manager to install programs behind the scenes."
    echo "Installing Nix in single-user mode, you may be asked for your sudo password."

    curl -sS https://nixos.org/nix/install | sh

    # shellcheck source=/dev/null
    . "$HOME/.nix-profile/etc/profile.d/nix.sh"
    echo "Nix installation succeded!"
  }

  if [ ! -d "$HOME/.config/nix" ]; then
    mkdir -p "$HOME/.config/nix"
  fi

  echo "Installing mcd-cli... (this will take a while)"
  nix-env -i -f https://github.com/makerdao/mcd-cli/tarball/master

  # Finished!
  cat <<EOF

Installation finished!

You now have access to mcd-cli.

Please logout and log back in to start using mcd-cli, or run

    . "$HOME/.nix-profile/etc/profile.d/nix.sh"

in this terminal.
EOF

} # End of wrapping
