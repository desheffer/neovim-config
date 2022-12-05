#!/usr/bin/env bash

set -e

rm -f result
rm -rf build

nix build .#neovim-light

mkdir -p build/nix/store
for STORE_PATH in $(nix-store -qR result); do
    echo "Copying ${STORE_PATH}..."
    cp -R ${STORE_PATH} build/${STORE_PATH}
done

mkdir -p build/usr/local/bin
ln -s $(readlink result)/bin/nvim build/usr/local/bin/nvim

echo "Creating archive..."
tar -cjf neovim.tar.gz -C build .

# tar -tf neovim.tar.gz
# tar -xf neovim.tar.gz -C /
