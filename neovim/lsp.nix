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
        name = "efmls-configs-nvim";
        src = inputs.efmls-configs-nvim;
      })
      (pkgs'.vimUtils.buildVimPlugin {
        name = "trouble-nvim";
        src = inputs.trouble-nvim;
      })
    ];

    extraPackages = with pkgs'; with nodePackages; [
      # Bash/Sh:
      bash-language-server
      beautysh
      shellcheck

      # C/C++:
      ccls

      # Docker:
      dockerfile-language-server-nodejs

      # Go:
      gopls
      go

      # Java:
      jdt-language-server
      google-java-format

      # JSON:
      jq

      # Lua:
      sumneko-lua-language-server

      # Nix:
      nixfmt-rfc-style
      statix

      # PHP:
      intelephense

      # Python:
      pyright
      black
      isort
      pylint

      # Rust:
      cargo
      rust-analyzer
      rustc

      # YAML:
      yaml-language-server
      actionlint
      yq

      # General purpose:
      efm-langserver
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

      lspconfig.dockerls.setup({
        capabilities = capabilities,
      })

      lspconfig.efm.setup({
        init_options = {
          codeAction = true,
          completion = true,
          documentFormatting = true,
          documentRangeFormatting = true,
          documentSymbol = true,
          hover = true,
        },
        settings = {
          rootMarkers = {
            ".git/",
          },
          -- See the following page for ideas:
          -- https://github.com/creativenull/efmls-configs-nvim/blob/main/doc/SUPPORTED_LIST.md
          languages = {
            java = {
              {
                formatCommand = require("efmls-configs.fs").executable("google-java-format")
                  .. " $(echo -n ''${--useless:rowStart} ''${--useless:rowEnd}"
                  .. " | xargs -n4 -r sh -c 'echo"
                  .. " --skip-sorting-imports"
                  .. " --skip-removing-unused-imports"
                  .. " --skip-reflowing-long-strings"
                  .. " --skip-javadoc-formatting"
                  .. " --lines $(($1+1)):$(($3+1))'"
                  .. ") -",
                formatStdin = true,
                rootMarkers = { ".project", "classpath", "pom.xml" },
              },
            },
            json = {
              require("efmls-configs.formatters.jq"),
              require("efmls-configs.linters.jq"),
            },
            nix = {
              require("efmls-configs.formatters.nixfmt"),
              require("efmls-configs.linters.statix"),
            },
            python = {
              require("efmls-configs.formatters.black"),
              require("efmls-configs.formatters.isort"),
              require("efmls-configs.linters.pylint"),
            },
            sh = {
              require("efmls-configs.formatters.beautysh"),
              require("efmls-configs.linters.shellcheck"),
            },
            yaml = {
              require("efmls-configs.formatters.yq"),
              require("efmls-configs.linters.actionlint"),
            },
          }
        },
      })

      lspconfig.gopls.setup({
        capabilities = capabilities,
        cmd_env = {
          GOPATH = vim.env.HOME .. "/.cache/gopls",
        },
      })

      lspconfig.intelephense.setup({
        capabilities = capabilities,
        init_options = {
          globalStoragePath = vim.env.HOME .. "/.cache/intelephense",
        },
      })

      lspconfig.jdtls.setup({
        capabilities = capabilities,
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

      lspconfig.rust_analyzer.setup({
        capabilities = capabilities,
      })

      lspconfig.yamlls.setup({
        capabilities = capabilities,
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
        lua = ''require("trouble").open()'';
      }
    ];
  };
}
