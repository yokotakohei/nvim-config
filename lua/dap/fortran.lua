local M = {}

function M.setup()
  local dap = require("dap")

  ---------------------------------------------------------------------------
  -- Debug adapters
  ---------------------------------------------------------------------------

  -- gdb adapter (DAP interpreter)
  if not dap.adapters.gdb then
    dap.adapters.gdb = {
      type = "executable",
      command = "gdb",
      args = { "--interpreter=dap" },
    }
  end

  ---------------------------------------------------------------------------
  -- Fortran debug configurations
  ---------------------------------------------------------------------------

  dap.configurations.fortran = {
    {
      name = "Launch file (gdb)",
      type = "gdb",
      request = "launch",

      -- 実行ファイルを対話的に指定する。
      program = function()
        return vim.fn.input(
          "Path to executable: ",
          vim.fn.getcwd() .. "/",
          "file"
        )
      end,

      cwd = "${workspaceFolder}",

      -- main program の先頭で停止する。
      stopAtBeginningOfMainSubprogram = true,
    },
  }
end

return M
