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
      (pkgs'.vimUtils.buildVimPluginFrom2Nix {
        name = "comment-nvim";
        src = inputs.comment-nvim;
      })
      (pkgs'.vimUtils.buildVimPluginFrom2Nix {
        name = "vim-argumentative";
        src = inputs.vim-argumentative;
      })
      (pkgs'.vimUtils.buildVimPluginFrom2Nix {
        name = "vim-easy-align";
        src = inputs.vim-easy-align;
      })
      (pkgs'.vimUtils.buildVimPluginFrom2Nix {
        name = "vim-repeat";
        src = inputs.vim-repeat;
      })
      (pkgs'.vimUtils.buildVimPluginFrom2Nix {
        name = "vim-surround";
        src = inputs.vim-surround;
      })
      (pkgs'.vimUtils.buildVimPluginFrom2Nix {
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
