{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.finder;

in
{
  options.modules.finder = { };

  config.modules.neovim = {
    plugins = with pkgs.vimPluginsFromInputs; [
      plenary-nvim
      telescope-nvim
      telescope-ui-select-nvim
    ];

    config = ''
      require("telescope").setup({
        defaults = {
          layout_config = {
            horizontal = {
              prompt_position = "top",
            },
          },
          path_display = {
            shorten = 1,
          },
          sorting_strategy = "ascending",
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
      })

      require("telescope").load_extension("ui-select")

      local find_files = function ()
          vim.fn.system("git rev-parse --is-inside-work-tree")

          if vim.v.shell_error == 0 then
            require("telescope.builtin").git_files()
          else
            require("telescope.builtin").find_files()
          end
      end

      -- Bind a smart fuzzy finder to <C-p>.
      vim.keymap.set("n", "<C-p>", find_files)

      -- Bind Telescope file commands.
      vim.keymap.set("n", "<Leader>fa", function () require("telescope.builtin").find_files({hidden = true}) end)
      vim.keymap.set("n", "<Leader>fb", function () require("telescope.builtin").buffers() end)
      vim.keymap.set("n", "<Leader>ff", function () require("telescope.builtin").find_files() end)
      vim.keymap.set("n", "<Leader>fg", function () require("telescope.builtin").live_grep() end)
      vim.keymap.set("n", "<Leader>fh", function () require("telescope.builtin").help_tags() end)
      vim.keymap.set("n", "<Leader>fo", function () require("telescope.builtin").oldfiles() end)
      vim.keymap.set("n", "<Leader>fr", function () require("telescope.builtin").resume() end)
      vim.keymap.set("n", "<Leader>fw", function () require("telescope.builtin").grep_string() end)
      vim.keymap.set("v", "<Leader>fw", function () require("telescope.builtin").grep_string() end)

      -- Bind Telescope Git commands.
      vim.keymap.set("n", "<Leader>gc", function () require("telescope.builtin").git_bcommits() end)
      vim.keymap.set("n", "<Leader>gf", function () require("telescope.builtin").git_files() end)
      vim.keymap.set("n", "<Leader>gs", function () require("telescope.builtin").git_status() end)

      -- Find spelling suggestions with z=.
      vim.keymap.set("n", "z=", function () require("telescope.builtin").spell_suggest() end)
    '';
  };
}
