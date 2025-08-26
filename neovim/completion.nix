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

  cfg = config.programs.neovim-config.completion;

in
{
  options.programs.neovim-config.completion = { };

  config.programs.neovim-config = {
    plugins = [
      (pkgs'.vimUtils.buildVimPlugin {
        name = "cmp-buffer";
        src = inputs.cmp-buffer;
        doCheck = false;
      })
      (pkgs'.vimUtils.buildVimPlugin {
        name = "cmp-nvim-lsp";
        src = inputs.cmp-nvim-lsp;
        doCheck = false;
      })
      (pkgs'.vimUtils.buildVimPlugin {
        name = "cmp_luasnip";
        src = inputs.cmp_luasnip;
        doCheck = false;
      })
      (pkgs'.vimUtils.buildVimPlugin {
        name = "friendly-snippets";
        src = inputs.friendly-snippets;
        doCheck = false;
      })
      (pkgs'.vimUtils.buildVimPlugin {
        name = "luasnip";
        src = inputs.luasnip;
        doCheck = false;
      })
      (pkgs'.vimUtils.buildVimPlugin {
        name = "nvim-cmp";
        src = inputs.nvim-cmp;
        doCheck = false;
      })
    ];

    config = ''
      require("luasnip.loaders.from_vscode").load()

      vim.opt.completeopt = "menu,menuone,noselect"

      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), {"i", "c"}),
          ["<CR>"] = cmp.mapping.confirm(),
          ["<C-e>"] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
          }),
          ["<C-d>"] = cmp.mapping.scroll_docs(4, {"i", "c"}),
          ["<C-u>"] = cmp.mapping.scroll_docs(-4, {"i", "c"}),
          ["<Tab>"] = cmp.mapping(function (fallback)
            if luasnip.jumpable(1) then
              luasnip.jump(1)
            elseif cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, {"i", "s"}),
          ["<S-Tab>"] = cmp.mapping(function (fallback)
            if luasnip.jumpable(-1) then
              luasnip.jump(-1)
            elseif cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, {"i", "s"}),
        }),
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        sources = {
          {name = "nvim_lsp"},
          {name = "luasnip"},
          {name = "buffer"},
        },
        window = {
          documentation = {
            border = {"╭", "─", "╮", "│", "╯", "─", "╰", "│"},
            winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
          },
        },
      })
    '';
  };
}
