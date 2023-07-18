local lualine = require('lualine')

local filename = {
    'filename',
    file_status = true,
    newfile_status = true,
    path = 1,
}

lualine.setup({
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { filename },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { filename },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
    },
    options = {
        theme = "auto",
        icons_enabled = false,
        section_separators = {
            left = " ",
            right = " ",
        },
        component_separators = {
            left = "│",
            right = "│",
        },
    },
})
