return {
  "CopilotC-Nvim/CopilotChat.nvim",
  branch = "main",
  dependencies = {
    { "zbirenbaum/copilot.lua" },
    { "nvim-lua/plenary.nvim" },
  },
  config = function()
    local home = vim.fn.expand("~")
    require("CopilotChat").setup({
      model = 'gpt-4o',  -- デフォルトモデル (gpt-4o, gpt-4, claude-3.5-sonnet など)
      show_help = "yes",
      auto_insert_mode = true,  -- チャット起動時に自動的にインサートモードに
      clear_chat_on_new_prompt = false,  -- 新しいプロンプトでチャットをクリアしない
      context = nil,  -- デフォルトコンテキストを無効化（@bufferを明示的に使用）
      history_path = home .. "/.local/share/nvim/copilot_chat_history",  -- 履歴を保存するパス
      window = {
        layout = 'float',  -- チャットウィンドウをフローティング表示
        relative = 'editor',
        width = 0.8,
        height = 0.8,
        row = 1,
      },
      mappings = {
        complete = {
          insert = '',
        },
        close = {
          normal = 'q',
          insert = '<C-c>',
        },
        reset = {
          normal = '<C-r>',
          insert = '<C-r>',
        },
        submit_prompt = {
          normal = '<CR>',
          insert = '<C-s>',
        },
        accept_diff = {
          normal = '<C-y>',
          insert = '<C-y>',
        },
      },
      prompts = {
        Explain = {
          prompt = "/COPILOT_EXPLAIN コードを日本語で説明してください",
          mapping = '<leader>ce',
          description = "コードの説明をお願いする",
        },
        Review = {
          prompt = '/COPILOT_REVIEW コードを日本語でレビューしてください。',
          mapping = '<leader>cr',
          description = "コードのレビューをお願いする",
        },
        Fix = {
          prompt = "/COPILOT_FIX このコードには問題があります。バグを修正したコードを表示してください。説明は日本語でお願いします。",
          mapping = '<leader>cf',
          description = "コードの修正をお願いする",
        },
        Optimize = {
          prompt = "/COPILOT_REFACTOR 選択したコードを最適化し、パフォーマンスと可読性を向上させてください。説明は日本語でお願いします。",
          mapping = '<leader>co',
          description = "コードの最適化をお願いする",
        },
        Docs = {
          prompt = "/COPILOT_GENERATE 選択したコードに関するドキュメントコメントを日本語で生成してください。",
          mapping = '<leader>cd',
          description = "コードのドキュメント作成をお願いする",
        },
        Tests = {
          prompt = "/COPILOT_TESTS 選択したコードの詳細なユニットテストを書いてください。説明は日本語でお願いします。",
          mapping = '<leader>ct',
          description = "テストコード作成をお願いする",
        },
        FixDiagnostic = {
          prompt = 'コードの診断結果に従って問題を修正してください。修正内容の説明は日本語でお願いします。',
          mapping = '<leader>cD',
          description = "コードの修正をお願いする",
          selection = require('CopilotChat.select').diagnostics,
        },
        Commit = {
          prompt = '実装差分に対するコミットメッセージを日本語で記述してください。',
          mapping = '<leader>cco',
          description = "コミットメッセージの作成をお願いする",
          selection = require('CopilotChat.select').gitdiff,
        },
        CommitStaged = {
          prompt = 'ステージ済みの変更に対するコミットメッセージを日本語で記述してください。',
          mapping = '<leader>cs',
          description = "ステージ済みのコミットメッセージの作成をお願いする",
          selection = function(source)
            return require('CopilotChat.select').gitdiff(source, true)
          end,
        },
      },
    })
  end,
}
