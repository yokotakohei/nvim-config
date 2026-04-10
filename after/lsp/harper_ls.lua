---@type vim.lsp.Config
return {
  -- デフォルトの filetypes に fortran を追加します。
  filetypes = {
    "asciidoc", "c", "cpp", "cs", "gitcommit", "go", "html", "java",
    "javascript", "lua", "markdown", "nix", "python", "ruby", "rust",
    "swift", "toml", "typescript", "typescriptreact", "haskell",
    "cmake", "typst", "php", "dart", "clojure", "sh",
    "fortran",
  },
  settings = {
    ["harper-ls"] = {
      -- ユーザー辞書のパス (zg で追加した単語を保存)
      userDictPath = "",
      -- ファイル辞書のパス
      fileDictPath = "",
      -- 英語の方言 (American, British, Australian, Canadian)
      dialect = "American",
      -- 個別の lint を有効/無効化
      linters = {
        SpellCheck = true,
        SpelledNumbers = false,
        AnA = true,
        SentenceCapitalization = true,
        UnclosedQuotes = true,
        WrongQuotes = false,
        LongSentences = true,
        RepeatedWords = true,
        Spaces = true,
        Matcher = true,
        CorrectNumberSuffix = true,
      },
      codeActions = {
        ForceStable = false,
      },
      markdown = {
        IgnoreLinkTitle = false,
      },
      diagnosticSeverity = "warning",
      isolateEnglish = false,
    },
  },
}
