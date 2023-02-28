inputs:

{ config, lib, pkgs, ... }:

with lib;

let
  lib' = import ../lib inputs;
  pkgs' = lib'.mkPkgs pkgs.system;

  cfg = config.programs.neovim-config.register;

in
{
  options.programs.neovim-config.register = { };

  config.programs.neovim-config = {
    plugins = [
      (pkgs'.vimUtils.buildVimPluginFrom2Nix {
        name = "registers-nvim";
        src = inputs.registers-nvim;
      })
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
