return {
	"johmsalas/text-case.nvim",
	dependencies = "nvim-telescope/telescope.nvim",
	lazy = true,
	keys = {
		{ "ga.", "<cmd>TextCaseOpenTelescope<CR>", mode = "n", desc = "Telescope" },
		{ "ga.", "<cmd>TextCaseOpenTelescope<CR>", mode = "v", desc = "Telescope" },
		{ "gaa", "<cmd>TextCaseOpenTelescopeQuickChange<CR>", desc = "Telescope Quick Change" },
		{ "gai", "<cmd>TextCaseOpenTelescopeLSPChange<CR>", desc = "Telescope LSP Change" },

        { "gau", function() require('textcase').current_word('to_upper_case') end, desc = "To upper case" },
        { "gal", function() require('textcase').current_word('to_lower_case') end, desc = "To lower case" },
        { "gas", function() require('textcase').current_word('to_snake_case') end, desc = "To snake case" },
        { "gad", function() require('textcase').current_word('to_dash_case') end, desc = "To dash case" },
        { "gan", function() require('textcase').current_word('to_constant_case') end, desc = "To constant case" },
        { "gad", function() require('textcase').current_word('to_dot_case') end, desc = "To dot case" },
        { "gaa", function() require('textcase').current_word('to_phrase_case') end, desc = "To phrase case" },
        { "gac", function() require('textcase').current_word('to_camel_case') end, desc = "To camel case" },
        { "gap", function() require('textcase').current_word('to_pascal_case') end, desc = "To pascal case" },
        { "gat", function() require('textcase').current_word('to_title_case') end, desc = "To title case" },
        { "gaf", function() require('textcase').current_word('to_path_case') end, desc = "To path case" },

        { "gaU", function() require('textcase').lsp_rename('to_upper_case') end, desc = "LSP: to upper case" },
        { "gaL", function() require('textcase').lsp_rename('to_lower_case') end, desc = "LSP: to lower case" },
        { "gaS", function() require('textcase').lsp_rename('to_snake_case') end, desc = "LSP: to snake case" },
        { "gaD", function() require('textcase').lsp_rename('to_dash_case') end, desc = "LSP: to dash case" },
        { "gaN", function() require('textcase').lsp_rename('to_constant_case') end, desc = "LSP: to constant case" },
        { "gaD", function() require('textcase').lsp_rename('to_dot_case') end, desc = "LSP: to dot case" },
        { "gaA", function() require('textcase').lsp_rename('to_phrase_case') end, desc = "LSP: to phrase case" },
        { "gaC", function() require('textcase').lsp_rename('to_camel_case') end, desc = "LSP: to camel case" },
        { "gaP", function() require('textcase').lsp_rename('to_pascal_case') end, desc = "LSP: to pascal case" },
        { "gaT", function() require('textcase').lsp_rename('to_title_case') end, desc = "LSP: to title case" },
        { "gaF", function() require('textcase').lsp_rename('to_path_case') end, desc = "LSP: to path case" },

        { "geu", function() require('textcase').operator('to_upper_case') end, desc = "Operator: to upper case" },
        { "gel", function() require('textcase').operator('to_lower_case') end, desc = "Operator: to lower case" },
        { "ges", function() require('textcase').operator('to_snake_case') end, desc = "Operator: to snake case" },
        { "ged", function() require('textcase').operator('to_dash_case') end, desc = "Operator: to dash case" },
        { "gen", function() require('textcase').operator('to_constant_case') end, desc = "Operator: to constant case" },
        { "ged", function() require('textcase').operator('to_dot_case') end, desc = "Operator: to dot case" },
        { "gea", function() require('textcase').operator('to_phrase_case') end, desc = "Operator: to phrase case" },
        { "gec", function() require('textcase').operator('to_camel_case') end, desc = "Operator: to camel case" },
        { "gep", function() require('textcase').operator('to_pascal_case') end, desc = "Operator: to pascal case" },
        { "get", function() require('textcase').operator('to_title_case') end, desc = "Operator: to title case" },
        { "gef", function() require('textcase').operator('to_path_case') end, desc = "Operator: to path case" },
	},

	config = function()
		require("telescope").load_extension("textcase")

		require("textcase").setup({
			default_keymappings_enabled = false,
		})
	end,
}

