return {
	"akinsho/flutter-tools.nvim",
	lazy = true,
	ft = "dart",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"hrsh7th/cmp-nvim-lsp",
		--"stevearc/dressing.nvim", -- optional for vim.ui.select
	},

	config = function()
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		require("flutter-tools").setup({
			debugger = {
				enabled = true,
				run_via_dap = true,
			},
			lsp = {
				color = { enabled = true },
				capabilities = capabilities,
				on_attach = require("lsp").lsp_on_attach,
			},
		})
	end,
}
