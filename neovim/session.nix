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

  cfg = config.programs.neovim-config.session;

in
{
  options.programs.neovim-config.session = { };

  config.programs.neovim-config = {
    plugins = [
      (pkgs'.vimUtils.buildVimPlugin {
        name = "auto-session";
        src = inputs.auto-session;
      })
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
