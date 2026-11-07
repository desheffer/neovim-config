inputs@{ ... }:

{
  config,
  lib,
  pkgs',
  ...
}:

let
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

    extraMakeWrapperArgs = lib.optionalString (
      cfg.extraPackages != [ ]
    ) ''--suffix PATH : "${lib.makeBinPath cfg.extraPackages}"'';
  };

in
{
  options.programs.neovim-config = {
    leader = lib.mkOption {
      type = lib.types.str;
      description = "Set the mapleader value.";
      default = " ";
    };

    config = lib.mkOption {
      type = lib.types.lines;
      description = "Custom Neovim Lua configuration lines.";
      default = "";
    };

    mappings =
      let
        mappingOpts = {
          options = {
            lhs = lib.mkOption {
              type = lib.types.str;
              description = "Sets the left-hand-side of the mapping.";
              default = null;
            };

            name = lib.mkOption {
              type = lib.types.str;
              description = "Sets the name of the mapping or mapping group.";
              default = null;
            };

            rhs = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              description = "Sets the right-hand-side of the mapping.";
              default = null;
            };

            lua = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              description = "Sets the right-hand-side of the mapping as Lua code.";
              default = null;
            };

            mode = lib.mkOption {
              type = lib.types.str;
              description = "Sets the mode short-name.";
              default = "n";
            };
          };
        };
      in
      lib.mkOption {
        type = lib.types.listOf (lib.types.submodule mappingOpts);
        description = "Sets the available key mappings.";
        default = { };
      };

    plugins = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      description = "Plugins to load when Neovim is started.";
      default = [ ];
    };

    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      description = "Extra packages available to Neovim.";
      default = [ ];
    };

    finalPackage = lib.mkOption {
      type = lib.types.package;
      description = "Resulting customized Neovim package.";
      visible = false;
      readOnly = true;
    };
  };

  config = {
    programs.neovim-config.finalPackage = pkgs'.wrapNeovim pkgs'.neovim-unwrapped neovimConfig;
  };
}
