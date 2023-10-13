inputs:

{ config, lib, pkgs, ... }:

with lib;

let
  lib' = import ../lib inputs;
  pkgs' = lib'.mkPkgs pkgs.system;

  cfg = config.programs.neovim-config.editing;

in
{
  options.programs.neovim-config.editing = { };

  config.programs.neovim-config = {
    plugins = [
      (pkgs'.vimUtils.buildVimPlugin {
        name = "comment-nvim";
        src = inputs.comment-nvim;
      })
      (pkgs'.vimUtils.buildVimPlugin {
        name = "vim-argumentative";
        src = inputs.vim-argumentative;
      })
      (pkgs'.vimUtils.buildVimPlugin {
        name = "vim-easy-align";
        src = inputs.vim-easy-align;
      })
      (pkgs'.vimUtils.buildVimPlugin {
        name = "vim-repeat";
        src = inputs.vim-repeat;
      })
      (pkgs'.vimUtils.buildVimPlugin {
        name = "vim-surround";
        src = inputs.vim-surround;
      })
      (pkgs'.vimUtils.buildVimPlugin {
        name = "vim-unimpaired";
        src = inputs.vim-unimpaired;
      })
    ];

    config = ''
      require("Comment").setup()
    '';

    mappings = [
      {
        lhs = "ga";
        name = "Align character";
        rhs = ''<Plug>(EasyAlign)'';
      }
      {
        lhs = "ga";
        name = "Align character";
        rhs = ''<Plug>(EasyAlign)'';
        mode = "x";
      }
    ];
  };
}
