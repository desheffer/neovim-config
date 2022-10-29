{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.notice;

in
{
  options.modules.notice = { };

  config.modules.neovim = {
    # plugins = with pkgs.vimPluginsFromInputs; [
    #   noice-nvim
    #   nui-nvim
    #   # nvim-notify
    # ];
    #
    # config = ''
    #   require("noice").setup({
    #     messages = {
    #       view_search = false,
    #     },
    #     popupmenu = {
    #       backend = "cmp",
    #     },
    #     -- routes = {
    #     --   -- Hide messages when a file is written.
    #     --   {
    #     --     filter = {
    #     --       event = "msg_show",
    #     --       kind = "",
    #     --       find = "written",
    #     --     },
    #     --     opts = { skip = true },
    #     --   },
    #     -- },
    #   })
    # '';
  };
}
