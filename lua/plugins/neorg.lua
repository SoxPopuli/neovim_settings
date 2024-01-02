return {
	"nvim-neorg/neorg",
	ft = "neorg",
	cmd = "Neorg",
	dependencies = {
		"hrsh7th/nvim-cmp",
		"nvim-treesitter/nvim-treesitter",
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
		},
	},
}
