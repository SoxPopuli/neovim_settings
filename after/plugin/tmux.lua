local tmux = require('tmux')
tmux.setup({
  copy_sync = { enable = false },
  navigation = { enable_default_keybindings = false },
  resize = { enable_default_keybindings = false },
})

local map = function(key, fn)
  vim.keymap.set('n', key, fn, { remap = false })
end

map('<A-h>', tmux.move_left)
map('<A-j>', tmux.move_bottom)
map('<A-k>', tmux.move_top)
map('<A-l>', tmux.move_right)

map('<C-h>', tmux.resize_left)
map('<C-j>', tmux.resize_bottom)
map('<C-k>', tmux.resize_top)
map('<C-l>', tmux.resize_right)
