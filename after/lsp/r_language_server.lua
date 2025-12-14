---@type vim.lsp.Config
return {
  on_attach = function(client, bufnr)
  -- キー バインディングの設定などがあればここに追加
  end,
  settings = {
    r = {
      lsp = {
        debug = true, -- デバッグ モードを有効にする (オプション)
        use_stdio = true, -- stdio モードを使用する
      }
    }
  }
}
