--------------------------------------------------------------------------------
-- キー設定
--------------------------------------------------------------------------------

-- leader キーをスペースに設定します．
vim.g.mapleader = " "
vim.g.maplocalleader = " "

--------------------------------------------------------------------------------
-- プラグイン設定
--------------------------------------------------------------------------------

-- プラグインを読み込みます．
require "config.lazy"

--------------------------------------------------------------------------------
-- 編集に関する設定
--------------------------------------------------------------------------------
-- コメント行のインデントを有効にします．
vim.opt.formatoptions:append("c")

--------------------------------------------------------------------------------
-- ファイル別設定
--------------------------------------------------------------------------------

-- Fortran は常に自由形式で書くようにします
vim.g.fortran_free_source = 1

vim.g.tex_fast = "bms"
vim.g.tex_conceal = ""

--------------------------------------------------------------------------------
-- LSP に関する設定
--------------------------------------------------------------------------------

-- LSP ハンドラーの設定
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, { virtual_text = false }
)

-- レファレンス ハイライトの設定 (カーソル下の変数のハイライト)
-- vim.cmd [[
-- set updatetime=500
-- highlight LspReferenceText  cterm=underline ctermfg=1 ctermbg=8 gui=underline guifg=#A00000 guibg=#104040
-- highlight LspReferenceRead  cterm=underline ctermfg=1 ctermbg=8 gui=underline guifg=#A00000 guibg=#104040
-- highlight LspReferenceWrite cterm=underline ctermfg=1 ctermbg=8 gui=underline guifg=#A00000 guibg=#104040
-- augroup lsp_document_highlight
--   autocmd!
--   autocmd CursorHold,CursorHoldI * lua vim.lsp.buf.document_highlight()
--   autocmd CursorMoved,CursorMovedI * lua vim.lsp.buf.clear_references()
-- augroup END
-- ]]

-- fortls の設定
vim.lsp.enable("fortls")

-- pyright の設定
vim.lsp.enable("pyright")

-- r_language_server の設定
vim.lsp.enable("r_language_server")

-- typescript_language_server の設定
vim.lsp.enable("typescript-language-server")

--------------------------------------------------------------------------------
-- 独自コマンドの設定
--------------------------------------------------------------------------------

-- Ripgrep コマンドを定義します。
require("config.ripgrep_config").setup()

--------------------------------------------------------------------------------
-- キー マップ設定
--------------------------------------------------------------------------------

-- LSP キー マップ
vim.keymap.set('n', 'K',  '<cmd>lua vim.lsp.buf.hover()<CR>')
vim.keymap.set('n', 'gf', '<cmd>lua vim.lsp.buf.formatting()<CR>')
vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
-- Telescope で参照を一覧します。
vim.keymap.set("n", "gR", function()
    require("telescope.builtin").lsp_references()
end)

vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
-- vim.keymap.set('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
vim.keymap.set('n', 'gn', '<cmd>lua vim.lsp.buf.rename()<CR>')
vim.keymap.set('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<CR>')
vim.keymap.set('n', 'ge', '<cmd>lua vim.diagnostic.open_float()<CR>')
vim.keymap.set('n', 'g]', '<cmd>lua vim.diagnostic.goto_next()<CR>')
vim.keymap.set('n', 'g[', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
vim.keymap.set('n', 'gl', '<cmd>lua vim.diagnostic.setloclist()<CR>')

-- 行頭に移動します。
vim.keymap.set("n", "<Space>h", "g^")
-- 行末に移動します。
vim.keymap.set("n", "<Space>l", "g$")

-- タブを移動します。
vim.keymap.set("n", "<C-n>", "gT")
vim.keymap.set("n", "<C-p>", "gt")

-- ウィンドウを移動します。
vim.keymap.set("n", "<F10>", "<C-w>w")
vim.keymap.set("n", "<Tab>", "<C-w>w ")

-- ウィンドウを閉じます。
vim.keymap.set("n", "<S-F10>", ":clo<CR>")

-- 現在開いているファイルのディレクトリに移動します。
vim.keymap.set("n", "<F7>", ":cd %:h<CR>")

-- 現在開いているファイルのディレクトリを Windows エクスプローラーで開きます。
vim.keymap.set("n", "<S-F7>", ":silent ! start %:h<CR>")

-- 検索結果のハイライトを表示します。
vim.keymap.set("n", "<F3>", ":set hlsearch<CR>")

-- 検索結果のハイライトを非表示にします。
vim.keymap.set("n", "<S-F3>", ":set nohlsearch<CR>")

-- gfortran で現在開いているファイルをコンパイルします。
vim.keymap.set("n", "<F4>", ":w<CR>:cd %:h<CR>:!gfortran % -o %:r<CR>")

-- "<現在開いているファイル名>.exe" を実行します。
vim.keymap.set("n", "<S-F4>", ":cd %:h<CR>:!start cmd /K %:r.exe&timeout -1&exit + {enter}<CR>")

-- NvimTree を開閉します。
vim.keymap.set("n", "<F12>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })

--------------------------------------------------------------------------------
-- ファイル読み込み設定
--------------------------------------------------------------------------------

-- UTF-8 で開けなかった場合は SJIS で開き直します。
-- ファイルを開くときにエンコーディングをチェックする関数です。
local function check_encoding()
  -- 現在のバッファのエンコーディングを取得します。
  local encoding = vim.bo.fileencoding

  -- バッファにファイル名がない場合は何もしない
  if vim.api.nvim_buf_get_name(0) == "" then
    return
  end
  
  -- UTF-8 でない場合、Shift_JIS で開き直します。
  if encoding ~= "utf-8" then
    vim.cmd("e ++enc=cp932")
  end
end

-- BufReadPost イベントでエンコーディングをチェックします。
-- この設定によって、ファイルが読み込まれた時に check_encoding が呼ばれます。
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*",
  callback = check_encoding,
  })

--------------------------------------------------------------------------------
-- 操作設定
--------------------------------------------------------------------------------

-- マウス操作を有効にします。
vim.opt.mouse = "a"

--------------------------------------------------------------------------------
-- 補完設定
--------------------------------------------------------------------------------

-- 補完ウィンドウを対象が 1 件のみの場合でも表示します。
-- https://note.com/yasukotelin/n/na87dc604e042
vim.opt.completeopt=menuone

--------------------------------------------------------------------------------
-- スワップ ファイル、バックアップ ファイル設定
--------------------------------------------------------------------------------

-- スワップ ファイルを生成しないようにします。
vim.opt.swapfile = false
-- バックアップ ファイルを生成しないようにします。
vim.opt.backup = false

--------------------------------------------------------------------------------
-- 画面表示設定
--------------------------------------------------------------------------------

-- 行番号を表示します。
vim.opt.number = true

-- タブを使わないようにします。
vim.opt.expandtab = true
-- タブと改行を可視化します。
vim.opt.list = true
vim.opt.listchars = {tab = ">-", eol = "↴"}
-- タブ幅を決定します。
vim.opt.tabstop = 4
-- キーボードでtabを打つとスペース4つ分になるようにします。
vim.opt.softtabstop = 4
-- インデント幅を決定します。
vim.opt.shiftwidth = 4

-- カーソルを点滅しないようにします。
--vim.opt.guicursor = a:blinkon0
-- カーソルの位置表示
vim.opt.ruler = true
-- カーソル行にラインを表示します。
vim.opt.cursorline = true
-- 行間隔を設定します。
vim.opt.linespace = 1

-- 長い行を省略せずに表示します。
vim.opt.display = lastline

-- 補完リストの高さを設定します。
vim.opt.pumheight = 10

-- カラー スキームを設定します。
vim.cmd[[colorscheme iceberg]]

-- フォントを指定します。
vim.opt.guifont = "Ricty Diminished:h14"

-- スペル チェックにおいてアジア圏の語はスペルチェックの対象外にします。
vim.opt.spelllang = {"c", "j", "k"}

-- 編集中のファイルを表示します。
vim.opt.title = true

-- 括弧入力時の対応する括弧を表示します。
vim.opt.showmatch = true

-- 不可視文字を可視化します。
vim.opt.list = true

-- オートインデントを設定します。
vim.opt.smartindent = true
vim.opt.autoindent = true

-- 一行あたりの文字数を制限しないようにします。
vim.opt.textwidth = 0

-- ウィンドウの端で折り返して表示しないようにします。
vim.opt.wrap = false

-- 横方向スクロールを一文字単位で行います。
vim.opt.sidescroll = 1

-- 折り返し時に単語単位で折り返さないようにします。
vim.opt.linebreak = false

-- 自動改行を禁止します。
vim.opt.formatoptions:append({m = true, M = true})

-- 改行時に自動的にコメントアウトがつくのを防ぎます。
vim.opt.formatoptions:remove("r")
vim.opt.formatoptions:remove("o")

-- ターミナルでも True Color を使えるようにします。
vim.opt.termguicolors = true

-- floating window の透過度を設定します。
vim.opt.winblend = 20

-- 補完に使われるポップアップ メニューの透過度を設定します。
vim.opt.pumblend = 20

-- ターミナルの透過を反映するための設定です。
vim.cmd "hi normal guibg=none"

--------------------------------------------------------------------------------
-- CopilotChat キーマッピング
--------------------------------------------------------------------------------

-- チャットウィンドウのトグル
vim.keymap.set('n', '<leader>cc', ':CopilotChatToggle<CR>', { desc = "CopilotChat: チャットトグル" })
vim.keymap.set('n', '<leader>cq', ':CopilotChat ', { desc = "CopilotChat: クイック質問" })

-- ビジュアルモード選択でのアクション
vim.keymap.set('v', '<leader>ce', ':CopilotChatExplain<CR>', { desc = "CopilotChat: コードの説明" })
vim.keymap.set('v', '<leader>cr', ':CopilotChatReview<CR>', { desc = "CopilotChat: コードレビュー" })
vim.keymap.set('v', '<leader>cf', ':CopilotChatFix<CR>', { desc = "CopilotChat: コード修正" })
vim.keymap.set('v', '<leader>co', ':CopilotChatOptimize<CR>', { desc = "CopilotChat: 最適化" })
vim.keymap.set('v', '<leader>cd', ':CopilotChatDocs<CR>', { desc = "CopilotChat: ドキュメント生成" })
vim.keymap.set('v', '<leader>ct', ':CopilotChatTests<CR>', { desc = "CopilotChat: テスト生成" })

-- ノーマルモードでのアクション
vim.keymap.set('n', '<leader>cD', ':CopilotChatFixDiagnostic<CR>', { desc = "CopilotChat: 診断修正" })
vim.keymap.set('n', '<leader>cco', ':CopilotChatCommit<CR>', { desc = "CopilotChat: コミットメッセージ" })
vim.keymap.set('n', '<leader>cs', ':CopilotChatCommitStaged<CR>', { desc = "CopilotChat: ステージ済みコミット" })

-- バッファ全体を対象にした質問
vim.keymap.set('n', '<leader>cb', ':CopilotChatBuffer ', { desc = "CopilotChat: バッファについて質問" })

-- インラインチャット（ビジュアル選択でプロンプト入力）
vim.keymap.set('v', '<leader>ci', function()
  local input = vim.fn.input("CopilotChat: ")
  if input ~= "" then
    vim.cmd("'<,'>CopilotChat " .. input)
  end
end, { desc = "CopilotChat: 選択範囲を編集" })

-- 選択範囲に対して直接質問
vim.keymap.set('v', '<leader>cq', ':CopilotChat ', { desc = "CopilotChat: 選択範囲について質問" })

-- 履歴管理
vim.keymap.set('n', '<leader>ch', ':CopilotChatLoad<CR>', { desc = "CopilotChat: 履歴を読み込む" })
vim.keymap.set('n', '<leader>cH', ':CopilotChatClearHistory<CR>', { desc = "CopilotChat: 現在の履歴をクリア" })

--------------------------------------------------------------------------------
-- CopilotChat モデル選択
--------------------------------------------------------------------------------

-- 利用可能なモデルリスト
local copilot_models = {
  "gpt-4o",
  "gpt-4o-mini",
  "gpt-4",
  "gpt-4-turbo",
  "gpt-3.5-turbo",
  "o1-mini",
  "o1-preview",
  "claude-3.5-sonnet",
}

-- モデルを選択するコマンド (補完付き)
vim.api.nvim_create_user_command('CopilotChatModel', function(opts)
  local model = opts.args
  if model == "" then
    print("現在のモデル: " .. (vim.g.copilot_chat_model or "gpt-4o"))
  else
    vim.g.copilot_chat_model = model
    require("CopilotChat").setup({ model = model })
    print("モデルを " .. model .. " に変更しました")
  end
end, {
  nargs = '?',
  complete = function()
    return copilot_models
  end,
  desc = "CopilotChat のモデルを変更"
})

-- モデル選択のキーマッピング
vim.keymap.set('n', '<leader>cm', ':CopilotChatModel ', { desc = "CopilotChat: モデル選択" })

--------------------------------------------------------------------------------
-- CopilotChat 履歴管理コマンド
--------------------------------------------------------------------------------

-- 履歴ディレクトリ内のすべてのファイルを削除するコマンド
vim.api.nvim_create_user_command('CopilotChatDeleteAllHistory', function()
  local history_path = vim.fn.expand("~/.local/share/nvim/copilot_chat_history")
  local choice = vim.fn.confirm("すべての CopilotCha 履歴を削除しますか？", "&Yes\n&No", 2)
  if choice == 1 then
    vim.fn.system("rm -rf " .. history_path .. "/*")
    print("すべての CopilotChat 履歴を削除しました")
  end
end, { desc = "すべての CopilotChat 履歴を削除" })

-- 履歴ディレクトリを開くコマンド
vim.api.nvim_create_user_command('CopilotChatOpenHistoryDir', function()
  local history_path = vim.fn.expand("~/.local/share/nvim/copilot_chat_history")
  vim.cmd("edit " .. history_path)
end, { desc = "CopilotChat 履歴ディレクトリを開く" })


--------------------------------------------------------------------------------
-- IME の切替
--------------------------------------------------------------------------------

-- 実行環境を判定する関数
local function detect_environment()
  local env = {}

  -- Linux
  env.is_linux = vim.fn.has("unix") == 1 and not vim.fn.has("wsl") == 1

  -- Windows
  env.is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1

  -- WSL
  env.is_wsl = vim.fn.has("wsl") == 1

  -- VSCode Neovim
  env.is_vscode = vim.g.vscode ~= nil

  return env
end

-- 実行環境を取得
local env = detect_environment()

-- モード変更時IME自動オフ
if env.is_linux then
  vim.api.nvim_set_keymap("i", "<silent> <Esc>", "<Esc>:call system('fcitx5-remote -c')<CR>", { noremap = true })
elseif env.is_vscode or env.is_wsl then
  vim.o.shell = "/usr/bin/bash --login"
  vim.cmd('autocmd InsertLeave * :call system("zenhan.exe 0")')
  vim.cmd('autocmd CmdlineLeave * :call system("zenhan.exe 0")')
elseif env.is_windows then
  vim.o.shell = "cmd.exe"
  vim.cmd("autocmd InsertLeave * :call system('zenhan 0')")
  vim.cmd("autocmd CmdlineLeave * :call system('zenhan 0')")
end
