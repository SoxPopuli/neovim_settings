return {
  'aserowy/tmux.nvim',

  keys = {
    {
      '<A-h>',
      function()
        require('tmux').move_left()
      end,
    },
    {
      '<A-j>',
      function()
        require('tmux').move_bottom()
      end,
    },
    {
      '<A-k>',
      function()
        require('tmux').move_top()
      end,
    },
    {
      '<A-l>',
      function()
        require('tmux').move_right()
      end,
    },

    {
      '<C-h>',
      function()
        require('tmux').resize_left()
      end,
    },
    {
      '<C-j>',
      function()
        require('tmux').resize_bottom()
      end,
    },
    {
      '<C-k>',
      function()
        require('tmux').resize_top()
      end,
    },
    {
      '<C-l>',
      function()
        require('tmux').resize_right()
      end,
    },
  },

  opts = {
    copy_sync = { enable = false },
    navigation = { enable_default_keybindings = false },
    resize = { enable_default_keybindings = false },
  },
}
