return {
	"j-hui/fidget.nvim",

	opts = {
		progress = {
			suppress_on_insert = true,

			display = {
				render_limit = 4,
				progress_ttl = 30,

				format_message = function(msg)
					--require('fidget').logger.info(vim.inspect(msg))

					if msg["title"] == nil and msg["message"] == nil then
						return nil --ignore empty
					end

					if msg.message then
						return msg.message
					else
						return msg.done and "Completed" or "In Progress..."
					end
				end,
			},
		},

		notification = {
			override_vim_notify = true,

			window = {
				normal_hl = "String",
				winblend = 0,
				border = "rounded",
				align = "avoid_cursor",
			},
		},

		logger = {
			level = vim.log.levels.WARN,
		},
	},
}
