inputs:

{ config, lib, ... }:

let
  cfg = config.programs.neovim-config;

in
{
  options.programs.neovim-config = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to enable Neovim.";
      default = false;
    };
  };

  imports = [ (import ../neovim inputs) ];

  config = lib.mkIf cfg.enable { home.packages = [ config.programs.neovim-config.finalPackage ]; };
}
