inputs@{ ... }:

{ config, lib, pkgs, ... }:

with lib;

let
  lib' = import ../lib inputs;
  pkgs' = lib'.mkPkgs pkgs.system;

  cfg = config.programs.neovim-config.git;

in
{
  options.programs.neovim-config.git = { };

  config.programs.neovim-config = {
    plugins = [
      (pkgs'.vimUtils.buildVimPluginFrom2Nix {
        name = "gitsigns-nvim";
        src = inputs.gitsigns-nvim;
      })
    ];

    config = ''
      -- Always show sign column.
      vim.opt.signcolumn = "yes"

      require("gitsigns").setup()
    '';
  };
}
