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
        lhs = "<Leader>p";
        name = "Paste from system clipboard";
        rhs = ''"+p'';
      }
      {
        lhs = "<Leader>p";
        name = "Paste from system clipboard";
        rhs = ''"+p'';
        mode = "v";
      }
      {
        lhs = "<Leader>P";
        name = "Paste from primary selection";
        rhs = ''"*p'';
      }
      {
        lhs = "<Leader>P";
        name = "Paste from primary selection";
        rhs = ''"*p'';
        mode = "v";
      }
      {
        lhs = "<Leader>y";
        name = "Copy to system clipboard";
        rhs = ''"+y'';
        mode = "v";
      }
      {
        lhs = "<Leader>Y";
        name = "Copy to primary selection";
        rhs = ''"*y'';
        mode = "v";
      }
    ];
  };
}
