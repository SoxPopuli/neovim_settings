local tmux = require("tmux")
tmux.setup({
    copy_sync = { enable = false },
    navigation = { enable_default_keybindings = false },
    resize = { enable_default_keybindings = false },
})

vim.keymap.set("n", "<A-h>", function()
    tmux.move_left()
end, { remap = false })
vim.keymap.set("n", "<A-j>", function()
    tmux.move_bottom()
end, { remap = false })
vim.keymap.set("n", "<A-k>", function()
    tmux.move_top()
end, { remap = false })
vim.keymap.set("n", "<A-l>", function()
    tmux.move_right()
end, { remap = false })

vim.keymap.set("n", "<C-h>", function()
    tmux.resize_left()
end, { remap = false })
vim.keymap.set("n", "<C-j>", function()
    tmux.resize_bottom()
end, { remap = false })
vim.keymap.set("n", "<C-k>", function()
    tmux.resize_top()
end, { remap = false })
vim.keymap.set("n", "<C-l>", function()
    tmux.resize_right()
end, { remap = false })
