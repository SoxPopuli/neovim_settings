local plugins = {}

local configPath = vim.fn.stdpath('config')
local dataPath = vim.fn.stdpath('data')

local packerPath = dataPath .. [[/site/pack/packer/start/packer.nvim]]

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
end

local function packerStartup(use)
    use 'wbthomason/packer.nvim'

    use 'tpope/vim-surround'
    use 'tpope/vim-repeat'

    use {
        'preservim/nerdcommenter',
    }

    if vim.g.vscode == nil then -- load non vscode extentions
        use { 'neovim/nvim-lspconfig' }

        -- use normal easymotion when in VIM mode
        use { 'easymotion/vim-easymotion', config = easymotionConfig }

        use {
            'HiPhish/nvim-ts-rainbow2',
            -- after = 'nvim-treesitter'
        }

        use { -- Treesitter
            'nvim-treesitter/nvim-treesitter',
            run = treesitterUpdate,
            config = treesitterConfig,
        }


        -- Better Syntax Support
        use 'sheerun/vim-polyglot'
        -- File Explorer
        use 'scrooloose/NERDTree'
        -- Auto pairs for '(' '[' '{'
        use {
            'jiangmiao/auto-pairs',
            config = function() vim.g.AutoPairsMapCh = 0 end
        }

        use { 'dracula/vim', as = 'dracula' }
    else
        use {
            'asvetliakov/vim-easymotion',
            as = 'vsc-easymotion',
            config = easymotionConfig
        }
    end

    -- Keep at end - downloads updates
    if plugins.CheckPackerExists() then
        require('packer').sync()
    end
end

plugins.packer = require('packer').startup(packerStartup)

return plugins
