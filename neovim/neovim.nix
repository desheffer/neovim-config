inputs@{ ... }:

{ config, lib, pkgs, ... }:

with lib;

let
  lib' = import ../lib inputs;
  pkgs' = lib'.mkPkgs pkgs.system;

  cfg = config.programs.neovim-config;

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
  options.programs.neovim-config = {
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

    mappings =
      let
        mappingOpts = {
          options = {
            lhs = mkOption {
              type = types.str;
              description = "Sets the left-hand-side of the mapping.";
              default = null;
            };

            name = mkOption {
              type = types.str;
              description = "Sets the name of the mapping or mapping group.";
              default = null;
            };

            rhs = mkOption {
              type = types.nullOr types.str;
              description = "Sets the right-hand-side of the mapping.";
              default = null;
            };

            lua = mkOption {
              type = types.nullOr types.str;
              description = "Sets the right-hand-side of the mapping as Lua code.";
              default = null;
            };

            mode = mkOption {
              type = types.str;
              description = "Sets the mode short-name.";
              default = "n";
            };
          };
        };
      in
      mkOption {
        type = types.listOf (types.submodule mappingOpts);
        description = "Sets the available key mappings.";
        default = { };
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
    programs.neovim-config.finalPackage = pkgs'.wrapNeovim
      pkgs'.neovim-unwrapped
      neovimConfig;
  };
}
