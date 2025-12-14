-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)


-- インストールするプラグインを定義します．
local plugins = {
  ------------------------------------------------------------------------------
  -- LSP 関係のプラグイン
  ------------------------------------------------------------------------------
  
  -- LSP を設定するプラグイン
  'neovim/nvim-lspconfig',
  
  -- LSP サーバー管理プラグイン
  'williamboman/mason.nvim',
  {
    'williamboman/mason-lspconfig.nvim',
    config = function()
      require("plugins.mason_config").setup()
    end
  },

  ------------------------------------------------------------------------------
  -- 補完 関係のプラグイン
  ------------------------------------------------------------------------------

  -- 補完エンジン プラグイン
  {
    "hrsh7th/nvim-cmp",
    config = function()
      require("plugins.nvim-cmp_config").setup()
    end
  },
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/vim-vsnip",

  ------------------------------------------------------------------------------
  -- ファジー ファインダー関係のプラグイン
  ------------------------------------------------------------------------------

  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
  },

  -- ファイラー プラグイン
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    config = function()
      require("plugins.telescope_config").setup()
    end
  },

  ------------------------------------------------------------------------------
  -- ファイラー プラグイン
  ------------------------------------------------------------------------------

  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("plugins.nvim-tree_config").setup()
    end
  },

  ------------------------------------------------------------------------------
  -- 編集関係のプラグイン
  ------------------------------------------------------------------------------
  
  -- 編集モードと挿入モードで IME を切り替えるプラグイン
  "pepo-le/win-ime-con.nvim",

  -- 対になる括弧などを自動で閉じるプラグイン
  {
    "windwp/nvim-autopairs",
     config = function()
       require("nvim-autopairs").setup {}
     end
  },

  ------------------------------------------------------------------------------
  -- 画面表示に関するプラグイン
  ------------------------------------------------------------------------------

  -- ステータス ラインをカスタマイズするプラグイン
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "kyazdani42/nvim-web-devicons", opt = true },
    config = function()
      require("plugins.lualine_config").setup()
    end
  },

  -- カラー スキーム iceberg
  "cocopon/iceberg.vim",

  -- インデントのわかりやすい可視化プラグイン
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("plugins.indent_blankline_config").setup()
    end
  },
}


local opts = {
}

-- Setup lazy.nvim
require("lazy").setup(plugins, opts)
