local M = {}

function M.setup()
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

	vim.cmd('hi TSRainbowBlue ctermfg=cyan') -- set blue to cyan for more visibility
end


return M
