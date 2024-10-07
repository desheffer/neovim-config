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

  cfg = config.programs.neovim-config.syntax;

in
{
  options.programs.neovim-config.syntax = { };

  config.programs.neovim-config = {
    plugins = [
      pkgs'.vimPlugins.nvim-treesitter.withAllGrammars

      (pkgs'.vimUtils.buildVimPlugin {
        name = "nvim-treesitter-context";
        src = inputs.nvim-treesitter-context;
      })
    ];

    extraPackages = with pkgs'; [ gcc ];

    config = ''
      require("nvim-treesitter.configs").setup({
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            node_incremental = ".",
            node_decremental = ",",
          },
        },
      })

      require("treesitter-context").setup()
    '';
  };
}
