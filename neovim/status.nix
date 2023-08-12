inputs:

{ config, lib, pkgs, ... }:

with lib;

let
  lib' = import ../lib inputs;
  pkgs' = lib'.mkPkgs pkgs.system;

  cfg = config.programs.neovim-config.interface;

in
{
  options.programs.neovim-config.interface = { };

  config.programs.neovim-config = {
    plugins = [
      (pkgs'.vimUtils.buildVimPluginFrom2Nix {
        name = "lualine-nvim";
        src = inputs.lualine-nvim;
      })
      (pkgs'.vimUtils.buildVimPluginFrom2Nix {
        name = "nvim-web-devicons";
        src = inputs.nvim-web-devicons;
      })
    ];

    config = ''
      require("lualine").setup({
        options = {
          theme = "gruvbox",
          disabled_filetypes = {"NvimTree"},
          section_separators = {left = "", right = ""},
          component_separators = {left = "", right = ""},
        },
        sections = {
          lualine_b = {
            require('auto-session.lib').current_session_name,
            "branch",
            "diff",
            {
              "diagnostics",
              sources = {"nvim_diagnostic"},
              sections = {"error", "warn", "info", "hint"},
              diagnostics_color = {
                error = {fg = "#fb4934"},
                warn = {fg = "#fabd2f"},
                info = {fg = "#83a598"},
                hint = {fg = "#8ec07c"},
              },
              symbols = {error = "󰀩 ", warn = "󰀦 ", info = "󰋼 ", hint = "󰌵 "},
            },
          },
        },
      })
    '';
  };
}
