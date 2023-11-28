return {
    'johmsalas/text-case.nvim',
    dependencies = 'nvim-telescope/telescope.nvim',
    lazy = true,
    keys = {
        { 'ga.', '<cmd>TextCaseOpenTelescope<CR>',            mode = 'n',                     desc = "Telescope" },
        { 'ga.', "<cmd>TextCaseOpenTelescope<CR>",            mode = 'v',                     desc = "Telescope" },
        { 'gaa', "<cmd>TextCaseOpenTelescopeQuickChange<CR>", desc = "Telescope Quick Change" },
        { 'gai', "<cmd>TextCaseOpenTelescopeLSPChange<CR>",   desc = "Telescope LSP Change" },
    },

    config = function()
        require('telescope').load_extension('textcase')

        require('textcase').setup({})
    end,
}
