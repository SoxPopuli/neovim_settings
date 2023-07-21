vim.api.nvim_create_autocmd({'BufRead', 'BufNewFile' }, {
    pattern = { '*.fs', '*.fsx', '*.fsi' },
    callback = function (_)
        vim.bo.filetype = 'fsharp'
    end
})
