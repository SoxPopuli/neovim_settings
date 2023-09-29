local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.fsharp = {
	install_info = {
		url = "https://github.com/Nsidorenco/tree-sitter-fsharp",
		branch = "develop",
		files = { "src/scanner.cc", "src/parser.c" },
		generate_requires_npm = true,
		requires_generate_from_grammar = true
	},
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
		'ocaml',
		'ocaml_interface',
		'ocamllex',
	},

	sync_install = false,

	highlight = {
		enable = true
	},
}

require('nvim-treesitter.configs').setup(setupConfig)

-- This module contains a number of default definitions
local rainbow_delimiters = require('rainbow-delimiters')

vim.g.rainbow_delimiters = {
    strategy = {
        [''] = rainbow_delimiters.strategy['global'],
        vim = rainbow_delimiters.strategy['local'],
    },
    query = {
        [''] = 'rainbow-delimiters',
        lua = 'rainbow-blocks',
    },
    highlight = {
        'RainbowDelimiterRed',
        'RainbowDelimiterYellow',
        'RainbowDelimiterBlue',
        'RainbowDelimiterOrange',
        'RainbowDelimiterGreen',
        'RainbowDelimiterViolet',
        'RainbowDelimiterCyan',
    },
}
