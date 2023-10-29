local M = {}

function M.install_lazy()
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

    if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({
            "git",
            "clone",
            "--filter=blob:none",
            "https://github.com/folke/lazy.nvim.git",
            "--branch=stable",
            lazypath,
        })
    end

    vim.opt.rtp:prepend(lazypath)
end

local plugins = {
    "nvim-lualine/lualine.nvim",
    {
        "j-hui/fidget.nvim",
        branch = "legacy",
        config = function()
            require("fidget").setup({
                text = { spinner = "bouncing_ball" }
            })
        end,
    },

    "tpope/vim-surround",
    "tpope/vim-repeat",

    "preservim/nerdcommenter",

    { "dracula/vim",           name = "dracula",                           lazy = true, priority = 1000 },
    { "catppuccin/nvim",       name = "catppuccin",                        lazy = false, priority = 1000 },
    { "scalameta/nvim-metals", dependencies = { "nvim-lua/plenary.nvim" }, ft = "scala" },

    "neovim/nvim-lspconfig",
    { "williamboman/mason.nvim", build = ":MasonUpdate" },
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "simrat39/rust-tools.nvim",

    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",

    --{
    --    'ionide/Ionide-vim',
    --    config = function()
    --        vim.g['fsharp#backend'] = 'disable'
    --        vim.g['fsharp#lsp_auto_setup'] = 0
    --        vim.g['fsharp#lsp_codelens'] = 0
    --        vim.g['fsharp#use_recommended_server_config'] = 0
    --    end
    --},

    "simrat39/inlay-hints.nvim",
    -- use { 'lvimuser/lsp-inlayhints.nvim' }

    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp-signature-help",

    {
        "mbbill/undotree",
        config = function()
            vim.keymap.set("n", "<leader>u", function()
                vim.cmd.UndotreeToggle()
            end)
        end,
    },

    {
        "tpope/vim-fugitive",
        config = function()
            vim.keymap.set("n", "<leader>g", function()
                vim.cmd.Git()
            end)
        end,
    },

    -- Debugger protocol support
    "mfussenegger/nvim-dap",
    { "rcarriga/nvim-dap-ui",    dependencies = { "mfussenegger/nvim-dap" } },

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = function()
            local tsUpdate = require("nvim-treesitter.install").update({ with_sync = true })
            tsUpdate()
        end,
    },

    { "HiPhish/rainbow-delimiters.nvim", dependencies = { "nvim-treesitter/nvim-treesitter" } },
    --use({ "~/Code/lua/rainbow-delimiters.nvim", dependencies = { "nvim-treesitter/nvim-treesitter" } })

    { "SoxPopuli/fsharp-tools.nvim",     ft = "fsharp" },

    -- Outline view: LSP / Treesitter driven
    "stevearc/aerial.nvim",

    -- Better Syntax Support
    "sheerun/vim-polyglot",
    -- File Explorer
    "nvim-tree/nvim-tree.lua",

    -- Auto pairs for '(' '[' '{'
    {
        "windwp/nvim-autopairs",
        dependencies = "hrsh7th/nvim-cmp",
    },
    -- If you want insert `(` after select function or method item

    -- tmux integration
    "aserowy/tmux.nvim",

    {
        "jose-elias-alvarez/null-ls.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local null_ls = require("null-ls")
            null_ls.setup({
                sources = {
                    null_ls.builtins.formatting.fantomas,
                    null_ls.builtins.formatting.prettier,
                },
            })
        end,
    },

    -- Async linting
    'mfussenegger/nvim-lint',

    {
        'lukas-reineke/indent-blankline.nvim',
        version = 'v2.20.8',
    },

    {
        'ldelossa/gh.nvim',
        dependencies = { { 'ldelossa/litee.nvim' } }
    },


    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = { { 'nvim-lua/plenary.nvim' } }
    },

    { 'nvim-telescope/telescope-ui-select.nvim', dependencies = { 'nvim-telescope/telescope.nvim' } },
{     'nvim-tree/nvim-web-devicons', lazy = true },
    { 'johmsalas/text-case.nvim',                dependencies = { 'nvim-telescope/telescope.nvim' } },
    { 'rescript-lang/vim-rescript',              ft = 'rescript' },

}

function M.startup()
    require("lazy").setup(plugins, {
        checker = {
            enabled = true,
            frequency = 86400, -- Once per day
        },
    })
end

return M
