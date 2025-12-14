local M = {}

function M.setup()
  require("lsp_lines").setup()
  
  -- lsp_lines を使うために diagnostic のみバーチャル テキストを停止します。
  vim.diagnostic.config({
    virtual_text = false,
  })
  
  -- lsp_lines を動作させます。
  vim.diagnostic.config({ virtual_lines = true })
  
  -- 表示を切り替えるキー マップです。
  vim.keymap.set(
    "",
    "<Leader>l",
    require("lsp_lines").toggle,
    { desc = "Toggle lsp_lines" }
  )
end

return M
