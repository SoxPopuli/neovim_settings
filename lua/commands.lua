local M = {}

local function system_noeol(cmd, input)
  local result = vim.fn.system(cmd, input)
  local len = string.len(result)

  return string.sub(result, 1, len - 1)
end

--------------------------- User Commands ---------------------------------
-- Go to next row containing text on column
vim.api.nvim_create_user_command('ColDown', function(_)
  vim.cmd.call([[search('\%' . virtcol('.') . 'v\S', 'W')]])
  vim.cmd.call([[repeat#set("\<cmd>ColDown\<cr>", v:count)]])
end, {})
vim.api.nvim_create_user_command('ColUp', function(_)
  vim.cmd.call([[search('\%' . virtcol('.') . 'v\S', 'bW')]])
  vim.cmd.call([[repeat#set("\<cmd>ColUp\<cr>", v:count)]])
end, {})

vim.api.nvim_create_user_command('GitLastActionStatus', function()
  --gh run list --branch $(git branch --show-current) -L 1 --jsstrucn "status"
  local is_git_repo = string.sub(system_noeol('git rev-parse --is-inside-work-tree'), 1, 4) == 'true'
  if is_git_repo then
    local current_branch = system_noeol('git branch --show-current')
    local statuses = system_noeol('gh run list --branch ' .. current_branch .. " -L 1 --json 'status'")
    statuses = vim.json.decode(statuses)

    if #statuses == 0 then
      vim.notify('No actions found', vim.log.levels.INFO, { annote = 'GH Actions' })
    else
      vim.notify(statuses[1].status, vim.log.levels.INFO, { annote = 'GH Actions' })
    end
  else
    vim.notify('No repo found', vim.log.levels.INFO, { annote = 'GH Actions' })
  end
end, { desc = 'Get last gh actions status', nargs = 0 })

-- Create scratch buffer
local scratch_count = 0
vim.api.nvim_create_user_command('Scratch', function(args)
  local old_splitright = vim.o.splitright
  vim.o.splitright = true
  vim.cmd('vertical split')
  vim.o.splitright = old_splitright

  local buf = vim.api.nvim_create_buf(true, true)

  local name = args.args
  if name:len() == 0 then
    scratch_count = scratch_count + 1
    vim.api.nvim_buf_set_name(buf, 'Scratch ' .. scratch_count)
  else
    vim.api.nvim_buf_set_name(buf, name)
  end
  vim.cmd('b ' .. buf)
end, { desc = 'Create temporary scratch buffer', nargs = '?' })

vim.api.nvim_create_user_command('TermOpen', function(args)
  require('termopen').open(args.args)
end, { nargs = 1 })

vim.api.nvim_create_user_command('TermCenter', function(args)
  require('termopen').open_centered(args.args)
end, { nargs = 1 })

vim.api.nvim_create_user_command('DotnetFullRestore', function()
  local function has_file(path)
    return vim.fn.filereadable(path) == 1
  end

  if has_file('./.config/dotnet-tools.json') then
    vim.cmd('!dotnet tool restore')

    if has_file('paket.dependencies') then
      vim.cmd('!dotnet paket restore')
    end
  end

  vim.cmd('!dotnet restore')
end, { nargs = 0 })
-------------------------- Autocommands -----------------------------------

vim.api.nvim_create_autocmd('FileType', {
  -- Close Quickfix window on selection
  pattern = { 'qf' },
  -- command = [[nnoremap <buffer><nowait><silent> <Space> <cr>:lclose:cclose<cr>]]
  callback = function()
    vim.keymap.set('n', '<Space>', function()
      local isLocList = vim.fn.getwininfo(vim.fn.win_getid())[1].loclist == 1
      local lnum = vim.fn.line('.')

      if isLocList then
        vim.cmd('ll ' .. lnum)
        vim.cmd.lclose()
      else
        vim.cmd('cc ' .. lnum)
        vim.cmd.cclose()
      end
    end, { buffer = true, nowait = true, silent = true })
  end,
})

return M
