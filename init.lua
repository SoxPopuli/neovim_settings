vim.cmd([[let mapleader = ","]])
vim.env.NVIM_TUI_ENABLE_TRUE_COLOR = 1
vim.o.termguicolors = 1 -- Enable full color support

if vim.go.loadplugins then
  vim.highlight.priorities.semantic_tokens = 95 -- Prefer treesitter to lsp semantic highlights

  local lazy_setup = require('lazy_setup')

  lazy_setup.install_lazy()

  lazy_setup.startup()
  require('lsp').setup()

  vim.cmd.packadd('termdebug')
  vim.go.termdebug_wide = 1
end

vim.o.path = vim.o.path .. '**'
vim.o.listchars = vim.o.listchars .. ',space:·'

vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4

vim.o.expandtab = true
vim.o.autowrite = false
vim.o.autowriteall = false
vim.o.linebreak = true
vim.o.breakindent = true
vim.o.smartindent = true

vim.cmd('filetype plugin indent on')
vim.cmd('filetype indent on')

vim.o.showmatch = true
vim.o.nowrap = true
vim.o.scrolloff = 2

vim.o.number = true
vim.o.relativenumber = true

vim.o.mouse = 'nv'

vim.o.cursorline = true

vim.o.foldlevel = 16

vim.o.fixeol = false -- Preserve original end of line status

require('commands')

-- Keybinds
local set = vim.keymap.set

--set('n', 'L', 'g$')
--set('n', 'H', 'g_')

set('n', '<F1>', '<Cmd>:nohl<CR>')
set({ 'n', 'i', 'c' }, '<F2>', [[<Cmd>:set list! | set list?<CR>]])
set('n', '<A-z>', [[:set wrap! | set wrap?<CR>]])

set({ 'i', 'c' }, '<C-BS>', '<C-w>', { remap = true })
set({ 'i', 'c' }, '<C-h>', '<C-w>', { remap = true })

-- Escape terminal input with esc
set('t', '<space><Esc>', '<C-\\><C-n>')

-- Ctrl-Z undo
set('i', '<C-z>', '<cmd>:undo<cr>')

-- Ctrl-S save
set({ 'n', 'i' }, '<C-s>', '<cmd>:w<cr>')

-- Alt window switch
set('n', '<A-Up>', '<C-w><Up>', { remap = true })
set('n', '<A-Down>', '<C-w><Down>', { remap = true })
set('n', '<A-Left>', '<C-w><Left>', { remap = true })
set('n', '<A-Right>', '<C-w><Right>', { remap = true })

--set('n', '<A-k>', '<C-w>k')
--set('n', '<A-j>', '<C-w>j')
--set('n', '<A-h>', '<C-w>h')
--set('n', '<A-l>', '<C-w>l')

set('i', '<C-l>', '::')
set('i', '<S-Tab>', '<C-d>')

set('n', '<leader>p', '<C-w><C-p>', { remap = true })

-- Clipboard convenience
set({ 'n', 'v' }, '<Space>y', '"+y', { desc = 'Yank to clipboard' })
set({ 'n', 'v' }, '<Space>p', '"+p', { desc = 'Paste from clipboard' })
set({ 'n', 'v' }, '<Space><S-p>', '"+P', { desc = 'Paste (before) from clipboard' })

-- Maximize window
set('n', '<C-w>m', function()
  vim.api.nvim_win_set_height(0, 9999)
  vim.api.nvim_win_set_width(0, 9999)
end, { desc = 'Maximize window' })

set('n', '<C-w>x', '<cmd>:q<cr>', { desc = 'Close window' })

set('n', '<space><space>', 'a<space><Esc>h', { desc = 'Add space after cursor' })

set('n', '<space>i', 'i<space><Esc>i', { desc = 'Insert before space', remap = false })
set('n', '<space>I', 'I<space><Esc>i', { desc = 'Insert before space', remap = false })

set('n', '<space>a', 'a<space><Esc>i', { desc = 'Append before space', remap = false })

-- Move binds
set('i', '<A-k>', '<cmd>:m .-2<cr><C-o>==', { silent = true })
set('i', '<A-j>', '<cmd>:m .+1<cr><C-o>==', { silent = true })

set('v', '<A-j>', [[:m '>+1<cr>gv=gv]], { silent = true })
set('v', '<A-k>', [[:m '<-2<cr>gv=gv]], { silent = true })

-- Jump commands
set('n', ']q', function()
  local count = vim.v.count1
  vim.cmd(count .. 'cnext')
end, { silent = true, desc = 'Next quickfix item' })
set('n', '[q', function()
  local count = vim.v.count1
  vim.cmd(count .. 'cprev')
end, { silent = true, desc = 'Previous quickfix item' })

set('n', ']b', '<cmd>:bnext<cr>', { silent = true, desc = 'Next buffer' })
set('n', '[b', '<cmd>:bprev<cr>', { silent = true, desc = 'Previous buffer' })

set('n', '<leader>j', [[<cmd>:ColDown<CR>]], { silent = true })
set('n', '<leader>k', [[<cmd>:ColUp<CR>]], { silent = true })

-- make bind
set('n', '<leader>mk', '<cmd>:make<CR>', { desc = 'Make' })

-- toggle virtual edit mode
-- (lets you move cursor to anywhere on screen)
set({ 'n', 'v' }, '<leader>v', function()
  if vim.go.virtualedit == '' then
    vim.go.virtualedit = 'all'
    print('Virtual Edit: Enabled')
  else
    vim.go.virtualedit = ''
    print('Virtual Edit: Disabled')
  end
end, { desc = 'Toggle virtual edit' })

set('n', '<space>*', function()
  local word = vim.fn.expand('<cWORD>')
  vim.cmd('/' .. word)
  vim.api.nvim_feedkeys('n', 'n', true)
end, { desc = 'Search whole word' })

set('v', '<space>/', [[y/<C-r>0<CR>]], { desc = 'Search for selection' })

-- Set indent level keymap
set('n', '<leader>s', function()
  local count = vim.v.count

  if count == 0 then
    return
  else
    vim.bo.sw = count
    print('shiftwidth set to ' .. count)
  end
end, { desc = 'Set shiftwidth' })

-- MacOS specific functionality
if vim.fn.has('mac') then
  -- Fix gx not working properly on Mac
  set('n', 'gx', '<cmd>:silent exec "!open <cWORD>"<cr>', { silent = true })
end


-- abbreviations
vim.cmd.iabbrev('stirng string')
vim.cmd.iabbrev('Stirng String')

set('n', '<C-f>', '<cmd>:TermCenter tmux-sessionizer<cr>')
