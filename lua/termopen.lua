local M = {}

local function create_buffer()
  local buf = vim.api.nvim_create_buf(true, true)
  return buf
end

local function round(n)
  return math.floor(n + 0.5)
end

local function termopen(cmd, window)
  vim.fn.termopen(cmd, {
    on_exit = function()
      local buffer = vim.api.nvim_win_get_buf(window)
      vim.api.nvim_win_close(window, false)
      vim.api.nvim_buf_delete(buffer, { force = true })
    end,
  })

  -- Enter insert / terminal mode
  vim.api.nvim_feedkeys('a', 'n', true)
end

function M.open(cmd)
  vim.cmd('vertical split')

  local window = vim.api.nvim_get_current_win()
  local buf = create_buffer()
  vim.api.nvim_win_set_buf(window, buf)

  -- hide window decorations
  vim.wo[window].number = false
  vim.wo[window].relativenumber = false
  vim.wo[window].cursorline = false
  vim.wo[window].cursorcolumn = false
  vim.wo[window].foldcolumn = '0'
  vim.wo[window].spell = false
  vim.wo[window].list = false
  vim.wo[window].signcolumn = 'auto'
  vim.wo[window].colorcolumn = nil
  vim.wo[window].statuscolumn = ''

  termopen(cmd, window)
end

function M.open_floating(cmd, x, y, width, height)
  local buf = create_buffer()

  local window = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    row = y,
    col = x,
    width = round(width),
    height = round(height),
    border = 'rounded',
    style = 'minimal',
  })

  termopen(cmd, window)
end

function M.open_centered(cmd)
  local size = vim.api.nvim_list_uis()[1]
  local max_width = size.width
  local max_height = size.height

  local width = max_width * 0.8
  local height = max_height * 0.8

  local x = (max_width - width) / 2.0
  local y = (max_height - height) / 2.0

  M.open_floating(cmd, x, y / 1.2, width, height)
end

return M
