inputs@{ nixpkgs, flake-utils, ... }:

let
  mkFormatter = (system:
    let
      pkgs = import nixpkgs {
        inherit system;
      };

    in
    pkgs.nixpkgs-fmt
  );

in
flake-utils.lib.eachDefaultSystemMap mkFormatter
