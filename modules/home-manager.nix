inputs:

{ config, lib, ... }:

with lib;

let
  cfg = config.programs.neovim-config;

in
{
  options.programs.neovim-config = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable Neovim.";
      default = false;
    };
  };

  imports = [
    (import ../neovim inputs)
  ];

  config = mkIf cfg.enable {
    home.packages = [
      config.programs.neovim-config.finalPackage
    ];
  };
}
