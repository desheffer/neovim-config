{
  description = "Doug's Neovim Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";

    flake-utils.url = "github:numtide/flake-utils";

    FTerm-nvim = { url = "github:numToStr/FTerm.nvim"; flake = false; };
    alpha-nvim = { url = "github:goolord/alpha-nvim"; flake = false; };
    auto-session = { url = "github:rmagatti/auto-session"; flake = false; };
    bufferline-nvim = { url = "github:akinsho/bufferline.nvim"; flake = false; };
    cmp-buffer = { url = "github:hrsh7th/cmp-buffer"; flake = false; };
    cmp-nvim-lsp = { url = "github:hrsh7th/cmp-nvim-lsp"; flake = false; };
    cmp_luasnip = { url = "github:saadparwaiz1/cmp_luasnip"; flake = false; };
    comment-nvim = { url = "github:numToStr/Comment.nvim"; flake = false; };
    friendly-snippets = { url = "github:rafamadriz/friendly-snippets"; flake = false; };
    gitsigns-nvim = { url = "github:lewis6991/gitsigns.nvim"; flake = false; };
    gruvbox-material = { url = "github:sainnhe/gruvbox-material"; flake = false; };
    hop-nvim = { url = "github:phaazon/hop.nvim"; flake = false; };
    indent-blankline-nvim = { url = "github:lukas-reineke/indent-blankline.nvim"; flake = false; };
    lsp_signature-nvim = { url = "github:ray-x/lsp_signature.nvim"; flake = false; };
    lualine-nvim = { url = "github:nvim-lualine/lualine.nvim"; flake = false; };
    luasnip = { url = "github:L3MON4D3/LuaSnip"; flake = false; };
    neoscroll-nvim = { url = "github:karb94/neoscroll.nvim"; flake = false; };
    noice-nvim = { url = "github:folke/noice.nvim"; flake = false; };
    nui-nvim = { url = "github:MunifTanjim/nui.nvim"; flake = false; };
    nvim-autopairs = { url = "github:windwp/nvim-autopairs"; flake = false; };
    nvim-cmp = { url = "github:hrsh7th/nvim-cmp"; flake = false; };
    nvim-hlslens = { url = "github:kevinhwang91/nvim-hlslens"; flake = false; };
    nvim-lspconfig = { url = "github:neovim/nvim-lspconfig"; flake = false; };
    nvim-notify = { url = "github:rcarriga/nvim-notify"; flake = false; };
    nvim-tree-lua = { url = "github:nvim-tree/nvim-tree.lua"; flake = false; };
    nvim-treesitter = { url = "github:nvim-treesitter/nvim-treesitter"; flake = false; };
    nvim-treesitter-context = { url = "github:nvim-treesitter/nvim-treesitter-context"; flake = false; };
    nvim-web-devicons = { url = "github:nvim-tree/nvim-web-devicons"; flake = false; };
    plenary-nvim = { url = "github:nvim-lua/plenary.nvim"; flake = false; };
    registers-nvim = { url = "github:tversteeg/registers.nvim"; flake = false; };
    telescope-nvim = { url = "github:nvim-telescope/telescope.nvim"; flake = false; };
    telescope-ui-select-nvim = { url = "github:nvim-telescope/telescope-ui-select.nvim"; flake = false; };
    vim-argumentative = { url = "github:PeterRincker/vim-argumentative"; flake = false; };
    vim-asterisk = { url = "github:haya14busa/vim-asterisk"; flake = false; };
    vim-easy-align = { url = "github:junegunn/vim-easy-align"; flake = false; };
    vim-repeat = { url = "github:tpope/vim-repeat"; flake = false; };
    vim-signature = { url = "github:kshenoy/vim-signature"; flake = false; };
    vim-surround = { url = "github:tpope/vim-surround"; flake = false; };
    vim-tmux-navigator = { url = "github:christoomey/vim-tmux-navigator"; flake = false; };
    vim-unimpaired = { url = "github:tpope/vim-unimpaired"; flake = false; };
  };

  outputs = inputs@{ ... }:
    {
      # Packages provided by `nix run`:
      packages = import ./neovim/configurations inputs;

      # Formatter provided by `nix fmt`:
      formatter = import ./formatter inputs;
    };
}
