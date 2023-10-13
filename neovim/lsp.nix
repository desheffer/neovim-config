inputs:

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
      (pkgs'.vimUtils.buildVimPlugin {
        name = "nvim-lspconfig";
        src = inputs.nvim-lspconfig;
      })
      (pkgs'.vimUtils.buildVimPlugin {
        name = "null-ls-nvim";
        src = inputs.null-ls-nvim;
      })
    ];

    extraPackages = with pkgs'; with nodePackages; [
      # Bash:
      bash-language-server

      # C/C++:
      ccls

      # CSS:
      vscode-css-languageserver-bin

      # Docker:
      dockerfile-language-server-nodejs

      # Go:
      gopls

      # HTML:
      vscode-html-languageserver-bin

      # Java:
      jdt-language-server

      # JSON:
      vscode-json-languageserver-bin

      # Lua:
      sumneko-lua-language-server

      # Nix:
      rnix-lsp

      # PHP:
      intelephense

      # Python:
      pyright

      # Rust:
      cargo
      rust-analyzer
      rustc

      # YAML:
      yaml-language-server

      # Extras for null-ls:
      actionlint
      beautysh
      black
      isort
      jq
      nixpkgs-fmt
      pylint
      shellcheck
      statix
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

      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = {
              globals = {"vim"},
            },
          },
        },
      })

      lspconfig.pyright.setup({
        capabilities = capabilities,
      })

      lspconfig.rnix.setup({
        capabilities = capabilities,
      })

      lspconfig.rust_analyzer.setup({
        capabilities = capabilities,
      })

      lspconfig.yamlls.setup({
        capabilities = capabilities,
      })

      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          null_ls.builtins.code_actions.shellcheck,
          null_ls.builtins.code_actions.statix,
          null_ls.builtins.diagnostics.actionlint,
          null_ls.builtins.diagnostics.pylint,
          null_ls.builtins.diagnostics.statix,
          null_ls.builtins.formatting.beautysh,
          null_ls.builtins.formatting.black,
          null_ls.builtins.formatting.isort,
          null_ls.builtins.formatting.jq,
          null_ls.builtins.formatting.nixpkgs_fmt,
        }
      })

      vim.fn.sign_define("DiagnosticSignError", {text = "󰀩", texthl = "DiagnosticSignError"})
      vim.fn.sign_define("DiagnosticSignWarn",  {text = "󰀦", texthl = "DiagnosticSignWarn"})
      vim.fn.sign_define("DiagnosticSignInfo",  {text = "󰋼", texthl = "DiagnosticSignInfo"})
      vim.fn.sign_define("DiagnosticSignHint",  {text = "󰌵", texthl = "DiagnosticSignHint"})
    '';

    mappings = [
      {
        lhs = "gd";
        name = "Go to definition";
        lua = ''require("telescope.builtin").lsp_definitions({jump_type = "never"})'';
      }
      {
        lhs = "gD";
        name = "Go to declaration";
        lua = ''vim.lsp.buf.declaration()'';
      }
      {
        lhs = "gi";
        name = "Go to implementations";
        lua = ''require("telescope.builtin").lsp_implementations({jump_type = "never"})'';
      }
      {
        lhs = "gr";
        name = "Go to references";
        lua = ''require("telescope.builtin").lsp_references({jump_type = "never"})'';
      }
      {
        lhs = "K";
        name = "Hover";
        lua = ''vim.lsp.buf.hover()'';
      }
      {
        lhs = "<Leader>c";
        name = "+code";
      }
      {
        lhs = "<Leader>ca";
        name = "Code action";
        lua = ''vim.lsp.buf.code_action()'';
      }
      {
        lhs = "<Leader>ca";
        name = "Code action";
        lua = ''vim.lsp.buf.code_action()'';
        mode = "v";
      }
      {
        lhs = "<Leader>cf";
        name = "Code format";
        lua = ''vim.lsp.buf.format({async = true})'';
      }
      {
        lhs = "<Leader>cf";
        name = "Code format";
        lua = ''vim.lsp.buf.format({async = true})'';
        mode = "v";
      }
      {
        lhs = "<Leader>cr";
        name = "Rename";
        lua = ''vim.lsp.buf.rename()'';
      }
      {
        lhs = "]d";
        name = "Next diagnostic";
        lua = ''vim.diagnostic.goto_next({popup_opts = {focusable = false}})'';
      }
      {
        lhs = "[d";
        name = "Previous diagnostic";
        lua = ''vim.diagnostic.goto_prev({popup_opts = {focusable = false}})'';
      }
      {
        lhs = "<Leader>cd";
        name = "Diagnostics";
        lua = ''require("telescope.builtin").diagnostics()'';
      }
    ];
  };
}
