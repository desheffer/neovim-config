inputs:

{
  config,
  lib,
  pkgs',
  ...
}:

let
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
        doCheck = false;
      })
    ];

    extraPackages = with pkgs'; [ gcc ];

    config = ''
      -- Enable highlighting for every file type that has a parser.
      vim.api.nvim_create_autocmd("FileType", {
        callback = function ()
          pcall(vim.treesitter.start)
        end,
      })

      -- Expand and shrink the selection by syntax node.
      vim.keymap.set("x", ".", "an", {remap = true})
      vim.keymap.set("x", ",", "in", {remap = true})

      require("treesitter-context").setup({
        multiline_threshold = 1,
      })
    '';
  };
}
