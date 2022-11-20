inputs@{ ... }:

{ config, lib, pkgs, ... }:

with lib;

let
  lib' = import ../lib inputs;
  pkgs' = lib'.mkPkgs pkgs.system;

  cfg = config.programs.neovim-config.buffer;

in
{
  options.programs.neovim-config.buffer = { };

  config.programs.neovim-config = {
    plugins = [
      (pkgs'.vimUtils.buildVimPluginFrom2Nix {
        name = "bufferline-nvim";
        src = inputs.bufferline-nvim;
      })
      (pkgs'.vimUtils.buildVimPluginFrom2Nix {
        name = "nvim-web-devicons";
        src = inputs.nvim-web-devicons;
      })
    ];

    config = ''
      require("bufferline").setup({
        options = {
          offsets = {
            {
              filetype = "NvimTree",
              highlight = "NvimTreeNormal",
              padding = 1,
            },
          },
          show_buffer_close_icons = false,
          show_close_icon = false,
        },
      })

      -- Hide certain buffers in the buffer list.
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {"qf", "vim"},
        callback = function ()
          vim.bo.buflisted = false
        end,
      })

      local placeholder = "placeholder"

      local next = function ()
        local buflisted = vim.api.nvim_buf_get_option(0, "buflisted")

        local windows = vim.tbl_filter(function (window)
          return vim.api.nvim_win_is_valid(window)
        end, vim.api.nvim_list_wins())

        -- Avoid getting stuck on an unlisted buffer.
        if not buflisted and #windows <= 1 then
          pcall(vim.cmd, [[bnext]])
          return
        end

        require("bufferline").cycle(1)
      end

      local prev = function ()
        local buflisted = vim.api.nvim_buf_get_option(0, "buflisted")

        local windows = vim.tbl_filter(function (window)
          return vim.api.nvim_win_is_valid(window)
        end, vim.api.nvim_list_wins())

        -- Avoid getting stuck on an unlisted buffer.
        if not buflisted and #windows <= 1 then
          pcall(vim.cmd, [[bprev]])
          return
        end

        require("bufferline").cycle(-1)
      end

      -- Delete the current buffer. If the buffer is listed, then swap in another
      -- buffer to preserve the window layout. If the buffer is unlisted, then close
      -- its window before deleting it (which mirrors how unlisted buffers are
      -- typically created in new windows).
      local delete = function ()
        local current_buffer = vim.api.nvim_get_current_buf()
        local buflisted = vim.api.nvim_buf_get_option(current_buffer, "buflisted")
        local filetype = vim.api.nvim_buf_get_option(current_buffer, "filetype")

        local buffers = vim.tbl_filter(function (buffer)
          return vim.api.nvim_buf_is_valid(buffer)
        end, vim.api.nvim_list_bufs())

        local listed_buffers = vim.tbl_filter(function (buffer)
          return vim.api.nvim_buf_get_option(buffer, "buflisted")
        end, buffers)

        local windows = vim.tbl_filter(function (window)
          return vim.api.nvim_win_is_valid(window)
        end, vim.api.nvim_list_wins())

        if filetype == placeholder then
          return
        end

        -- If the buffer is unlisted (e.g. help, quickfix, tree) and is acting like
        -- a sidebar, then close its window before deleting the buffer.
        if not buflisted and #windows > 1 then
          vim.api.nvim_win_close(0, {})
        end

        -- Find a replacement buffer to swap in for the buffer being deleted.
        local replacement_buffer = current_buffer
        for index, buffer in ipairs(listed_buffers) do
          if buffer == current_buffer then
            replacement_buffer = listed_buffers[index % #listed_buffers + 1]
            break
          end
        end

        -- If a suitable buffer was not found, then create an empty one.
        if replacement_buffer == current_buffer then
          replacement_buffer = vim.api.nvim_create_buf(false, false)
          vim.api.nvim_buf_set_option(replacement_buffer, "filetype", placeholder)
          vim.api.nvim_buf_set_option(replacement_buffer, "modifiable", false)
        end

        -- Perform the replacement buffer swap.
        for _, window in ipairs(windows) do
          if vim.api.nvim_win_is_valid(window)
            and vim.api.nvim_win_get_buf(window) == current_buffer then
            vim.api.nvim_win_set_buf(window, replacement_buffer)
          end
        end

        -- Delete the buffer with confirmation for any unsaved changes.
        pcall(vim.cmd, string.format([[confirm bdelete %d]], current_buffer))
      end

      -- Create a new buffer with <C-n>.
      vim.keymap.set("n", "<C-n>", function () vim.cmd([[enew]]) end)

      -- Cycle buffers with <M-Pageup> and <M-Pagedown> (for consistency with Tmux).
      vim.keymap.set("n", "<M-Pageup>",   next)
      vim.keymap.set("n", "<M-Pagedown>", prev)

      -- Cycle buffers with gt and gT (for consistency with vanilla Vim tabs).
      vim.keymap.set("n", "gt", next)
      vim.keymap.set("n", "gT", prev)

      -- Save a buffer with <C-s>.
      vim.keymap.set({"i", "n"}, "<C-s>", function () vim.cmd([[write]]) end)

      -- Close a buffer with <C-c>.
      vim.keymap.set("n", "<C-c>", delete)

      -- Quit Neovim with <C-q>.
      vim.keymap.set("n", "<C-q>", function () vim.cmd([[qall]]) end)
    '';
  };
}
