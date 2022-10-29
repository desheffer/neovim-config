inputs@{ nixpkgs, ... }:

system:

let
  pkgs = import nixpkgs {
    inherit system config overlays;
  };

  config = {
    allowUnfree = true;
  };

  overlays = [
    (final: prev: {
      vimPluginsFromInputs = builtins.mapAttrs buildVimPlugin inputs;
    })
  ];

  buildVimPlugin = (name: src:
    pkgs.vimUtils.buildVimPluginFrom2Nix {
      inherit name src;
    }
  );

in
pkgs
