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

-- undo 履歴を有効化します．
vim.opt.undofile = true

-- OS を問わず適切なデータ保存場所を取得します．
-- Windows: ~/AppData/Local/nvim-data/undo
-- Linux/macOS: ~/.local/share/nvim/undo
local undo_path = vim.fn.stdpath("data") .. "/undo"

-- ディレクトリが存在しない場合は作成します．
if vim.fn.isdirectory(undo_path) == 0 then
    vim.fn.mkdir(undo_path, "p")
end

vim.opt.undodir = undo_path

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
vim.lsp.enable("ts_ls")

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

-- smartindent は「#」がインデントされないなどの問題があるためオフにします．
vim.opt.smartindent = false

-- 改行時に前の行の深さを引き継ぎます．
vim.opt.autoindent = true

-- 言語ごとのインデント ルールを有効化します．
vim.cmd('filetype plugin indent on')

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

-- シェル設定
if env.is_wsl or env.is_vscode then
  vim.o.shell = "/usr/bin/bash --login"
elseif env.is_windows then
  vim.o.shell = "cmd.exe"
end

-- IME 状態の保存・復元
-- InsertLeave 時に IME をオフにし，InsertEnter 時に前回の状態を復元する．
-- 利用可能な IME 制御コマンドを自動検出し，Windows / WSL / Docker いずれでも動作する．
do
  local ime_cmd

  if env.is_windows and vim.fn.executable("zenhan") == 1 then
    ime_cmd = {
      get = function() return tonumber(vim.trim(vim.fn.system("zenhan"))) or 0 end,
      off = function() vim.fn.system("zenhan 0") end,
      on  = function() vim.fn.system("zenhan 1") end,
    }
  elseif vim.fn.executable("zenhan.exe") == 1 then
    ime_cmd = {
      get = function() return tonumber(vim.trim(vim.fn.system("zenhan.exe"))) or 0 end,
      off = function() vim.fn.system("zenhan.exe 0") end,
      on  = function() vim.fn.system("zenhan.exe 1") end,
    }
  elseif vim.fn.executable("fcitx5-remote") == 1 then
    ime_cmd = {
      get = function()
        return tonumber(vim.trim(vim.fn.system("fcitx5-remote"))) == 2 and 1 or 0
      end,
      off = function() vim.fn.system("fcitx5-remote -c") end,
      on  = function() vim.fn.system("fcitx5-remote -o") end,
    }
  end

  if ime_cmd then
    local saved_ime = 0
    local group = vim.api.nvim_create_augroup("IMEControl", { clear = true })

    vim.api.nvim_create_autocmd("InsertLeave", {
      group = group,
      callback = function()
        saved_ime = ime_cmd.get()
        ime_cmd.off()
      end,
    })

    vim.api.nvim_create_autocmd("InsertEnter", {
      group = group,
      callback = function()
        if saved_ime == 1 then
          ime_cmd.on()
        end
      end,
    })

    vim.api.nvim_create_autocmd("CmdlineLeave", {
      group = group,
      callback = function()
        ime_cmd.off()
      end,
    })
  end
end

--------------------------------------------------------------------------------
-- Clipboard 設定
--
-- WSL 環境では win32yank.exe を経由して Windows のクリップボードと連携する。
-- DevContainer (Docker) 内では .exe が実行できないため、ターミナルの
-- OSC 52 エスケープシーケンスを利用してクリップボードへアクセスする。
-- OSC 52 は Windows Terminal / WezTerm 等の対応ターミナルが必要。
--
-- OSC 52 のペースト（読み取り）はターミナルの応答がコンテナまで届かず
-- 失敗することがあるため、コピーのみ OSC 52 を使い、ペーストは
-- ターミナル側の操作（Ctrl+Shift+V 等）で行う。
--------------------------------------------------------------------------------
local in_container = vim.fn.filereadable("/.dockerenv") == 1

if env.is_wsl and vim.fn.executable("win32yank.exe") == 1 and not in_container then
  vim.g.clipboard = {
    name = "win32yank",
    copy = {
      ["+"] = "win32yank.exe -i --crlf",
      ["*"] = "win32yank.exe -i --crlf",
    },
    paste = {
      ["+"] = "win32yank.exe -o --lf",
      ["*"] = "win32yank.exe -o --lf",
    },
  }
else
  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
      ["+"] = "",
      ["*"] = "",
    },
  }
end

