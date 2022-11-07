inputs@{ flake-utils, ... }:

let
  lib = import ../../lib inputs;

  mkPackages = (system:
    rec {
      default = neovim;

      neovim = lib.mkNeovim {
        inherit system;

        config = {
          modules.lsp.enable = true;
        };
      };

      neovim-light = lib.mkNeovim {
        inherit system;

        config = { };
      };
    }
  );

in
flake-utils.lib.eachDefaultSystemMap mkPackages
