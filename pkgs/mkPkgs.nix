inputs@{ nixpkgs, ... }:

system:

let
  pkgs = import nixpkgs { inherit system config; };

  config = {
    allowUnfree = true;
  };

in
pkgs
