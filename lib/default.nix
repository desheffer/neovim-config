inputs@{ ... }:

{
  mkNeovim = import ../pkgs/mkNeovim.nix inputs;
  mkPkgs = import ../pkgs/mkPkgs.nix inputs;
}
