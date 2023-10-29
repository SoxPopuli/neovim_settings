-- @param args table
local function set_keybinds(args)
   local bufnr = args.buf
   local bind = vim.keymap.set

   bind('n', 'q', '<cmd>:q<cr>', { buffer = bufnr, nowait = true })
end

vim.api.nvim_create_autocmd({ 'FileType' }, {
   group = 'fugitive',
   pattern = 'fugitive',
   callback = set_keybinds
})
