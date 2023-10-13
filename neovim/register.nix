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
      (pkgs'.vimUtils.buildVimPlugin {
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

      -- Override put to avoid replacing the register value.
      vim.keymap.set("v", "p", [[pgvy]])
    '';

    mappings = [
      {
        lhs = "<Leader>y";
        name = "Copy to system clipboard";
        rhs = ''"+y'';
        mode = "v";
      }
    ];
  };
}
