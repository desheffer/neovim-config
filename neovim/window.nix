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

  cfg = config.programs.neovim-config.window;

in
{
  options.programs.neovim-config.window = { };

  config.programs.neovim-config = {
    plugins = [
    ];

    config = '''';

    mappings = [
      {
        lhs = "<Leader>w";
        name = "+window";
      }
      {
        lhs = "<Leader>wd";
        name = "Delete window";
        lua = ''pcall(function () vim.cmd([[close]]) end)'';
      }
      {
        lhs = "<Leader>w-";
        name = "Split window horizontally";
        lua = ''vim.cmd([[split]])'';
      }
      {
        lhs = "<Leader>w|";
        name = "Split window vertically";
        lua = ''vim.cmd([[vsplit]])'';
      }
    ];
  };
}
