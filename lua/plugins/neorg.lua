return {
	"nvim-neorg/neorg",
	ft = "norg",
	cmd = "Neorg",
	dependencies = {
		"hrsh7th/nvim-cmp",
		"nvim-treesitter/nvim-treesitter",
		"nvim-lua/plenary.nvim",
		"nvim-neorg/neorg-telescope",
	},

	build = ":Neorg sync-parsers",
	opts = {
		load = {
			["core.defaults"] = {},
			["core.dirman"] = {
				config = {
					workspaces = {
						work = "~/notes/work",
						home = "~/notes/home",
					},
				},
			},
			["core.completion"] = { config = { engine = "nvim-cmp" } },
			["core.concealer"] = {},
			--["core.integrations.telescope"] = {},
		},
	},
}
