local has_tools, fs_tools = pcall(require, 'fs-tools')

local bufnr = vim.api.nvim_win_get_buf(0)

if has_tools then

    vim.keymap.set('n', '<leader>f', function ()
        fs_tools.edit_file_order({ float = true })
    end, { buffer = bufnr })

    vim.keymap.set('n', '<leader>o', function ()
        fs_tools.edit_file_order({ float = false })
    end, { buffer = bufnr })
end

vim.keymap.set('n', '<space>af', function ()
    vim.cmd([[!dotnet fantomas -r .]])
end, { buffer = bufnr, desc = "Format workspace with fantomas" })

--vim.bo.shiftwidth = 4
vim.cmd.compiler('dotnet')
