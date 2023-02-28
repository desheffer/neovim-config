inputs:

{ config, lib, ... }:

with lib;

{
  imports = [
    (import ./neovim.nix inputs)

    (import ./buffer.nix inputs)
    (import ./colorscheme.nix inputs)
    (import ./completion.nix inputs)
    (import ./dashboard.nix inputs)
    (import ./editing.nix inputs)
    (import ./finder.nix inputs)
    (import ./general.nix inputs)
    (import ./git.nix inputs)
    (import ./lsp.nix inputs)
    (import ./navigation.nix inputs)
    (import ./notice.nix inputs)
    (import ./register.nix inputs)
    (import ./session.nix inputs)
    (import ./status.nix inputs)
    (import ./syntax.nix inputs)
    (import ./tmux.nix inputs)
    (import ./tree.nix inputs)
    (import ./whitespace.nix inputs)
  ];
}
