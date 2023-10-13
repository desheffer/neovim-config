inputs:

{ config, lib, pkgs, ... }:

with lib;

let
  lib' = import ../lib inputs;
  pkgs' = lib'.mkPkgs pkgs.system;

  cfg = config.programs.neovim-config.colorscheme;

in
{
  options.programs.neovim-config.colorscheme = { };

  config.programs.neovim-config = {
    plugins = [
      (pkgs'.vimUtils.buildVimPlugin {
        name = "gruvbox-material";
        src = inputs.gruvbox-material;
      })
    ];

    config = ''
      vim.opt.termguicolors = true
      vim.opt.background = "dark"

      vim.g.gruvbox_material_background = "medium"
      vim.g.gruvbox_material_palette = "original"

      vim.g.gruvbox_material_enable_bold = 1
      vim.g.gruvbox_material_enable_italic = 1

      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "gruvbox-material",
        callback = function ()
          -- Tone down the search highlighting.
          vim.cmd([[highlight! IncSearch cterm=reverse gui=reverse guifg=#fe811b guibg=#29292]])
          vim.cmd([[highlight! Search ctermfg=0 ctermbg=11 gui=reverse guifg=#fabd2e guibg=#29292]])

          -- Darken the NvimTree window.
          vim.cmd([[highlight! NvimTreeNormal ctermfg=223 ctermbg=235 guifg=#ebdbb2 guibg=#1e1e1e]])
          vim.cmd([[highlight! NvimTreeEndOfBuffer ctermfg=239 ctermbg=235 guifg=#1e1e1e guibg=#1e1e1e]])
          vim.cmd([[highlight! NvimTreeVertSplit ctermfg=239 guifg=#1e1e1e guibg=#1e1e1e]])

          -- Make matching braces a little more obvious.
          vim.cmd([[highlight! MatchParen cterm=bold gui=bold]])
        end,
      })

      vim.cmd([[colorscheme gruvbox-material]])
    '';
  };
}
