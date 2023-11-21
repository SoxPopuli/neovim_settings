local misc = require("misc")

local formatter_path = misc.buildPath({
	vim.fn.stdpath("data"),
	"mason",
	"bin",
})

local function path(name)
	return misc.buildPath({ formatter_path, name })
end

return {
	"stevearc/conform.nvim",
	lazy = true,
	opts = {
		formatters = {
			fantomas = {
				command = path("fantomas"),
                args = { '$FILENAME' },
			},
		},

		formatters_by_ft = {
			lua = { "stylua" },
			--fsharp = { "fantomas" },
		},
	},
}
