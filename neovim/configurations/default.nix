inputs@{ flake-utils, ... }:

let
  lib = import ../../lib inputs;

  mkPackages = (system:
    rec {
      default = neovim;

      neovim = lib.mkNeovim {
        inherit system;
      };
    }
  );

in
flake-utils.lib.eachDefaultSystemMap mkPackages
