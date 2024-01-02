return {
  'iamcco/markdown-preview.nvim',

  keys = {
    { '<leader>mp', '<cmd>:MarkdownPreview<cr>' },
    { '<leader>ms', '<cmd>:MarkdownPreviewStop<cr>' },
    { '<leader>mt', '<cmd>:MarkdownPreviewToggle<cr>' },
  },

  cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
  build = 'cd app && yarn install',
  init = function()
    vim.g.mkdp_filetypes = { 'markdown' }
    vim.g.mkdp_browser = 'firefox'
  end,
  ft = { 'markdown' },
}
