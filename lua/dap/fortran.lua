local M = {}

function M.setup()
  local dap = require("dap")

  -- Fortran デバッガアダプターの設定 (codelldb または gdb を使用)
  -- codelldb を優先的に使用 (MasonInstall でインストール可能)
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

  -- Fortran デバッグ構成
  dap.configurations.fortran = {
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