local luasnip = require('luasnip')

vim.keymap.set('s', '<Tab>', function()
  if luasnip.expand_or_jumpable() then
    luasnip.expand_or_jump()
  else
    return '<Tab>'
  end
end, { expr = true })

vim.keymap.set('i', '<Tab>', function()
  if luasnip.jumpable() then
    luasnip.jump(1)
  else
    return '<Tab>'
  end
end, { expr = true })

vim.keymap.set('i', '<S-Tab>', function()
  if luasnip.jumpable() then
    luasnip.jump(-1)
  else
    return '<C-d>'
  end
end, { expr = true })
