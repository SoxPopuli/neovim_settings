local plugins = {}

AutopairsConfigSet = false

local configPath = vim.fn.stdpath('config')
local dataPath = vim.fn.stdpath('data')

local packerPath = dataPath .. [[/site/pack/packer/start/packer.nvim]]
packerPath = packerPath:gsub([[\]], [[\\]]) -- Escape path separators on Windows

function plugins.CheckPackerExists()
    if vim.fn.glob(packerPath) == "" then
        return false
    else
        return true
    end
end

function plugins.InstallPacker()
    local repo = "https://github.com/wbthomason/packer.nvim"
    vim.cmd([[!mkdir -pv ]] .. packerPath)
    vim.cmd([[!git clone --depth 1 ]] .. repo .. " " .. packerPath)
    vim.cmd([[packadd packer.nvim]])
end

local function easymotionConfig()
    vim.keymap.set('n', '<Leader>', '<plug>(easymotion-prefix)', { remap = true })
end

local function treesitterUpdate()
    local tsUpdate = require('nvim-treesitter.install').update({ with_sync = true })
    tsUpdate()
end

local function treesitterConfig()
    vim.o.foldlevel = 16

    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufAdd', 'BufNew', 'BufNewFile', 'BufWinEnter' }, {
        group = vim.api.nvim_create_augroup('TS_FOLD_WORKAROUND', {}),
        callback = function()
            vim.opt.foldmethod = 'expr'
            vim.opt.foldexpr   = 'nvim_treesitter#foldexpr()'
        end
    })

    -- require('tsConfig')
end

function FzfGit()
    local hasGitIgnore = vim.fn.glob('.gitignore') ~= ""

    local srcCmd = nil -- nil command uses default file search
    if hasGitIgnore then
        srcCmd = 'git ls-files'
    end

    local windowSize = { width = 0.9, height = 0.6 }
    vim.call('fzf#run', {
        source = srcCmd,
        sink = 'e',
        window = windowSize,
    })
end

function AutopairsConfig(npairs)
    --local has_npairs, npairs               = pcall(require, 'nvim-autopairs')
    local has_cmp_autopairs, cmp_autopairs = pcall(require, 'nvim-autopairs.completion.cmp')
    local has_cmp, cmp                     = pcall(require, 'cmp')
    local has_Rule, Rule                   = pcall(require, 'nvim-autopairs.rule')
    local has_cond, cond                   = pcall(require, 'nvim-autopairs.conds')

    if not (has_cmp_autopairs and has_cmp and has_Rule and has_cond) then
        return
    end

    cmp.event:on(
        'confirm_done',
        cmp_autopairs.on_confirm_done()
    )

    -- Add space between brackets
    local brackets = { { '(', ')' }, { '[', ']' }, { '{', '}' } }
    npairs.add_rules {
        Rule(' ', ' ')
            :with_pair(function(opts)
                local pair = opts.line:sub(opts.col - 1, opts.col)
                return vim.tbl_contains({
                    brackets[1][1] .. brackets[1][2],
                    brackets[2][1] .. brackets[2][2],
                    brackets[3][1] .. brackets[3][2],
                }, pair)
            end)
    }
    for _, bracket in pairs(brackets) do
        npairs.add_rules {
            Rule(bracket[1] .. ' ', ' ' .. bracket[2])
                :with_pair(function() return false end)
                :with_move(function(opts)
                    return opts.prev_char:match('.%' .. bracket[2]) ~= nil
                end)
                :use_key(bracket[2])
        }
    end
end

function LuaSnipConfig()
    local luasnip = require('luasnip')
    vim.keymap.set('s', '<Tab>', function()
        if luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
        else
            return '<Tab>'
        end
    end, { expr = true })

    vim.keymap.set('i', '<Tab>', function()
        if luasnip.jumpable() then
            luasnip.jump(1)
        else
            return '<Tab>'
        end
    end, { expr = true })

    vim.keymap.set('i', '<S-Tab>', function()
        if luasnip.jumpable() then
            luasnip.jump(-1)
        else
            return '<C-d>'
        end
    end, { expr = true })
end

local function packerStartup(use)
    local vscode = vim.g.vscode == 1

    use 'wbthomason/packer.nvim'
    use 'tpope/vim-surround'
    use 'tpope/vim-repeat'

    use { 'preservim/nerdcommenter' }

    use { 'dracula/vim', as = 'dracula' }
    use { 'catppuccin/nvim', as = 'catppuccin' }

    use { 'scalameta/nvim-metals', requires = { "nvim-lua/plenary.nvim" } }

    -- LSP plugins
    local lsp_plugins = {
        { 'neovim/nvim-lspconfig' },
        { 'williamboman/mason.nvim',          run = ':masonupdate' },
        { 'williamboman/mason-lspconfig.nvim' },
        { 'hrsh7th/cmp-nvim-lsp' },
        { 'hrsh7th/cmp-buffer' },
        { 'hrsh7th/cmp-path' },
        { 'hrsh7th/cmp-cmdline' },
        { 'simrat39/rust-tools.nvim' },
    }
    local lsp_plugin_names = {}

    for i, item in ipairs(lsp_plugins) do
        use(item)
        local slash_index = item[1]:find('/')

        lsp_plugin_names[i] = item[1]:sub(slash_index + 1)
    end

    use { 'L3MON4D3/LuaSnip', config = function() LuaSnipConfig() end }
    use { 'saadparwaiz1/cmp_luasnip' }

    --use { 'ionide/Ionide-vim' }

    use { 'simrat39/inlay-hints.nvim' }
    -- use { 'lvimuser/lsp-inlayhints.nvim' }

    use { 'hrsh7th/nvim-cmp' }
    use { 'hrsh7th/cmp-nvim-lsp-signature-help' }

    use { 'mbbill/undotree',
        config = function()
            vim.keymap.set('n', '<leader>u', function()
                vim.cmd.UndotreeToggle()
            end)
        end
    }

    use { 'markwoodhall/vim-nuget' } -- NuGet Support

    -- Debugger protocol support
    use { 'mfussenegger/nvim-dap' }

    -- use normal easymotion when in VIM mode
    use { 'easymotion/vim-easymotion', config = easymotionConfig }

    -- Treesitter
    use { 'HiPhish/nvim-ts-rainbow2' }
    use {
        'nvim-treesitter/nvim-treesitter',
        run = treesitterUpdate,
        config = treesitterConfig,
    }

    -- Outline view: LSP / Treesitter driven
    use {
        'stevearc/aerial.nvim',
        config = function()
            local aerial = require('aerial')
            aerial.setup({
                on_attach = function(bufnr)
                    vim.keymap.set('n', '}', function() aerial.next(1) end, { buffer = bufnr })
                    vim.keymap.set('n', '{', function() aerial.prev(1) end, { buffer = bufnr })
                end,
                --filter_kind = false,
            })

            vim.keymap.set('n', '<Leader>a', function()
                aerial.toggle({
                    focus = true,
                    direction = "right",
                })
            end)
        end
    }

    -- Better Syntax Support
    use { 'sheerun/vim-polyglot' }
    -- File Explorer
    use { 'scrooloose/NERDTree' }
    -- Auto pairs for '(' '[' '{'
    use {
        'windwp/nvim-autopairs',
        config = function()
            local npairs = require('nvim-autopairs')
            npairs.setup({
                disable_in_visualblock = true,
                fast_wrap = {},
            })

            if not AutopairsConfigSet then
                AutopairsConfig(npairs)
                AutopairsConfigSet = true
            end
        end,
    }
    -- If you want insert `(` after select function or method item

    use {
        'junegunn/fzf',
        run = ':call fzf#install()',
        config = function()
            vim.keymap.set('n', '<M-p>', '<cmd>FZF<cr>')
            vim.keymap.set('n', '<C-p>', FzfGit)
        end,
    }

    -- VSCode easy motion
    -- use {
    --     'asvetliakov/vim-easymotion',
    --     as = 'vsc-easymotion',
    --     config = easymotionConfig,
    --     cond = vscode,
    --     disable = not vscode,
    -- }

    -- Keep at end - downloads updates
    if plugins.CheckPackerExists() then
        require('packer').sync()
    end
end

function plugins.startup()
    require('packer').startup({
        packerStartup,
        config = {
            display = {
                open_fn = require('packer.util').float,
            }
        }
    })
end

return plugins
