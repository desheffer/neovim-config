inputs@{ ... }:

{ config, lib, pkgs, ... }:

with lib;

let
  lib' = import ../lib inputs;
  pkgs' = lib'.mkPkgs pkgs.system;

  cfg = config.programs.neovim-config.lsp;

in
{
  options.programs.neovim-config.lsp = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable language servers.";
      default = false;
    };
  };

  config.programs.neovim-config = mkIf cfg.enable {
    plugins = [
      (pkgs'.vimUtils.buildVimPluginFrom2Nix {
        name = "nvim-lspconfig";
        src = inputs.nvim-lspconfig;
      })
    ];

    extraPackages = with pkgs'; with nodePackages; [
      bash-language-server
      ccls
      dockerfile-language-server-nodejs
      gopls
      intelephense
      jdt-language-server
      pyright
      rnix-lsp
      sumneko-lua-language-server
      vscode-css-languageserver-bin
      vscode-html-languageserver-bin
      vscode-json-languageserver-bin
      yaml-language-server
    ];

    config = ''
      local lspconfig = require("lspconfig")

      local capabilities = require("cmp_nvim_lsp")
        .default_capabilities(vim.lsp.protocol.make_client_capabilities())

      lspconfig.bashls.setup({
        capabilities = capabilities,
      })

      lspconfig.ccls.setup({
        capabilities = capabilities,
        init_options = {
          cache = {
            directory = vim.env.HOME .. "/.cache/ccls",
          },
        },
      })

      lspconfig.cssls.setup({
        capabilities = capabilities,
        cmd = {"css-languageserver", "--stdio"},
      })

      lspconfig.dockerls.setup({
        capabilities = capabilities,
      })

      lspconfig.gopls.setup({
        capabilities = capabilities,
        cmd_env = {
          GOPATH = vim.env.HOME .. "/.cache/gopls",
        },
      })

      lspconfig.html.setup({
        capabilities = capabilities,
        cmd = {"html-languageserver", "--stdio"},
      })

      lspconfig.intelephense.setup({
        capabilities = capabilities,
        init_options = {
          globalStoragePath = vim.env.HOME .. "/.cache/intelephense",
        },
      })

      lspconfig.jdtls.setup({
        capabilities = capabilities,
        cmd = {
          "jdt-language-server",
          "-configuration", vim.env.HOME .. "/.cache/jdtls/config",
          "-data", vim.env.HOME .. "/.cache/jdtls/workspace",
        },
      })

      lspconfig.jsonls.setup({
        capabilities = capabilities,
        cmd = {"json-languageserver", "--stdio"},
      })

      lspconfig.pyright.setup({
        capabilities = capabilities,
      })

      lspconfig.rnix.setup({
        capabilities = capabilities,
      })

      lspconfig.sumneko_lua.setup({
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = {
              globals = {"vim"},
            },
          },
        },
      })

      lspconfig.yamlls.setup({
        capabilities = capabilities,
      })

      vim.fn.sign_define("DiagnosticSignError", {text = "", texthl = "DiagnosticSignError"})
      vim.fn.sign_define("DiagnosticSignWarn",  {text = "", texthl = "DiagnosticSignWarn"})
      vim.fn.sign_define("DiagnosticSignInfo",  {text = "", texthl = "DiagnosticSignInfo"})
      vim.fn.sign_define("DiagnosticSignHint",  {text = "", texthl = "DiagnosticSignHint"})

      -- Bind various LSP commands.
      vim.keymap.set("n", "gd", function () require("telescope.builtin").lsp_definitions({jump_type = "never"}) end)
      vim.keymap.set("n", "gD", function () vim.lsp.buf.declaration() end)
      vim.keymap.set("n", "gi", function () require("telescope.builtin").lsp_implementations({jump_type = "never"}) end)
      vim.keymap.set("n", "gr", function () require("telescope.builtin").lsp_references({jump_type = "never"}) end)
      vim.keymap.set("n", "K",  function () vim.lsp.buf.hover() end)
      vim.keymap.set("n", "<Leader>ca", function () vim.lsp.buf.code_action() end)
      vim.keymap.set("v", "<Leader>ca", function () vim.lsp.buf.code_action() end)
      vim.keymap.set("n", "<Leader>cf", function () vim.lsp.buf.format({async = true}) end)
      vim.keymap.set("v", "<Leader>cf", function () vim.lsp.buf.format({async = true}) end)
      vim.keymap.set("n", "<Leader>cr", function () vim.lsp.buf.rename() end)

      -- Bind various diagnostic commands.
      vim.keymap.set("n", "[d", function () vim.diagnostic.goto_prev({popup_opts = {focusable = false}}) end)
      vim.keymap.set("n", "]d", function () vim.diagnostic.goto_next({popup_opts = {focusable = false}}) end)
      vim.keymap.set("n", "<Leader>cd", function () require("telescope.builtin").diagnostics() end)
    '';
  };
}
