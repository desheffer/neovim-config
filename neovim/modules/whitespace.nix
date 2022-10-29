{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.whitespace;

in
{
  options.modules.whitespace = { };

  config.modules.neovim = {
    plugins = with pkgs.vimPluginsFromInputs; [
      indent-blankline-nvim
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
