local has_tools, fs_tools = pcall(require, 'fs-tools')

if has_tools then
    local bufnr = vim.api.nvim_win_get_buf(0)

    vim.keymap.set('n', '<leader>f', function ()
        fs_tools.edit_file_order({ float = true })
    end, { buffer = bufnr })

    vim.keymap.set('n', '<leader>o', function ()
        fs_tools.edit_file_order({ float = false })
    end, { buffer = bufnr })
end
