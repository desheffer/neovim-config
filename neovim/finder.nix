inputs:

{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  lib' = import ../lib inputs;
  pkgs' = lib'.mkPkgs pkgs.system;

  cfg = config.programs.neovim-config.finder;

in
{
  options.programs.neovim-config.finder = { };

  config.programs.neovim-config = {
    plugins = [
      (pkgs'.vimUtils.buildVimPlugin {
        name = "plenary-nvim";
        src = inputs.plenary-nvim;
        doCheck = false;
      })
      (pkgs'.vimUtils.buildVimPlugin {
        name = "telescope-nvim";
        src = inputs.telescope-nvim;
        doCheck = false;
      })
      (pkgs'.vimUtils.buildVimPlugin {
        name = "telescope-ui-select-nvim";
        src = inputs.telescope-ui-select-nvim;
        doCheck = false;
      })
    ];

    extraPackages = with pkgs'; [
      fd
      ripgrep
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
    '';

    mappings = [
      {
        lhs = "<C-p>";
        name = "Smart fuzzy finder";
        lua = ''
          vim.fn.system("git rev-parse --is-inside-work-tree")

          if vim.v.shell_error == 0 then
            require("telescope.builtin").git_files()
          else
            require("telescope.builtin").find_files()
          end
        '';
      }
      {
        lhs = "<Leader>f";
        name = "+finder";
      }
      {
        lhs = "<Leader>fa";
        name = "Find all files";
        lua = ''require("telescope.builtin").find_files({hidden = true})'';
      }
      {
        lhs = "<Leader>fb";
        name = "Find buffers";
        lua = ''require("telescope.builtin").buffers()'';
      }
      {
        lhs = "<Leader>ff";
        name = "Find files";
        lua = ''require("telescope.builtin").find_files()'';
      }
      {
        lhs = "<Leader>fg";
        name = "Live grep";
        lua = ''require("telescope.builtin").live_grep()'';
      }
      {
        lhs = "<Leader>fh";
        name = "Find help";
        lua = ''require("telescope.builtin").help_tags()'';
      }
      {
        lhs = "<Leader>fo";
        name = "Find old files";
        lua = ''require("telescope.builtin").oldfiles()'';
      }
      {
        lhs = "<Leader>fr";
        name = "Resume last find";
        lua = ''require("telescope.builtin").resume()'';
      }
      {
        lhs = "<Leader>fw";
        name = "Find word";
        lua = ''require("telescope.builtin").grep_string()'';
      }
      {
        lhs = "<Leader>f";
        name = "+finder";
        mode = "v";
      }
      {
        lhs = "<Leader>fw";
        name = "Find word";
        lua = ''require("telescope.builtin").grep_string()'';
        mode = "v";
      }
      {
        lhs = "<Leader>g";
        name = "+git";
      }
      {
        lhs = "<Leader>gc";
        name = "Git commits";
        lua = ''require("telescope.builtin").git_bcommits()'';
      }
      {
        lhs = "<Leader>gf";
        name = "Git files";
        lua = ''require("telescope.builtin").git_files()'';
      }
      {
        lhs = "<Leader>gs";
        name = "Git status";
        lua = ''require("telescope.builtin").git_status()'';
      }
      {
        lhs = "z=";
        name = "Spell suggest word";
        lua = ''require("telescope.builtin").spell_suggest()'';
      }
    ];
  };
}
