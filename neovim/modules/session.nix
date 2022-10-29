{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.session;

in
{
  options.modules.session = { };

  config.modules.neovim = {
    plugins = with pkgs.vimPluginsFromInputs; [
      auto-session
    ];

    config = ''
      -- Save most things in the session.
      vim.opt.sessionoptions = "buffers,curdir,folds,tabpages,terminal,winpos,winsize"

      local is_git = vim.fn.system("[ -d .git ] && echo -n .git") == ".git"

      require("auto-session").setup({
        auto_session_create_enabled = is_git,
        log_level = "error",
      })
    '';
  };
}
