{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.neovim;

  neovimConfig = {
    viAlias = true;
    vimAlias = true;

    configure = {
      customRC = ''
        lua << EOF
        vim.g.mapleader = "${cfg.leader}"
        ${cfg.config}
        EOF
      '';

      packages.myVimPackage = {
        start = cfg.plugins;
      };
    };

    extraMakeWrapperArgs = lib.optionalString (cfg.extraPackages != [ ])
      ''--suffix PATH : "${lib.makeBinPath cfg.extraPackages}"'';
  };

in
{
  options.modules.neovim = {
    leader = mkOption {
      type = types.str;
      description = "Set the mapleader value.";
      default = " ";
    };

    config = mkOption {
      type = types.lines;
      description = "Custom Neovim Lua configuration lines.";
      default = "";
    };

    plugins = mkOption {
      type = types.listOf types.package;
      description = "Plugins to load when Neovim is started.";
      default = [ ];
    };

    extraPackages = mkOption {
      type = types.listOf types.package;
      description = "Extra packages available to Neovim.";
      default = [ ];
    };

    finalPackage = mkOption {
      type = types.package;
      description = "Resulting customized Neovim package.";
      visible = false;
      readOnly = true;
    };
  };

  config = {
    modules.neovim.finalPackage = pkgs.wrapNeovim pkgs.neovim-unwrapped (
      neovimConfig
    );
  };
}
