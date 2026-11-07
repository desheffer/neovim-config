inputs:

{
  config,
  lib,
  pkgs',
  ...
}:

let
  cfg = config.programs.neovim-config.lsp;

in
{
  options.programs.neovim-config.lsp = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to enable language servers.";
      default = false;
    };
  };

  config.programs.neovim-config = lib.mkIf cfg.enable {
    plugins = [
      (pkgs'.vimUtils.buildVimPlugin {
        name = "nvim-lspconfig";
        src = inputs.nvim-lspconfig;
        doCheck = false;
      })
      (pkgs'.vimUtils.buildVimPlugin {
        name = "efmls-configs-nvim";
        src = inputs.efmls-configs-nvim;
        doCheck = false;
      })
      (pkgs'.vimUtils.buildVimPlugin {
        name = "trouble-nvim";
        src = inputs.trouble-nvim;
        doCheck = false;
      })
    ];

    extraPackages = with pkgs'; [
      # Bash/Sh:
      bash-language-server
      beautysh
      shellcheck

      # C/C++:
      ccls

      # Docker:
      dockerfile-language-server

      # Go:
      gopls
      go

      # Java:
      jdt-language-server
      google-java-format

      # JSON:
      jq

      # Lua:
      lua-language-server

      # Nix:
      nixfmt
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
      vim.lsp.config("*", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      })

      vim.lsp.config("ccls", {
        init_options = {
          cache = {
            directory = vim.env.HOME .. "/.cache/ccls",
          },
        },
      })

      vim.lsp.config("efm", {
        filetypes = {"java", "json", "nix", "python", "sh", "yaml"},
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

      vim.lsp.config("gopls", {
        cmd_env = {
          GOPATH = vim.env.HOME .. "/.cache/gopls",
        },
      })

      vim.lsp.config("intelephense", {
        init_options = {
          globalStoragePath = vim.env.HOME .. "/.cache/intelephense",
        },
      })

      vim.lsp.config("jdtls", {
        handlers = {
          ["language/status"] = function(_, _) end,
          ["$/progress"] = function() end,
        },
      })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = {
              globals = {"vim"},
            },
          },
        },
      })

      vim.lsp.enable({
        "bashls",
        "ccls",
        "dockerls",
        "efm",
        "gopls",
        "intelephense",
        "jdtls",
        "lua_ls",
        "pyright",
        "rust_analyzer",
        "yamlls",
      })

      vim.diagnostic.config({
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "󰀩",
            [vim.diagnostic.severity.WARN] = "󰀦",
            [vim.diagnostic.severity.INFO] = "󰋼",
            [vim.diagnostic.severity.HINT] = "󰌵",
          },
          texthl = {
            [vim.diagnostic.severity.ERROR] = "Error",
            [vim.diagnostic.severity.WARN] = "Warn",
            [vim.diagnostic.severity.INFO] = "Info",
            [vim.diagnostic.severity.HINT] = "Hint",
          },
          numhl = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.HINT] = "",
          },
        },
      })
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
        lhs = "<Leader>c";
        name = "+code";
        mode = "v";
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
        lua = ''require("trouble").open("diagnostics")'';
      }
    ];
  };
}
