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

  cfg = config.programs.neovim-config.interface;

in
{
  options.programs.neovim-config.interface = { };

  config.programs.neovim-config = {
    plugins = [
      (pkgs'.vimUtils.buildVimPlugin {
        name = "noice-nvim";
        src = inputs.noice-nvim;
      })
      (pkgs'.vimUtils.buildVimPlugin {
        name = "nui-nvim";
        src = inputs.nui-nvim;
      })
      (pkgs'.vimUtils.buildVimPlugin {
        name = "nvim-notify";
        src = inputs.nvim-notify;
      })
    ];

    config = ''
      require("noice").setup({
        presets = {
          command_palette = true,
          long_message_to_split = true,
          lsp_doc_border = true,
        },
      })
    '';
  };
}
