local M = {}

function M.install_lazy()
  local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/folke/lazy.nvim.git',
      '--branch=stable',
      lazypath,
    })
  end

  vim.opt.rtp:prepend(lazypath)
end

local plugins = {
  -- TODO: migrate to plugins folder
  { import = 'plugins' },

  'nvim-lualine/lualine.nvim',

  'tpope/vim-surround',
  'tpope/vim-repeat',

  'preservim/nerdcommenter',
  { 'dracula/vim', name = 'dracula', lazy = true, priority = 1000 },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false,
    priority = 1000,
    config = function ()
        vim.cmd.colorscheme('catppuccin-mocha')
    end
  },
  { 'scalameta/nvim-metals', dependencies = { 'nvim-lua/plenary.nvim' }, ft = 'scala' },

  'neovim/nvim-lspconfig',
  { 'williamboman/mason.nvim', build = ':MasonUpdate' },
  'williamboman/mason-lspconfig.nvim',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-cmdline',
  { 'simrat39/rust-tools.nvim', ft = 'rust' },

  --{
  --    'ionide/Ionide-vim',
  --    config = function()
  --        vim.g['fsharp#backend'] = 'disable'
  --        vim.g['fsharp#lsp_auto_setup'] = 0
  --        vim.g['fsharp#lsp_codelens'] = 0
  --        vim.g['fsharp#use_recommended_server_config'] = 0
  --    end
  --},

  'simrat39/inlay-hints.nvim',
  -- use { 'lvimuser/lsp-inlayhints.nvim' }

  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-nvim-lsp-signature-help',

  {
    'mbbill/undotree',
    keys = {
      {
        '<leader>u',
        function()
          vim.cmd.UndotreeToggle()
        end,
        desc = 'Toggle Undotree',
      },
    },
  },

  -- Debugger protocol support
  'mfussenegger/nvim-dap',
  { 'rcarriga/nvim-dap-ui', dependencies = { 'mfussenegger/nvim-dap' } },

  -- Treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    build = function()
      local tsUpdate = require('nvim-treesitter.install').update({ with_sync = true })
      tsUpdate()
    end,
  },

  { 'HiPhish/rainbow-delimiters.nvim', dependencies = { 'nvim-treesitter/nvim-treesitter' } },
  --use({ "~/Code/lua/rainbow-delimiters.nvim", dependencies = { "nvim-treesitter/nvim-treesitter" } })

  { 'SoxPopuli/fsharp-tools.nvim', ft = 'fsharp' },

  -- Outline view: LSP / Treesitter driven
  'stevearc/aerial.nvim',

  -- Better Syntax Support
  'sheerun/vim-polyglot',

  -- Auto pairs for '(' '[' '{'
  {
    'windwp/nvim-autopairs',
    dependencies = 'hrsh7th/nvim-cmp',
  },
  -- If you want insert `(` after select function or method item

  -- Async linting
  'mfussenegger/nvim-lint',

  {
    'lukas-reineke/indent-blankline.nvim',
    version = 'v2.20.8',
  },

  { 'nvim-tree/nvim-web-devicons', lazy = true },
  { 'rescript-lang/vim-rescript', ft = 'rescript' },
}

function M.startup()
  require('lazy').setup(plugins, {
    checker = {
      enabled = true,
      frequency = 86400, -- Once per day
    },
  })
end

return M
