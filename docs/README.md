# Neovim config

This repository contains my Neovim configuration as a Nix flake.

## 🏃 Quick start

Install [Nix][nix-installer] and run the following:

```sh
nix run github:desheffer/neovim-config
```

You can also try out this configuration by running it in a Docker container:

```sh
docker run -it --rm \
    -e NIX_CONFIG='experimental-features = nix-command flakes' \
    nixpkgs/nix \
    nix run github:desheffer/neovim-config
```

## 🔨 Installation

You can use this repository in other flakes by adding it as an input:

```nix
{
  inputs = {
    neovim-config.url = "github:desheffer/neovim-config";
  };
}
```

Then, add the following to your Home Manager configuration:

```nix
[
  neovim-config.homeManagerModules.neovim
  {
    programs.neovim-config.enable = true;
  }
]
```

[nix-installer]: https://github.com/DeterminateSystems/nix-installer
