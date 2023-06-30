vim.cmd([[let mapleader = ","]])
vim.env.NVIM_TUI_ENABLE_TRUE_COLOR = 1
vim.o.termguicolors = 1 -- Enable full color support

if vim.go.loadplugins then
    vim.highlight.priorities.semantic_tokens = 95 -- Prefer treesitter to lsp semantic highlights

    local plugins = require('plugins')

    if plugins.CheckPackerExists() == false then
        plugins.InstallPacker()
    end

    plugins.startup()
    require('lsp').setup()


    vim.cmd.packadd("termdebug")
    vim.go.termdebug_wide = 1

    local treesitter = require('tsConfig')
    treesitter.setup()
end
vim.cmd.colorscheme("catppuccin-mocha")


vim.o.path = vim.o.path .. "**"
vim.o.listchars = vim.o.listchars .. ",space:·"

vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4

vim.o.expandtab = true
vim.o.autowrite = false
vim.o.autowriteall = false
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

vim.o.cursorline = true

-- Keybinds

vim.keymap.set('n', '<F1>', '<Cmd>:nohl<CR>')
vim.keymap.set({ 'n', 'i', 'c' }, '<F2>', [[<Cmd>:set list! | set list?<CR>]])
vim.keymap.set('n', '<A-z>', [[:set wrap! | set wrap?<CR>]])

vim.keymap.set({ 'i', 'c' }, '<C-BS>', '<C-w>', { remap = true })
vim.keymap.set({ 'i', 'c' }, '<C-h>', '<C-w>', { remap = true })

-- Escape terminal input with esc
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')

-- Ctrl-Z undo
vim.keymap.set('i', '<C-z>', '<cmd>:undo<cr>')

-- Ctrl-S save
vim.keymap.set({ 'n', 'i' }, '<C-s>', '<cmd>:w<cr>')

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

vim.keymap.set('n', '<leader>p', '<C-w><C-p>', { remap = true })

-- Clipboard convenience
vim.keymap.set('n', '<Space>y', '"+y')
vim.keymap.set('n', '<Space>p', '"+p')
vim.keymap.set('n', '<Space><S-p>', '"+P')

-- Maximize window
vim.keymap.set('n', '<C-w>m', function()
    vim.api.nvim_win_set_height(0, 9999)
    vim.api.nvim_win_set_width(0, 9999)
end)

vim.keymap.set('n', '<C-w>x', '<cmd>:q<cr>')

-- autocommands
vim.api.nvim_create_autocmd("FileType", {
    -- Close Quickfix window on selection
    pattern = { 'qf' },
    -- command = [[nnoremap <buffer><nowait><silent> <Space> <cr>:lclose:cclose<cr>]]
    callback = function()
        vim.keymap.set('n', '<Space>', function()
            local isLocList =
                vim.fn.getwininfo(vim.fn.win_getid())[1].loclist == 1
            local lnum = vim.fn.line('.')

            if isLocList then
                vim.cmd('ll ' .. lnum)
                vim.cmd.lclose()
            else
                vim.cmd('cc ' .. lnum)
                vim.cmd.cclose()
            end
        end, { buffer = true, nowait = true, silent = true })
    end
})
