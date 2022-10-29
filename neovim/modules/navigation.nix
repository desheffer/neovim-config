{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.navigation;

in
{
  options.modules.navigation = { };

  config.modules.neovim = {
    plugins = with pkgs.vimPluginsFromInputs; [
      hop-nvim
      nvim-hlslens
      vim-asterisk
      vim-signature
    ];

    config = ''
      require("hop").setup({
        keys = "arsdheioqwfpgjluyzxcvbkmtn",
      })

      require("hlslens").setup()

      -- Keep cursor position while moving across search matches.
      vim.g["asterisk#keeppos"] = 1

      -- Allow j/k and <Down>/<Up> to navigate wrapped lines.
      vim.keymap.set("n", "j",       [[gj]])
      vim.keymap.set("n", "k",       [[gk]])
      vim.keymap.set("n", "gj",      [[j]])
      vim.keymap.set("n", "gk",      [[k]])
      vim.keymap.set("n", "<Down>",  [[gj]])
      vim.keymap.set("n", "<Up>",    [[gk]])
      vim.keymap.set("n", "g<Down>", [[j]])
      vim.keymap.set("n", "g<Up>",   [[k]])

      -- Turn off search highlighting with <C-l>.
      -- This syntax is designed to be compatibility with hlslens.
      vim.keymap.set("n", "<C-l>", [[:nohlsearch<CR>]], {silent = true})

      -- Add more details when highlighting search matches.
      vim.keymap.set("",  "*",  [[<Plug>(asterisk-z*)<Cmd>lua require("hlslens").start()<CR>]])
      vim.keymap.set("",  "#",  [[<Plug>(asterisk-z#)<Cmd>lua require("hlslens").start()<CR>]])
      vim.keymap.set("",  "g*", [[<Plug>(asterisk-zg*)<Cmd>lua require("hlslens").start()<CR>]])
      vim.keymap.set("",  "g#", [[<Plug>(asterisk-zg#)<Cmd>lua require("hlslens").start()<CR>]])
      vim.keymap.set("n", "n",  [[<Cmd>execute("normal! " . v:count1 . "n")<CR><Cmd>lua require("hlslens").start()<CR>]])
      vim.keymap.set("n", "N",  [[<Cmd>execute("normal! " . v:count1 . "N")<CR><Cmd>lua require("hlslens").start()<CR>]])

      -- Hop to a character with <Leader><Leader>{char}.
      vim.keymap.set("", "<Leader><Leader>", function () require("hop").hint_char1() end)
    '';
  };
}
