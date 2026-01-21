local M = {}

function M.setup()
  local dap = require("dap")

  -- C デバッガアダプターの設定 (codelldb を使用, MasonInstall でインストール可能)
  -- C++ と同じアダプターを使用するため、cpp.lua で設定済み
  if not dap.adapters.codelldb then
    dap.adapters.codelldb = {
      type = 'server',
      port = "${port}",
      executable = {
        command = vim.fn.stdpath("data") .. '/mason/bin/codelldb',
        args = {"--port", "${port}"},
      }
    }
  end

  -- C デバッグ構成
  dap.configurations.c = {
    {
      name = "Launch file",
      type = "codelldb",
      request = "launch",
      program = function()
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      end,
      cwd = '${workspaceFolder}',
      stopOnEntry = false,
    },
    {
      name = 'Attach to process',
      type = 'codelldb',
      request = 'attach',
      pid = require('dap.utils').pick_process,
      args = {},
    },
  }
end

return M
