local treesitter = {}
local rainbow = require('ts-rainbow')

local setupConfig = {
    ensure_installed = {
        'rust',
        'lua',
        'vim',
        'c_sharp',
        'elm',
        'json',
        'latex',
        'markdown',
        'regex',
    },

    sync_install = true,

    highlight = {
        enable = true
    },

    rainbow = {
        enable = true,
        query = 'rainbow-parens',
        strategy = rainbow.strategy.global
    }
}
require('nvim-treesitter.configs').setup(setupConfig)

return treesitter
