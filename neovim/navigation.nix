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

  cfg = config.programs.neovim-config.navigation;

in
{
  options.programs.neovim-config.navigation = { };

  config.programs.neovim-config = {
    plugins = [
      (pkgs'.vimUtils.buildVimPlugin {
        name = "hop-nvim";
        src = inputs.hop-nvim;
        doCheck = false;
      })
      (pkgs'.vimUtils.buildVimPlugin {
        name = "nvim-hlslens";
        src = inputs.nvim-hlslens;
        doCheck = false;
      })
      (pkgs'.vimUtils.buildVimPlugin {
        name = "vim-asterisk";
        src = inputs.vim-asterisk;
        doCheck = false;
      })
      (pkgs'.vimUtils.buildVimPlugin {
        name = "vim-signature";
        src = inputs.vim-signature;
        doCheck = false;
      })
    ];

    config = ''
      require("hop").setup({
        keys = "arsdheioqwfpgjluyzxcvbkmtn",
      })

      require("hlslens").setup()

      -- Keep cursor position while moving across search matches.
      vim.g["asterisk#keeppos"] = 1

      -- Override j/k and <Down>/<Up> to navigate wrapped lines.
      vim.keymap.set("n", "j",       [[gj]])
      vim.keymap.set("n", "k",       [[gk]])
      vim.keymap.set("n", "gj",      [[j]])
      vim.keymap.set("n", "gk",      [[k]])
      vim.keymap.set("n", "<Down>",  [[gj]])
      vim.keymap.set("n", "<Up>",    [[gk]])
      vim.keymap.set("n", "g<Down>", [[j]])
      vim.keymap.set("n", "g<Up>",   [[k]])

      -- Override C-d/C-u to also center vertically.
      vim.keymap.set("n", "<C-d>", [[<C-d>zz]])
      vim.keymap.set("n", "<C-u>", [[<C-u>zz]])

      -- Override C-e/C-y to scroll multiple lines.
      vim.keymap.set("n", "<C-e>", [[5<C-e>]])
      vim.keymap.set("n", "<C-y>", [[5<C-y>]])

      -- Override search navigation.
      vim.keymap.set("",  "*",  [[<Plug>(asterisk-z*)<Cmd>lua require("hlslens").start()<CR>]])
      vim.keymap.set("",  "#",  [[<Plug>(asterisk-z#)<Cmd>lua require("hlslens").start()<CR>]])
      vim.keymap.set("",  "g*", [[<Plug>(asterisk-zg*)<Cmd>lua require("hlslens").start()<CR>]])
      vim.keymap.set("",  "g#", [[<Plug>(asterisk-zg#)<Cmd>lua require("hlslens").start()<CR>]])
      vim.keymap.set("n", "n",  [[<Cmd>execute("normal! " . v:count1 . "n")<CR><Cmd>lua require("hlslens").start()<CR>]])
      vim.keymap.set("n", "N",  [[<Cmd>execute("normal! " . v:count1 . "N")<CR><Cmd>lua require("hlslens").start()<CR>]])
    '';

    mappings = [
      {
        lhs = "<Leader><Leader>";
        name = "Hop to character";
        lua = ''require("hop").hint_char1()'';
      }
      {
        lhs = "<Leader><Leader>";
        name = "Hop to character";
        lua = ''require("hop").hint_char1()'';
        mode = "v";
      }
      {
        lhs = "<Leader>/";
        name = "Hop to pattern";
        lua = ''require("hop").hint_patterns()'';
      }
      {
        lhs = "<Leader>/";
        name = "Hop to pattern";
        lua = ''require("hop").hint_patterns()'';
        mode = "v";
      }
      {
        lhs = "<C-l>";
        name = "Turn off search highlighting";
        rhs = '':nohlsearch<CR>'';
      }
    ];
  };
}
