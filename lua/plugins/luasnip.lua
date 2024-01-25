---@return boolean | nil
local function jump_next()
  local luasnip = require('luasnip')

  if luasnip.expand_or_locally_jumpable(1) then
    return luasnip.expand_or_jump(1)
  end

  return nil
end
--
---@return boolean | nil
local function jump_prev()
  local luasnip = require('luasnip')

  if luasnip.locally_jumpable(-1) then
    return luasnip.jump(-1)
  end

  return nil
end

local function config()
  local luasnip = require('luasnip')

  vim.keymap.set({ 'i', 's' }, '<C-e>', function()
    if luasnip.choice_active() then
      luasnip.change_choice(1)
    end
  end)

  vim.keymap.set({ 'i', 's' }, '<C-n>', function()
    if not jump_next() then
      return '<C-n>'
    end
  end)

  vim.keymap.set({ 'i', 's' }, '<C-p>', function()
    if not jump_prev() then
      return '<C-p>'
    end
  end)

  vim.keymap.set({ 'i', 's' }, '<Tab>', function()
    if not jump_next() then
      return '<Tab>'
    end
  end, { expr = true })

  vim.keymap.set({ 'i', 's' }, '<S-Tab>', function()
    if not jump_prev() then
      return '<C-d>'
    end
  end, { expr = true })
end

return {
  'saadparwaiz1/cmp_luasnip',

  event = { 'InsertEnter' },

  dependencies = {
    'L3MON4D3/LuaSnip',
    'hrsh7th/cmp-nvim-lsp',
  },

  config = function()
    require('lsp.snippets').add_snippets()
    config()
  end,
}
