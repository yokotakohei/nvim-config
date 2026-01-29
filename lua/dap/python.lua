local M = {}

function M.setup()
  local dap = require("dap")

  local is_windows = vim.loop.os_uname().sysname == "Windows_NT"

  ---------------------------------------------------------------------------
  -- Python 実行環境の検出（debug 対象プログラム用）
  ---------------------------------------------------------------------------

  local function detect_python()
    local cwd = vim.fn.getcwd()

    if is_windows then
      if vim.fn.executable(cwd .. "/venv/Scripts/python.exe") == 1 then
        return cwd .. "/venv/Scripts/python.exe"
      elseif vim.fn.executable(cwd .. "/.venv/Scripts/python.exe") == 1 then
        return cwd .. "/.venv/Scripts/python.exe"
      elseif vim.fn.executable(vim.fn.expand("~/AppData/Local/miniconda3/python.exe")) == 1 then
        return vim.fn.expand("~/AppData/Local/miniconda3/python.exe")
      else
        return "python"
      end
    else
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
  end

  ---------------------------------------------------------------------------
  -- Debug adapter (debugpy)
  -- debugpy が入っている Python を固定で指定する
  ---------------------------------------------------------------------------

  local adapter_python
  if is_windows then
    adapter_python = vim.fn.expand("~/AppData/Local/miniconda3/python.exe")
  else
    adapter_python = vim.fn.expand("~/python-venv/base/bin/python3")
  end

  dap.adapters.python = {
    type = "executable",
    command = adapter_python,
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
