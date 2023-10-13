inputs:

{ config, lib, pkgs, ... }:

with lib;

let
  lib' = import ../lib inputs;
  pkgs' = lib'.mkPkgs pkgs.system;

  cfg = config.programs.neovim-config.whichkey;

  mapMapping = elem:
    ''wk.register({ ["${elem.lhs}"] = {'' + (
      if elem.rhs != null then
        ''[[${elem.rhs}]], [[${elem.name}]]''
      else if elem.lua != null then
        ''function () ${elem.lua} end, [[${elem.name}]]''
      else
        ''name = [[${elem.name}]]''
    ) + ''}}, {mode = [[${elem.mode}]]})
    '';
  concat = foldr (a: b: a + b) "";
  registerMappings = concat (map mapMapping config.programs.neovim-config.mappings);

in
{
  options.programs.neovim-config.whichkey = { };

  config.programs.neovim-config = {
    plugins = [
      (pkgs'.vimUtils.buildVimPlugin {
        name = "which-key-nvim";
        src = inputs.which-key-nvim;
      })
    ];

    config = ''
      vim.opt.timeout = true
      vim.opt.timeoutlen = 500

      local wk = require("which-key")
      wk.setup({
        plugins = {
          registers = false,
          spelling = {
            enabled = false,
          },
        },
        ignore_missing = true,
      })

      ${registerMappings}
    '';
  };
}
