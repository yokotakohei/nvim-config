local M = {}

function M.setup()
  local dap = require("dap")

  ---------------------------------------------------------------------------
  -- Python 実行環境の検出（debug 対象プログラム用）
  ---------------------------------------------------------------------------
  local function detect_python()
    local cwd = vim.fn.getcwd()

    if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
      return cwd .. "/venv/bin/python"
    elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
      return cwd .. "/.venv/bin/python"
    elseif vim.fn.executable(vim.fn.expand("~/python-venv/base/bin/python3")) == 1 then
      return vim.fn.expand("~/python-venv/base/bin/python3")
    else
      return "/usr/bin/python3"
    end
  end

  ---------------------------------------------------------------------------
  -- Debug adapter (debugpy)
  -- debugpy が入っている Python を固定で指定する
  ---------------------------------------------------------------------------
  dap.adapters.python = {
    type = "executable",
    command = vim.fn.expand("~/python-venv/base/bin/python3"),
    args = { "-m", "debugpy.adapter" },
  }

  ---------------------------------------------------------------------------
  -- Python debug configurations
  ---------------------------------------------------------------------------
  dap.configurations.python = {
    {
      type = "python",
      request = "launch",
      name = "Launch file",
      program = "${file}",
      pythonPath = detect_python,
    },
    {
      type = "python",
      request = "launch",
      name = "Launch file with arguments",
      program = "${file}",
      args = function()
        return vim.split(vim.fn.input("Arguments: "), " +")
      end,
      pythonPath = detect_python,
    },
  }
end

return M