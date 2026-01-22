local M = {}

function M.setup()
  local dap = require("dap")
  local dapui = require("dapui")

  ------------------------------------------------------------------------------
  -- DAP UI の設定
  ------------------------------------------------------------------------------
  dapui.setup()

  -- DAP のイベントに応じて UI を自動的に開閉
  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end
  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
  end
  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
  end

  ------------------------------------------------------------------------------
  -- キーマッピングの設定
  ------------------------------------------------------------------------------
  vim.keymap.set('n', '<F5>', function() dap.continue() end, { desc = 'DAP: Continue' })
--   vim.keymap.set('n', '<F10>', function() dap.step_over() end, { desc = 'DAP: Step Over' })
--   vim.keymap.set('n', '<F11>', function() dap.step_into() end, { desc = 'DAP: Step Into' })
--   vim.keymap.set('n', '<F12>', function() dap.step_out() end, { desc = 'DAP: Step Out' })
  vim.keymap.set('n', '<Leader>b', function() dap.toggle_breakpoint() end, { desc = 'DAP: Toggle Breakpoint' })
  vim.keymap.set('n', '<Leader>B', function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, { desc = 'DAP: Set Conditional Breakpoint' })
  vim.keymap.set('n', '<Leader>dr', function() dap.repl.open() end, { desc = 'DAP: Open REPL' })
  vim.keymap.set('n', '<Leader>dl', function() dap.run_last() end, { desc = 'DAP: Run Last' })

  ------------------------------------------------------------------------------
  -- 言語別のアダプター設定を読み込み
  ------------------------------------------------------------------------------
  require("dap.python").setup()
  require("dap.cpp").setup()
  require("dap.c").setup()
  require("dap.fortran").setup()
end

return M
