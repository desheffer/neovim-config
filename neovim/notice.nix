inputs@{ ... }:

{ config, lib, pkgs, ... }:

with lib;

let
  lib' = import ../lib inputs;
  pkgs' = lib'.mkPkgs pkgs.system;

  cfg = config.modules.notice;

in
{
  options.programs.neovim-config.notice = { };

  config.programs.neovim-config = {
    plugins = [
      (pkgs'.vimUtils.buildVimPluginFrom2Nix {
        name = "noice-nvim";
        src = inputs.noice-nvim;
      })
      (pkgs'.vimUtils.buildVimPluginFrom2Nix {
        name = "nui-nvim";
        src = inputs.nui-nvim;
      })
    ];

    config = ''
      require("noice").setup({
        lsp = {
          signature = {
            enabled = false,
          },
        },
        messages = {
          view_search = false,
        },
        popupmenu = {
          backend = "cmp",
        },
      })
    '';
  };
}
