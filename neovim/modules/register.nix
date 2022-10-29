{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.register;

in
{
  options.modules.register = { };

  config.modules.neovim = {
    plugins = with pkgs.vimPluginsFromInputs; [
      registers-nvim
    ];

    config = ''
      require("registers").setup({
        window = {
          border = "rounded",
        },
      });

      -- Make Y yank to end of line.
      vim.keymap.set("n", "Y", [[y$]])

      -- Prevent p from replacing the register by copying the pasted text.
      vim.keymap.set("v", "p", [[pgvy]])

      -- Copy to system clipboard with <Leader>y.
      vim.keymap.set("v", "<Leader>y", [["+y]])
    '';
  };
}
