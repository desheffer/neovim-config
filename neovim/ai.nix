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

  cfg = config.programs.neovim-config.ai;

in
{
  options.programs.neovim-config.ai = { };

  config.programs.neovim-config = {
    extraPackages = with pkgs'; [ nodejs ];

    plugins = [
      (pkgs'.vimUtils.buildVimPlugin {
        name = "copilot-lua";
        src = inputs.copilot-lua;
        doCheck = false;
      })
      (pkgs'.vimUtils.buildVimPlugin {
        name = "CopilotChat-nvim";
        src = inputs.CopilotChat-nvim;
        doCheck = false;
      })
    ];

    config = ''
      require("CopilotChat").setup({})
    '';

    mappings = [
      {
        lhs = "<Leader>cc";
        name = "+copilot";
      }
      {
        lhs = "<Leader>cc";
        name = "+copilot";
        mode = "v";
      }
      {
        lhs = "<Leader>ccc";
        name = "Copilot chat";
        lua = ''vim.cmd([[CopilotChat]])'';
      }
      {
        lhs = "<Leader>ccc";
        name = "Copilot chat";
        lua = ''vim.cmd([[CopilotChat]])'';
        mode = "v";
      }
      {
        lhs = "<Leader>ccd";
        name = "Copilot docs";
        lua = ''vim.cmd([[CopilotChatDocs]])'';
      }
      {
        lhs = "<Leader>ccd";
        name = "Copilot docs";
        lua = ''vim.cmd([[CopilotChatDocs]])'';
        mode = "v";
      }
      {
        lhs = "<Leader>cce";
        name = "Copilot explain";
        lua = ''vim.cmd([[CopilotChatExplain]])'';
      }
      {
        lhs = "<Leader>cce";
        name = "Copilot explain";
        lua = ''vim.cmd([[CopilotChatExplain]])'';
        mode = "v";
      }
      {
        lhs = "<Leader>ccf";
        name = "Copilot fix";
        lua = ''vim.cmd([[CopilotChatFix]])'';
      }
      {
        lhs = "<Leader>ccf";
        name = "Copilot fix";
        lua = ''vim.cmd([[CopilotChatFix]])'';
        mode = "v";
      }
      {
        lhs = "<Leader>cco";
        name = "Copilot optimize";
        lua = ''vim.cmd([[CopilotChatOptimize]])'';
      }
      {
        lhs = "<Leader>cco";
        name = "Copilot optimize";
        lua = ''vim.cmd([[CopilotChatOptimize]])'';
        mode = "v";
      }
      {
        lhs = "<Leader>ccr";
        name = "Copilot review";
        lua = ''vim.cmd([[CopilotChatReview]])'';
      }
      {
        lhs = "<Leader>ccr";
        name = "Copilot review";
        lua = ''vim.cmd([[CopilotChatReview]])'';
        mode = "v";
      }
    ];
  };
}
