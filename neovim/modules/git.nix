{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.git;

in
{
  options.modules.git = { };

  config.modules.neovim = {
    plugins = with pkgs.vimPluginsFromInputs; [
      gitsigns-nvim
    ];

    config = ''
      -- Always show sign column.
      vim.opt.signcolumn = "yes"

      require("gitsigns").setup()
    '';
  };
}
