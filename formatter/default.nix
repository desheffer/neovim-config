inputs@{
  nixpkgs,
  flake-utils,
  treefmt-nix,
  ...
}:

let
  mkFormatter = (
    system:
    let
      pkgs = import nixpkgs { inherit system; };

      treefmtEval = treefmt-nix.lib.evalModule pkgs {
        projectRootFile = ".git/config";
        programs.nixfmt.enable = true;
      };

    in
    treefmtEval.config.build.wrapper
  );

in
flake-utils.lib.eachDefaultSystemMap mkFormatter
