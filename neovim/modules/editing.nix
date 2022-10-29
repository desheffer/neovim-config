{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.editing;

in
{
  options.modules.editing = { };

  config.modules.neovim = {
    plugins = with pkgs.vimPluginsFromInputs; [
      comment-nvim
      nvim-autopairs
      vim-argumentative
      vim-easy-align
      vim-repeat
      vim-surround
      vim-unimpaired
    ];

    config = ''
      require("Comment").setup()

      require("nvim-autopairs").setup({})

      -- Invoke EasyAlign with ga{char}.
      vim.keymap.set({"n", "x"}, "ga", [[<Plug>(EasyAlign)]])
    '';
  };
}
