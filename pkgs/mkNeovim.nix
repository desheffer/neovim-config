inputs:

{
  system,
  config ? { },
  ...
}:

let
  lib = import ../lib inputs;
  pkgs = lib.mkPkgs system;

  eval = pkgs.lib.evalModules {
    specialArgs = {
      pkgs = {
        inherit system;
      };
    };

    modules = [
      (import ../neovim inputs)
      config
    ];
  };

in
eval.config.programs.neovim-config.finalPackage
