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

  cfg = config.programs.neovim-config.dashboard;

in
{
  options.programs.neovim-config.dashboard = { };

  config.programs.neovim-config = {
    plugins = [
      (pkgs'.vimUtils.buildVimPlugin {
        name = "alpha-nvim";
        src = inputs.alpha-nvim;
        doCheck = false;
      })
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

      local version = vim.version()
      local print_version = "v" .. version.major .. "." .. version.minor .. "." .. version.patch
      dashboard.section.footer.val = print_version

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
        button("New",          "<Space>bn"),
        button("Files",        "<Space>ff"),
        button("Recent Files", "<Space>fo"),
        button("Grep",         "<Space>fg"),
      }

      require("alpha").setup(dashboard.config)
    '';
  };
}
