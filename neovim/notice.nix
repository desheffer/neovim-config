inputs:

{ config, lib, pkgs, ... }:

with lib;

let
  lib' = import ../lib inputs;
  pkgs' = lib'.mkPkgs pkgs.system;

  cfg = config.modules.notice;

in
{
  options.programs.neovim-config.notice = { };

  config.programs.neovim-config = {
    plugins = [
      (pkgs'.vimUtils.buildVimPluginFrom2Nix {
        name = "noice-nvim";
        src = inputs.noice-nvim;
      })
      (pkgs'.vimUtils.buildVimPluginFrom2Nix {
        name = "nui-nvim";
        src = inputs.nui-nvim;
      })
      (pkgs'.vimUtils.buildVimPluginFrom2Nix {
        name = "nvim-notify";
        src = inputs.nvim-notify;
      })
    ];

    config = ''
      require("noice").setup({
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        messages = {
          enabled = false,
        },
        popupmenu = {
          backend = "cmp",
        },
        presets = {
          long_message_to_split = true,
        },
      })

      -- Bind history command.
      vim.keymap.set("n", "<Leader>fn", function () vim.cmd([[Noice telescope]]) end)
    '';
  };
}
