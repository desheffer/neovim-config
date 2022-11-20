# Neovim config

This repository contains my Neovim configuration as a Nix flake.

## 🏃 Quick start

Install [Nix][nix-download] and run the following:

```sh
nix run github:desheffer/neovim-config
```

Or, if you have a local copy of this repository:

```sh
nix run
```

If you do not have Nix installed, you can run these steps in a Docker
container:

```sh
docker run -it --rm \
    -e NIX_CONFIG='experimental-features = nix-command flakes' \
    -e TERM=xterm-256color \
    nixpkgs/nix \
    nix run github:desheffer/neovim-config
```

### 🔨 Installation

You can include this repository in other flakes by adding it as an input:

```nix
{
  inputs = {
    neovim-config.url = "github:desheffer/neovim-config";
  };
}
```

Then, install it using the Home Manager module:

```nix
{
    configuration.imports = [
        neovim-config.nixosModules.home-manager.neovim
        {
            programs.neovim-config.enable = true;
        }
    ];
}
```

[nix-download]: https://nixos.org/download.html
