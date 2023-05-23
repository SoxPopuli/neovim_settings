local plugins = {}

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

local function treesitterConfig()
    vim.o.foldlevel = 16

    vim.api.nvim_create_autocmd({'BufEnter','BufAdd','BufNew','BufNewFile','BufWinEnter'}, {
      group = vim.api.nvim_create_augroup('TS_FOLD_WORKAROUND', {}),
      callback = function()
        vim.opt.foldmethod     = 'expr'
        vim.opt.foldexpr       = 'nvim_treesitter#foldexpr()'
      end
    })

    -- require('tsConfig')
end

local function packerStartup(use)
    local vscode = vim.g.vscode == 1

    use 'wbthomason/packer.nvim'

    use 'tpope/vim-surround'
    use 'tpope/vim-repeat'

    use { 'preservim/nerdcommenter' }

    use { 'dracula/vim', as = 'dracula' }

    -- LSP plugins
    local lsp_plugins = {
        { 'neovim/nvim-lspconfig' },
        { 'williamboman/mason.nvim', run = ':masonupdate' },
        { 'williamboman/mason-lspconfig.nvim' },
        { 'L3MON4D3/LuaSnip' },
        { 'saadparwaiz1/cmp_luasnip' },
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

        lsp_plugin_names[i] = item[1]:sub(slash_index+1)
    end

    --use { 'ionide/Ionide-vim' }

    use { 'simrat39/inlay-hints.nvim' }
    -- use { 'lvimuser/lsp-inlayhints.nvim' }

    use {
        'hrsh7th/nvim-cmp',
        config = function() require('lsp').setup() end,
    }
    -- End LSP Plugins

    use { 'mbbill/undotree' }

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

    -- Better Syntax Support
    use { 'sheerun/vim-polyglot' }
    -- File Explorer
    use { 'scrooloose/NERDTree' }
    -- Auto pairs for '(' '[' '{'
    use {
        'windwp/nvim-autopairs',
        config = function()
            local rule = require('nvim-autopairs.rule')
            local npairs = require('nvim-autopairs')
            local cond = require('nvim-autopairs.conds')

            npairs.setup({
                disable_in_visualblock = true,
            })
        end,
    }

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
    require('packer').startup(packerStartup)
end

return plugins
