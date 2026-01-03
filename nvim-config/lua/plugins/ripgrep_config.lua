-- ripgrep で vimgrep をオーバーライドします。
-- ripgrep が存在する場合は vimgrep で ripgrep が使用され、
-- 存在しない場合はデフォルトの vimgrep が使用されます。
local M = {}

-- ripgrep が存在すれば true を返します。
local function is_ripgrep_available()
  return vim.fn.executable('rg') == 1
end

function M.setup()
  -- ripgrep が存在する場合は vimgrep で用いる grep を
  -- ripgrep に変更します。
  if is_ripgrep_available() then
    vim.o.grepprg = 'rg --vimgrep --no-heading --smart-case'
    vim.o.grepformat = '%f:%l:%c:%m,%f:%l:%m'
  else
    vim.o.grepprg = 'internal'
  end

  -- Ripgrep コマンドを作成します。
  vim.api.nvim_create_user_command('Ripgrep', function(opts)
    if is_ripgrep_available() then
      local cmd = string.format('silent grep! %s', opts.args)
      vim.cmd(cmd)
    else
      vim.cmd('vimgrep ' .. opts.args)
    end
    vim.cmd('copen')
  end, {nargs = '+', complete = 'file'})
end

return M
