local function get_window_position()
    local module = require("fidget.notification.window")

    -- editor cursor y = window y + (window current line - window first line)
    -- total drawable height = list_uis[1].height
    -- if editor y <= (drawable height / 2) then
    --   align bottom
    -- else
    --   align top

	local col, row, row_max
    local first_line = vim.fn.line("w0")
    local current_line = vim.api.nvim_win_get_cursor(0)[1]

	if module.options.relative == "editor" then
		col, row_max = module.get_editor_dimensions()

        local window_pos = vim.api.nvim_win_get_position(0)
        local cursor_pos = window_pos[1] + (current_line - first_line)

		if cursor_pos <= (row_max / 2) then
			row = row_max
		else
			-- When the layout is anchored at the top, need to check &tabline height
			local stal = vim.opt.showtabline:get()
			local tabline_shown = stal == 2 or (stal == 1 and #vim.api.nvim_list_tabpages() > 1)
			row = tabline_shown and 1 or 0
		end
	else -- fidget relative to "window" (currently unreachable)
        local cursor_pos = current_line - first_line

		col = vim.api.nvim_win_get_width(0)
		row_max = vim.api.nvim_win_get_height(0)
		if vim.fn.exists("+winbar") > 0 and vim.opt.winbar:get() ~= "" then
			-- When winbar is set, effective win height is reduced by 1 (see :help winbar)
			row_max = row_max - 1
		end

        if cursor_pos <= (row_max / 2) then
            row = row_max
        else
            row = 1
        end
	end

	col = math.max(0, col - module.options.x_padding - 0 --[[state.x_offset]])

	if module.options.align_bottom then
		row = math.max(0, row - module.options.y_padding)
	else
		row = math.min(row_max, row + module.options.y_padding)
	end

	return row, col, (module.options.align_bottom and "S" or "N") .. "E"
end

return {
	"j-hui/fidget.nvim",

	config = function(_, opts)
		local fidget = require("fidget")

		require("fidget.notification.window").get_window_position = get_window_position

		fidget.setup(opts)
	end,

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
				align_bottom = false,
			},
		},

		logger = {
			level = vim.log.levels.INFO,
		},
	},
}
