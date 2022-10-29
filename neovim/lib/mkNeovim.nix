inputs@{ ... }:

{ system, config ? { }, ... }:

let
  lib = import ../../lib inputs;

  pkgs = lib.mkPkgs system;

  eval = pkgs.lib.evalModules {
    specialArgs = {
      inherit pkgs;
    };

    modules = [
      ../modules
    ];
  };

in
eval.config.modules.neovim.finalPackage
