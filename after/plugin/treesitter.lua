local rainbow = require('ts-rainbow')

local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.fsharp = {
	install_info = {
		url = "https://github.com/Nsidorenco/tree-sitter-fsharp",
		branch = "develop",
		files = { "src/scanner.cc", "src/parser.c" },
		generate_requires_npm = true,
		requires_generate_from_grammar = true },
	filetype = "fsharp",
}

local setupConfig = {
	ensure_installed = {
		'fsharp',
		'rust',
		'lua',
		'vim',
		'c_sharp',
		'elm',
		'json',
		'latex',
		'markdown',
		'regex',
		'scala',
		'yaml',
	},

	sync_install = false,

	highlight = {
		enable = true
	},

	rainbow = {
		enable = true,
		query = 'rainbow-parens',
		strategy = {
			rainbow.strategy.global7
		}
	}
}

require('nvim-treesitter.configs').setup(setupConfig)

-- Rainbow colors (All at 60% saturation)
-- vim.cmd('hi TSRainbowRed guifg=#cc3333')
-- vim.cmd('hi TSRainbowOrange guifg=#cc8033')
-- vim.cmd('hi TSRainbowYellow guifg=#cccc33')
-- vim.cmd('hi TSRainbowGreen guifg=#33cc33')
-- vim.cmd('hi TSRainbowCyan guifg=#33cccc')
-- vim.cmd('hi TSRainbowBlue guifg=#3333cc')
-- vim.cmd('hi TSRainbowViolet guifg=#cc33cc')
