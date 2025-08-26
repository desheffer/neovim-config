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

  cfg = config.programs.neovim-config.colorscheme;

in
{
  options.programs.neovim-config.colorscheme = { };

  config.programs.neovim-config = {
    plugins = [
      (pkgs'.vimUtils.buildVimPlugin {
        name = "gruvbox-material";
        src = inputs.gruvbox-material;
        doCheck = false;
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
          -- Tone down search highlighting.
          vim.cmd([[highlight! IncSearch ctermfg=235 ctermbg=208 guifg=#282828 guibg=#fe8019]])
          vim.cmd([[highlight! Search ctermfg=235 ctermbg=214 guifg=#282828 guibg=#fabd2f]])

          -- Make matching braces more obvious.
          vim.cmd([[highlight! MatchParen cterm=bold gui=bold]])

          -- Hide the NvimTree separator.
          vim.cmd([[highlight! link NvimTreeWinSeparator NvimTreeEndOfBuffer]])
          vim.cmd([[highlight! link NvimTreeStatusLine NvimTreeEndOfBuffer]])
          vim.cmd([[highlight! link NvimTreeStatusLineNC NvimTreeEndOfBuffer]])
        end,
      })

      vim.cmd([[colorscheme gruvbox-material]])
    '';
  };
}
