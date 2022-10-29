{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.dashboard;

in
{
  options.modules.dashboard = { };

  config.modules.neovim = {
    plugins = with pkgs.vimPluginsFromInputs; [
      alpha-nvim
    ];

    config = ''
      local dashboard = require("alpha.themes.dashboard")

      dashboard.section.header.val = {
        "███╗   ██╗ ██╗   ██╗ ██╗ ███╗   ███╗",
        "████╗  ██║ ██║   ██║ ██║ ████╗ ████║",
        "██╔██╗ ██║ ██║   ██║ ██║ ██╔████╔██║",
        "██║╚██╗██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
        "██║ ╚████║  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
        "╚═╝  ╚═══╝   ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
      }

      local function button(text, keycode)
        local function on_press()
          local keys = vim.api.nvim_replace_termcodes(keycode, true, false, true)
          vim.api.nvim_feedkeys(keys, "t", false)
        end

        return {
          type = "button",
          val = text,
          on_press = on_press,
          opts = {
            position = "center",
            shortcut = keycode,
            cursor = 0,
            width = 40,
            align_shortcut = "right",
            hl_shortcut = "Keyword",
          },
        }
      end

      dashboard.section.buttons.val = {
        button("New",          "<C-n>"),
        button("Files",        "<C-p>"),
        button("Sessions",     "<Space>fs"),
        button("Recent Files", "<Space>fo"),
        button("Grep",         "<Space>fg"),
      }

      require("alpha").setup(dashboard.config)
    '';
  };
}
