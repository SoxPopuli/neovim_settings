local aerial = require("aerial")
aerial.setup({
   on_attach = function(bufnr)
      vim.keymap.set("n", "]a", function()
         aerial.next(1)
      end, { buffer = bufnr, nowait = true })
      vim.keymap.set("n", "[a", function()
         aerial.prev(1)
      end, { buffer = bufnr, nowait = true })

      vim.keymap.set("n", "<M-n>", function()
         aerial.next(1)
      end, { buffer = bufnr, nowait = true })
      vim.keymap.set("n", "<M-b>", function()
         aerial.prev(1)
      end, { buffer = bufnr, nowait = true })
   end,
   --filter_kind = false,
})

vim.keymap.set("n", "<Leader>a", function()
   aerial.toggle({
      focus = true,
      direction = "right",
   })
end)
