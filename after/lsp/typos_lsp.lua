---@type vim.lsp.Config
return {
  init_options = {
    -- 診断の重要度 (Error, Warning, Information, Hint)
    -- Hint だと目立たないので Warning にしておきます。
    diagnosticSeverity = "Warning",
  },
}
