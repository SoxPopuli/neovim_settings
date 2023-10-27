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

vim.o.foldlevel = 16

-- Keybinds
local set = vim.keymap.set

set('n', '<F1>', '<Cmd>:nohl<CR>')
set({ 'n', 'i', 'c' }, '<F2>', [[<Cmd>:set list! | set list?<CR>]])
set('n', '<A-z>', [[:set wrap! | set wrap?<CR>]])

set({ 'i', 'c' }, '<C-BS>', '<C-w>', { remap = true })
set({ 'i', 'c' }, '<C-h>', '<C-w>', { remap = true })

-- Escape terminal input with esc
set('t', '<Esc>', '<C-\\><C-n>')

-- Ctrl-Z undo
set('i', '<C-z>', '<cmd>:undo<cr>')

-- Ctrl-S save
set({ 'n', 'i' }, '<C-s>', '<cmd>:w<cr>')

-- Alt window switch
set('n', '<A-Up>', '<C-w><Up>', { remap = true })
set('n', '<A-Down>', '<C-w><Down>', { remap = true })
set('n', '<A-Left>', '<C-w><Left>', { remap = true })
set('n', '<A-Right>', '<C-w><Right>', { remap = true })
set('n', '<A-k>', '<C-w>k')
set('n', '<A-j>', '<C-w>j')
set('n', '<A-h>', '<C-w>h')
set('n', '<A-l>', '<C-w>l')

set('i', '<C-l>', '::')
set('i', '<S-Tab>', '<C-d>')

set('n', '<leader>p', '<C-w><C-p>', { remap = true })

-- Clipboard convenience
set({ 'n', 'v' }, '<Space>y', '"+y')
set({ 'n', 'v' }, '<Space>p', '"+p')
set({ 'n', 'v' }, '<Space><S-p>', '"+P')

-- Maximize window
set('n', '<C-w>m', function()
    vim.api.nvim_win_set_height(0, 9999)
    vim.api.nvim_win_set_width(0, 9999)
end)

set('n', '<C-w>x', '<cmd>:q<cr>')

set('n', '<space><space>', 'a<space><Esc>h')

-- Move binds
set('i', '<A-k>', '<cmd>:m .-2<cr><C-o>==', { silent = true })
set('i', '<A-j>', '<cmd>:m .+1<cr><C-o>==', { silent = true })

set('v', '<A-j>', [[:m '>+1<cr>gv=gv]], { silent = true })
set('v', '<A-k>', [[:m '<-2<cr>gv=gv]], { silent = true })

-- Jump commands
set('n', ']q', function()
    local count = vim.v.count1
    vim.cmd(count .. 'cnext')
end, { silent = true })
set('n', '[q', function()
    local count = vim.v.count1
    vim.cmd(count .. 'cprev')
end, { silent = true })

set('n', ']b', '<cmd>:bnext<cr>', { silent = true })
set('n', '[b', '<cmd>:bprev<cr>', { silent = true })

-- Go to next row containing text on column
vim.api.nvim_create_user_command('ColDown', function(_)
    vim.cmd.call([[search('\%' . virtcol('.') . 'v\S', 'W')]])
    vim.cmd.call([[repeat#set("\<cmd>ColDown\<cr>", v:count)]])
end, {})
vim.api.nvim_create_user_command('ColUp', function(_)
    vim.cmd.call([[search('\%' . virtcol('.') . 'v\S', 'bW')]])
    vim.cmd.call([[repeat#set("\<cmd>ColUp\<cr>", v:count)]])
end, {})

set('n', '<leader>j', [[<cmd>:ColDown<CR>]], { silent = true })
set('n', '<leader>k', [[<cmd>:ColUp<CR>]], { silent = true })

-- make bind
set('n', '<leader>mk', '<cmd>:make<CR>')

-- toggle virtual edit mode
-- (lets you move cursor to anywhere on screen)
set({ 'n', 'v' }, '<leader>v', function ()
    if(vim.go.virtualedit == "") then
        vim.go.virtualedit = "all"
        print('Virtual Edit: Enabled')
    else
        vim.go.virtualedit = ""
        print('Virtual Edit: Disabled')
    end
end)

-- Set indent level keymap
set('n', '<leader>s', function ()
    local count = vim.v.count

    if count == 0 then
        return
    else
        vim.bo.sw = count
        print("shiftwidth set to " .. count)
    end
end)

-- MacOS specific functionality
if vim.fn.has('mac') then
    -- Fix gx not working properly on Mac
    set('n', 'gx', '<cmd>:silent exec "!open <cWORD>"<cr>', { silent = true })
end

-- Create scratch buffer
ScratchCount = 0
vim.api.nvim_create_user_command('Scratch', function(args)
    local old_splitright = vim.o.splitright
    vim.o.splitright = true
    vim.cmd('vertical split')
    vim.o.splitright = old_splitright

    local buf = vim.api.nvim_create_buf(true, true)

    local name = args.args
    if name:len() == 0 then
        ScratchCount = ScratchCount + 1
        vim.api.nvim_buf_set_name(buf, 'Scratch ' .. ScratchCount)
    else
        vim.api.nvim_buf_set_name(buf, name)
    end
    vim.cmd('b ' .. buf)
end, { desc = "Create temporary scratch buffer", nargs = '?' })

vim.api.nvim_create_user_command('TermOpen', function(args)
    require('termopen').open(args.args)
end, { nargs = 1 })

vim.api.nvim_create_user_command('TermCenter', function(args)
    require('termopen').open_centered(args.args)
end, { nargs = 1 })

-- autocommands
vim.api.nvim_create_autocmd("FileType", {
    -- Close Quickfix window on selection
    pattern = { 'qf' },
    -- command = [[nnoremap <buffer><nowait><silent> <Space> <cr>:lclose:cclose<cr>]]
    callback = function()
        set('n', '<Space>', function()
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

-- abbreviations
vim.cmd.iabbrev("stirng string")
vim.cmd.iabbrev("Stirng String")
