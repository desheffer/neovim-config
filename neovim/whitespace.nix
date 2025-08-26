inputs:

{
  config,
  lib,
  pkgs,
  ...
}:

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
      (pkgs'.vimUtils.buildVimPlugin {
        name = "indent-blankline-nvim";
        src = inputs.indent-blankline-nvim;
        doCheck = false;
      })
    ];

    config = ''
      require("ibl").setup()

      -- Remove trailing whitespace on save.
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*",
        callback = function ()
          local pos = vim.api.nvim_win_get_cursor(0)
          vim.cmd([[%s/\s\+$//e]])
          vim.api.nvim_win_set_cursor(0, pos)
        end,
      })

      -- Override line shift to preserve selection.
      vim.keymap.set("v", "<", [[<gv]])
      vim.keymap.set("v", ">", [[>gv]])
    '';
  };
}
