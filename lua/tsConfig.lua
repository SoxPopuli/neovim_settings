local M = {}

function M.setup()
	local rainbow = require('ts-rainbow')

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
		},

		sync_install = false,

		highlight = {
			enable = true
		},

		rainbow = {
			enable = true,
			query = 'rainbow-parens',
			strategy = {
				rainbow.strategy.global,

				fsharp = rainbow.strategy["local"],
			}
		}
	}

	require('nvim-treesitter.configs').setup(setupConfig)

	vim.cmd('hi TSRainbowBlue ctermfg=cyan') -- set blue to cyan for more visibility
end

return M
