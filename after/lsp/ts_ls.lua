---@type vim.lsp.Config
return {
    -- npm install -g typescript で tsserver をインストールすること．
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    autostart = true,
}
