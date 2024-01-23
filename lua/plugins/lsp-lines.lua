local lines_config = {
  highlight_whole_line = false,
  only_current_line = true,
}

return {
  --url = 'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
  url = 'https://github.com/ErichDonGubler/lsp_lines.nvim.git',
  name = 'lsp_lines',

  dependencies = {
    'neovim/nvim-lspconfig',
  },

  event = { 'LspAttach' },

  enabled = true,

  config = function()
    vim.diagnostic.config({
      virtual_text = true,
      virtual_lines = lines_config,
    })

    require('lsp_lines').setup()

    vim.keymap.set('', '<Leader>l', function()
      if vim.diagnostic.config().virtual_lines == false then
        vim.diagnostic.config({ virtual_lines = lines_config })
      else
        vim.diagnostic.config({ virtual_lines = false })
      end
    end, { desc = 'Toggle lsp_lines' })
  end,
}
