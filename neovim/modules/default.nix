{ config, lib, ... }:

with lib;

{
  imports = [
    ./neovim.nix

    ./buffer.nix
    ./colorscheme.nix
    ./completion.nix
    ./dashboard.nix
    ./editing.nix
    ./finder.nix
    ./general.nix
    ./git.nix
    ./lsp.nix
    ./navigation.nix
    ./notice.nix
    ./register.nix
    ./session.nix
    ./status.nix
    ./syntax.nix
    ./tmux.nix
    ./tree.nix
    ./whitespace.nix
  ];
}
