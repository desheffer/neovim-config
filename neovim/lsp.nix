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
        name = "conform-nvim";
        src = inputs.conform-nvim;
        doCheck = false;
      })
      (pkgs'.vimUtils.buildVimPlugin {
        name = "nvim-lint";
        src = inputs.nvim-lint;
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
      yq-go
    ];

    config = ''
      vim.lsp.config("ccls", {
        init_options = {
          cache = {
            directory = vim.env.HOME .. "/.cache/ccls",
          },
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
        "gopls",
        "intelephense",
        "jdtls",
        "lua_ls",
        "pyright",
        "rust_analyzer",
        "yamlls",
      })

      require("conform").setup({
        formatters = {
          ["google-java-format"] = {
            range_args = function(_, ctx)
              return {
                "--skip-sorting-imports",
                "--skip-removing-unused-imports",
                "--skip-reflowing-long-strings",
                "--skip-javadoc-formatting",
                "--lines",
                ctx.range.start[1] .. ":" .. ctx.range["end"][1],
                "-",
              }
            end,
          },
        },
        formatters_by_ft = {
          java = {"google-java-format"},
          json = {"jq"},
          nix = {"nixfmt"},
          python = {"black", "isort"},
          sh = {"beautysh"},
          yaml = {"yq"},
        },
      })

      require("lint").linters_by_ft = {
        json = {"jq"},
        nix = {"statix"},
        python = {"pylint"},
        sh = {"shellcheck"},
        yaml = {"actionlint"},
      }

      vim.api.nvim_create_autocmd({"BufEnter", "BufWritePost", "InsertLeave"}, {
        callback = function ()
          require("lint").try_lint()
        end,
      })

      vim.diagnostic.config({
        jump = {
          on_jump = function (_, bufnr)
            vim.diagnostic.open_float({bufnr = bufnr, scope = "cursor", focus = false})
          end,
        },
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
        lua = ''require("conform").format({async = true, lsp_format = "fallback"})'';
      }
      {
        lhs = "<Leader>cf";
        name = "Code format";
        lua = ''require("conform").format({async = true, lsp_format = "fallback"})'';
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
        lua = ''vim.diagnostic.jump({count = 1})'';
      }
      {
        lhs = "[d";
        name = "Previous diagnostic";
        lua = ''vim.diagnostic.jump({count = -1})'';
      }
      {
        lhs = "<Leader>cd";
        name = "Diagnostics";
        lua = ''require("trouble").open("diagnostics")'';
      }
    ];
  };
}
