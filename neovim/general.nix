inputs:

{ config, lib, pkgs, ... }:

with lib;

let
  lib' = import ../lib inputs;
  pkgs' = lib'.mkPkgs pkgs.system;

  cfg = config.programs.neovim-config.general;

in
{
  options.programs.neovim-config.general = { };

  config.programs.neovim-config = {
    extraPackages = with pkgs'; [
      curl
      python3
    ];

    config = ''
      -- Disable mouse support.
      vim.opt.mouse = ""

      -- Disable swap files.
      vim.opt.swapfile = false

      -- Enable persistent undo.
      vim.opt.undofile = true

      -- Allow editing with multiple buffers.
      vim.opt.hidden = true

      -- Use 4 spaces for indentation.
      vim.opt.expandtab = true
      vim.opt.shiftwidth = 4
      vim.opt.tabstop = 4
      vim.opt.shiftround = true

      -- Use 2 spaces for indentation for certain file types.
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {"java", "nix"},
        callback = function ()
          vim.bo.shiftwidth = 2
          vim.bo.tabstop = 2
        end,
      })

      -- Use tabs for indentation for certain file types.
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {"go"},
        callback = function ()
          vim.bo.expandtab = false
        end,
      })

      -- Ignore case unless searching with uppercase letters.
      vim.opt.ignorecase = true
      vim.opt.smartcase = true

      -- Show the effects of a command as it is typed.
      vim.opt.inccommand = "nosplit"

      -- Use a single space when joining lines.
      vim.opt.joinspaces = false

      -- Show relative line numbers.
      vim.opt.number = true
      vim.opt.relativenumber = true

      -- Draw right margin at 80 characters.
      vim.opt.colorcolumn = "80"

      -- Set colorcolumn dynamically if textwidth is set.
      vim.api.nvim_create_autocmd("BufEnter", {
          pattern = "*",
          callback = function ()
              if vim.bo.textwidth > 0 then
                  vim.wo.colorcolumn = "+1"
              end
          end,
      })

      -- Wrap lines at the word boundary.
      vim.opt.linebreak = true

      -- Pad the cursor with 5 lines.
      vim.opt.scrolloff = 5

      -- Do not display end-of-buffer tildes.
      vim.opt.fillchars:append("eob: ")

      -- Display hidden characters.
      vim.opt.list = true
      vim.opt.listchars:append("tab:——▷")
      vim.opt.listchars:append("trail:·")

      -- Enable spell checking.
      vim.opt.spell = true

      -- Make completion mode act like Bash.
      vim.opt.wildmode = "longest,list"

      -- Hide redundant notification of current mode.
      vim.opt.showmode = false

      -- Split windows below and to the right.
      vim.opt.splitbelow = true
      vim.opt.splitright = true
    '';
  };
}
