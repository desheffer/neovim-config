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
      (pkgs'.vimUtils.buildVimPlugin {
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
        on_attach = function (bufnr)
          local api = require("nvim-tree.api")

          vim.keymap.set("n", "<CR>",  api.node.open.edit, {buffer = bufnr})
          vim.keymap.set("n", "<Esc>", api.tree.close,     {buffer = bufnr})
          vim.keymap.set("n", "a",     api.fs.create,      {buffer = bufnr})
          vim.keymap.set("n", "d",     api.fs.remove,      {buffer = bufnr})
          vim.keymap.set("n", "r",     api.fs.rename,      {buffer = bufnr})
          vim.keymap.set("n", "R",     api.tree.reload,    {buffer = bufnr})
        end,
        view = {
          width = 50,
        },
      })
    '';

    mappings = [
      {
        lhs = "<Leader>n";
        name = "Show file tree";
        lua = ''
          local api = require("nvim-tree.api")
          api.tree.find_file({open = true})
          api.tree.focus()
        '';
      }
    ];
  };
}
