local M = {}

function M.setup()
  local dap = require("dap")

  -- Python デバッガアダプターの設定 (debugpy を使用)
  dap.adapters.python = {
    type = 'executable',
    command = 'python3',
    args = { '-m', 'debugpy.adapter' },
  }

  -- Python デバッグ構成
  dap.configurations.python = {
    {
      type = 'python',
      request = 'launch',
      name = "Launch file",
      program = "${file}",
      pythonPath = function()
        -- 仮想環境を自動検出
        local cwd = vim.fn.getcwd()
        if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
          return cwd .. '/venv/bin/python'
        elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
          return cwd .. '/.venv/bin/python'
        else
          return '/usr/bin/python3'
        end
      end,
    },
    {
      type = 'python',
      request = 'launch',
      name = "Launch file with arguments",
      program = "${file}",
      args = function()
        local args_string = vim.fn.input('Arguments: ')
        return vim.split(args_string, " +")
      end,
      pythonPath = function()
        local cwd = vim.fn.getcwd()
        if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
          return cwd .. '/venv/bin/python'
        elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
          return cwd .. '/.venv/bin/python'
        else
          return '/usr/bin/python3'
        end
      end,
    },
  }
end

return M
