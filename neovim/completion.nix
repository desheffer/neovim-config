inputs:

{
  config,
  lib,
  pkgs',
  ...
}:

let
  cfg = config.programs.neovim-config.completion;

in
{
  options.programs.neovim-config.completion = { };

  config.programs.neovim-config = {
    plugins = [
      pkgs'.vimPlugins.blink-cmp

      (pkgs'.vimUtils.buildVimPlugin {
        name = "friendly-snippets";
        src = inputs.friendly-snippets;
        doCheck = false;
      })
    ];

    config = ''
      require("blink.cmp").setup({
        cmdline = {
          enabled = false,
        },
        completion = {
          documentation = {
            auto_show = true,
            window = {
              border = "rounded",
            },
          },
          list = {
            selection = {
              preselect = false,
            },
          },
        },
        keymap = {
          preset = "default",
          ["<CR>"] = {"accept", "fallback"},
          ["<C-d>"] = {"scroll_documentation_down", "fallback"},
          ["<C-u>"] = {"scroll_documentation_up", "fallback"},
          ["<Tab>"] = {"snippet_forward", "select_next", "fallback"},
          ["<S-Tab>"] = {"snippet_backward", "select_prev", "fallback"},
        },
        sources = {
          default = {"lsp", "snippets", "buffer"},
        },
      })
    '';
  };
}
