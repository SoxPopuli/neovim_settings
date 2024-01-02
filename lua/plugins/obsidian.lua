local personal_vault = vim.fn.expand('~') .. '/vaults/personal/'
local work_vault = vim.fn.expand('~') .. '/vaults/work/'

local join = require('misc').string_join

return {
  'epwalsh/obsidian.nvim',
  version = '*', -- recommended, use latest release instead of latest commit
  lazy = true,

  cmd = {
    'ObsidianNew',
    'ObsidianLink',
    'ObsidianOpen',
    'ObsidianCheck',
    'ObsidianToday',
    'ObsidianRename',
    'ObsidianSearch',
    'ObsidianLinkNew',
    'ObsidianPasteImg',
    'ObsidianTemplate',
    'ObsidianTomorrow',
    'ObsidianBacklinks',
    'ObsidianWorkspace',
    'ObsidianYesterday',
    'ObsidianFollowLink',
    'ObsidianQuickSwitch',
  },

  --ft = "markdown",
  event = {
    -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"

    join({ 'BufReadPre ', personal_vault, '**.md' }),
    join({ 'BufNewFile ', personal_vault, '**.md' }),

    join({ 'BufReadPre ', work_vault, '**.md' }),
    join({ 'BufNewFile ', work_vault, '**.md' }),
  },

  dependencies = {
    -- Required.
    'nvim-lua/plenary.nvim',
    'hrsh7th/nvim-cmp',
    'nvim-telescope/telescope.nvim',
  },
  opts = {
    workspaces = {
      {
        name = 'personal',
        path = '~/vaults/personal',
      },
      {
        name = 'work',
        path = '~/vaults/work',
      },
    },

    completion = {
      nvim_cmp = true,
      min_chars = 2,
    },

    finder = 'telescope.nvim',
    disable_frontmatter = true,
  },
}
