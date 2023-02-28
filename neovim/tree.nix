inputs:

{ config, lib, pkgs, ... }:

with lib;

let
  lib' = import ../lib inputs;
  pkgs' = lib'.mkPkgs pkgs.system;

  cfg = config.programs.neovim-config.tree;

in
{
  options.programs.neovim-config.tree = { };

  config.programs.neovim-config = {
    plugins = [
      (pkgs'.vimUtils.buildVimPluginFrom2Nix {
        name = "nvim-tree-lua";
        src = inputs.nvim-tree-lua;
      })
    ];

    config = ''
      require("nvim-tree").setup({
        actions = {
          open_file = {
            quit_on_open = true,
          },
        },
        hijack_cursor = true,
        update_cwd = true,
        update_focused_file = {
          enable = true,
        },
        view = {
          mappings = {
            list = {
              {key = {"<Esc>"}, cb = "<Cmd>NvimTreeClose<CR>", mode = "n"},
            },
          },
          width = 50,
        },
      })

      local focus = function ()
        local tree = require("nvim-tree")
        tree.find_file(true)
        tree.focus()
      end

      -- Focus the file tree with <Leader>n.
      vim.keymap.set("n", "<Leader>n", focus)
    '';
  };
}
