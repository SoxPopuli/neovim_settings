return {
  'pwntester/octo.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    'nvim-tree/nvim-web-devicons',
  },
  opts = {
    use_local_fs = true,

    ssh_aliases = {
      ['github.com-TM'] = 'github.com',
    },

    mappings = {},
  },

  cmd = {
    'Octo',
  },
}
