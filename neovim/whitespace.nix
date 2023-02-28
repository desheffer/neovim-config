inputs:

{ config, lib, pkgs, ... }:

with lib;

let
  lib' = import ../lib inputs;
  pkgs' = lib'.mkPkgs pkgs.system;

  cfg = config.programs.neovim-config.whitespace;

in
{
  options.programs.neovim-config.whitespace = { };

  config.programs.neovim-config = {
    plugins = [
      (pkgs'.vimUtils.buildVimPluginFrom2Nix {
        name = "indent-blankline-nvim";
        src = inputs.indent-blankline-nvim;
      })
    ];

    config = ''
      -- Set indentation marker character.
      vim.g.indent_blankline_char = "▏"

      -- Hide indentation marker for certain file types.
      vim.g.indent_blankline_filetype_exclude = {"dashboard", "help", "lsp-installer", "NvimTree"}

      -- Remove trailing whitespace on save.
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*",
        callback = function ()
          local pos = vim.api.nvim_win_get_cursor(0)
          vim.cmd([[%s/\s\+$//e]])
          vim.api.nvim_win_set_cursor(0, pos)
        end,
      })

      -- Preserve selection on indent.
      vim.keymap.set("v", "<", [[<gv]])
      vim.keymap.set("v", ">", [[>gv]])
    '';
  };
}
