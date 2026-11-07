inputs:

{
  config,
  lib,
  pkgs',
  ...
}:

let
  cfg = config.programs.neovim-config.register;

in
{
  options.programs.neovim-config.register = { };

  config.programs.neovim-config = {
    config = ''
      -- Override put to avoid replacing the register value.
      vim.keymap.set("v", "p", [[pgvy]])
    '';

    mappings = [
      {
        lhs = "<Leader>y";
        name = "Copy to system clipboard";
        rhs = ''"+y'';
        mode = "v";
      }
    ];
  };
}
