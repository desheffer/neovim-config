{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.syntax;

in
{
  options.modules.syntax = { };

  config.modules.neovim = {
    plugins = (with pkgs.vimPluginsFromInputs; [
      # (nvim-treesitter.overrideAttrs (_: {
      #   postPatch =
      #     let
      #       grammarFn = _: pkgs.tree-sitter.allGrammars;
      #       grammars = pkgs.tree-sitter.withPlugins grammarFn;
      #     in
      #     ''
      #       rm -r parser
      #       ln -s ${grammars} parser
      #     '';
      # }))
      nvim-treesitter-context
    ]) ++ (with pkgs; with vimPlugins; [
      (nvim-treesitter.withPlugins (_: tree-sitter.allGrammars))
    ]);

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
