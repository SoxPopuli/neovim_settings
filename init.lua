local vim = vim
vim.cmd([[let mapleader = ","]])
vim.env.NVIM_TUI_ENABLE_TRUE_COLOR = 1

local plugins = require('plugins')

if plugins.CheckPackerExists() == false then
    plugins.InstallPacker()
end

plugins.startup()

vim.highlight.priorities.semantic_tokens = 95 -- Prefer treesitter to lsp semantic highlights

if vim.g.vscode == nil then
    -- plugins.treesitterUpdate()
    -- plugins.treesitterConfig()


    vim.cmd.colorscheme("dracula")
    vim.cmd.packadd("termdebug")
    vim.go.termdebug_wide = 1

    local treesitter = require('tsConfig')
    treesitter.setup()
end

vim.o.path = vim.o.path .. "**"
-- vim.o.lcs = vim.o.lcs .. "space:."

vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4

vim.o.expandtab = true
vim.o.autowrite = true
vim.o.autowriteall = true
vim.o.linebreak = true
vim.o.breakindent = true
vim.o.smartindent = true

vim.cmd("filetype plugin indent on")
vim.cmd("filetype indent on")

vim.o.showmatch = true
vim.o.nowrap = true
vim.o.scrolloff = 2

vim.o.number = true
vim.o.relativenumber = true

vim.o.mouse = "nv"

-- Keybinds

vim.keymap.set('n', '<F1>', '<Cmd>:nohl<CR>')
vim.keymap.set({'n', 'i', 'c'}, '<F2>', [[<Cmd>:set list! | set list?<CR>]])
vim.keymap.set('n', '<A-z>', [[:set wrap! | set wrap?<CR>]])

vim.keymap.set({'i', 'c'}, '<C-BS>', '<C-w>', { remap = true })
vim.keymap.set({'i', 'c'}, '<C-h>', '<C-w>', { remap = true })

-- Escape terminal input with esc
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')

-- Ctrl-Z undo
vim.keymap.set('i', '<C-z>', '<cmd>:undo<cr>')

-- Ctrl-S save
vim.keymap.set({'n', 'i'}, '<C-s>', '<cmd>:w<cr>')

-- Alt window switch
vim.keymap.set('n', '<A-Up>', '<C-w><Up>', { remap = true })
vim.keymap.set('n', '<A-Down>', '<C-w><Down>', { remap = true })
vim.keymap.set('n', '<A-Left>', '<C-w><Left>', { remap = true })
vim.keymap.set('n', '<A-Right>', '<C-w><Right>', { remap = true })
vim.keymap.set('n', '<A-k>', '<C-w>k')
vim.keymap.set('n', '<A-j>', '<C-w>j')
vim.keymap.set('n', '<A-h>', '<C-w>h')
vim.keymap.set('n', '<A-l>', '<C-w>l')

vim.keymap.set('i', '<C-l>', '::')
vim.keymap.set('i', '<S-Tab>', '<C-d>')
