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

local function treesitterConfig()
    vim.o.foldlevel = 16

    vim.api.nvim_create_autocmd({'BufEnter','BufAdd','BufNew','BufNewFile','BufWinEnter'}, {
      group = vim.api.nvim_create_augroup('TS_FOLD_WORKAROUND', {}),
      callback = function()
        vim.opt.foldmethod     = 'expr'
        vim.opt.foldexpr       = 'nvim_treesitter#foldexpr()'
      end
    })

    require('tsConfig').setup()
end

local function packerStartup(use)
    local vscode = vim.g.vscode == 1

    use 'wbthomason/packer.nvim'

    use 'tpope/vim-surround'
    use 'tpope/vim-repeat'

    use { 'preservim/nerdcommenter' }

    -- LSP plugins
    local lsp_plugins = {
        { 'neovim/nvim-lspconfig' },
        { 'williamboman/mason.nvim', run = ':MasonUpdate' },
        { 'williamboman/mason-lspconfig.nvim' },
        { 'SirVer/ultisnips' },
        { 'hrsh7th/cmp-nvim-lsp' },
        { 'hrsh7th/cmp-buffer' },
        { 'hrsh7th/cmp-path' },
        { 'hrsh7th/cmp-cmdline' },
    }
    local lsp_plugin_names = {}

    for i, item in ipairs(lsp_plugins) do
        use(item)
        local slash_index = item[1]:find('/')

        lsp_plugin_names[i] = item[1]:sub(slash_index+1)
    end

    use {
        'hrsh7th/nvim-cmp',
        after = lsp_plugin_names,
        config = function() require('lsp').setup() end,
    }
    -- End LSP Plugins


    -- Debugger protocol support
    use { 'mfussenegger/nvim-dap' }

    -- Linting + formatting
    -- use {
    --     'jose-elias-alvarez/null-ls.nvim',
    --     run = function()
    --         local null_ls = require('null-ls')
    --         null_ls.setup({
    --             sources = {
    --                 null_ls.builtins.formatting.stylua,
    --                 null_ls.builtins.diagnostics.eslint,
    --                 null_ls.builtins.completion.spell,
    --             }
    --         })
    --     end
    -- }

    -- use normal easymotion when in VIM mode
    use { 'easymotion/vim-easymotion', config = easymotionConfig }

    use { -- Treesitter
        'nvim-treesitter/nvim-treesitter',
        'HiPhish/nvim-ts-rainbow2',
        run = treesitterUpdate,
        config = treesitterConfig,
    }

    -- Better Syntax Support
    use { 'sheerun/vim-polyglot' }
    -- File Explorer
    use { 'scrooloose/NERDTree' }
    -- Auto pairs for '(' '[' '{'
    use {
        'jiangmiao/auto-pairs',
        config = function() vim.g.AutoPairsMapCh = 0 end,
    }

    use {
        'dracula/vim',
        as = 'dracula',
        config = function() vim.cmd.colorscheme('dracula') end,
    }

    use {
        'junegunn/fzf',
        run = ':call fzf#install()',
        config = function()
            vim.keymap.set('n', '<C-p>', '<cmd>FZF<cr>')
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
