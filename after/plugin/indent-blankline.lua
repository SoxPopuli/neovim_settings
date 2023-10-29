require('indent_blankline').setup({
   -- enabled = false,
   show_current_context = false,
   show_current_context_start = false,
   char_blankline = '┆',
})

vim.keymap.set('n', '<leader>id', function()
   vim.cmd('IndentBlanklineDisable')
   vim.cmd('IndentBlanklineDisable!')
end)
vim.keymap.set('n', '<leader>ie', function()
   vim.cmd('IndentBlanklineEnable')
   vim.cmd('IndentBlanklineEnable!')
end)
vim.keymap.set('n', '<leader>it', function()
   vim.cmd('IndentBlanklineToggle')
   vim.cmd('IndentBlanklineToggle!')
end)
vim.keymap.set('n', '<leader>il', function() vim.cmd('IndentBlanklineToggle') end)
vim.keymap.set('n', '<leader>ir', function() vim.cmd('IndentBlanklineRefresh') end)
