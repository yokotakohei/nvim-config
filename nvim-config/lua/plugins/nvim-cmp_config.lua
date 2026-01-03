local M = {}

function M.setup()
  local cmp = require("cmp")
  
  -- Tab キーでインデントと補完を切り替える関数
  local has_words_before = function()
    if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_text(0, line-1, 0, line-1, col, {})[1]:match("^%s*$") == nil
  end

  cmp.setup({
    snippet = {
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
      end,
    },
    sources = {
      { name = "nvim_lsp" },
      { name = "copilot" },  -- Copilot の補完ソースを追加
      -- { name = "buffer" },
      -- { name = "path" },
    },
    mapping = cmp.mapping.preset.insert({
      ["<S-Tab>"] = cmp.mapping.select_prev_item(),  -- 前の候補
      -- Tab キーで候補選択、補完リスト非表示時は通常の Tab
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()  -- 補完リスト表示中は次の候補を選択
        else
          fallback()              -- それ以外は通常の Tab (インデント)
        end
      end, { "i", "s" }),
      ['<C-l>'] = cmp.mapping.complete(),
      ['Esc'] = cmp.mapping.abort(),
      ["<CR>"] = cmp.mapping.confirm { select = true },
    }),
    experimental = {
      ghost_text = true,
    },
  })
end

return M
