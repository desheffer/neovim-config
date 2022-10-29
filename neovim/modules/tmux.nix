{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.tmux;

in
{
  options.modules.tmux = { };

  config.modules.neovim = {
    plugins = with pkgs.vimPluginsFromInputs; [
      vim-tmux-navigator
    ];

    config = ''
      -- Disable default Tmux mappings.
      vim.g.tmux_navigator_no_mappings = 1

      -- Integrate navigation between Neovim and Tmux.
      vim.keymap.set({"", "c", "i"}, "<C-w>h", function () vim.cmd([[TmuxNavigateLeft]])  end)
      vim.keymap.set({"", "c", "i"}, "<C-w>j", function () vim.cmd([[TmuxNavigateDown]])  end)
      vim.keymap.set({"", "c", "i"}, "<C-w>k", function () vim.cmd([[TmuxNavigateUp]])    end)
      vim.keymap.set({"", "c", "i"}, "<C-w>l", function () vim.cmd([[TmuxNavigateRight]]) end)

      -- Add intuitive mappings to create window splits.
      vim.keymap.set("n", "<C-w>-", function () vim.cmd([[split]])  end)
      vim.keymap.set("n", "<C-w>|", function () vim.cmd([[vsplit]]) end)
    '';
  };
}
