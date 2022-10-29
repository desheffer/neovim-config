inputs@{ ... }:

{
  mkNeovim = import ../neovim/lib/mkNeovim.nix inputs;
  mkPkgs = import ../pkgs/mkPkgs.nix inputs;
}
