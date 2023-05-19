local M = {}
local dap = require('lsp.dap')

local lspconfig = require('lspconfig')
local cmp = require('cmp')
local rt = require('rust-tools')
local hints = require('inlay-hints')

local function lspOnAttach(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)

    -- hints.setup()
    -- hints.on_attach(client, bufnr)
end

function M.setup()

  cmp.setup({
      snippet = {
          expand = function(args)
              vim.fn["UltiSnips#Anon"](args.body)
          end,
      },
      window = {

      },
      mapping = cmp.mapping.preset.insert({
              ['<C-b>'] = cmp.mapping.scroll_docs(-4),
              ['<C-f>'] = cmp.mapping.scroll_docs(4),
              ['<C-space>'] = cmp.mapping.complete(),
              ['<C-e>'] = cmp.mapping.abort(),
              ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item

              ['<tab>'] = cmp.mapping.select_next_item(),
              ['<S-tab>'] = cmp.mapping.select_prev_item(),

              ['<Down>'] = cmp.mapping.select_next_item(),
              ['<Up>'] = cmp.mapping.select_prev_item(),
      }),
      sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'ultisnips' }
      }, {
          { name = 'buffer' }
      })
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })


  -- Set up lspconfig.
  local capabilities = require('cmp_nvim_lsp').default_capabilities()

  -- Setup Installer
  require('mason').setup()
  require('mason-lspconfig').setup({
      ensure_installed = { 
        'lua_ls',
        'rust_analyzer',
        'elmls',
        'jsonls',
        'html',
        'fsautocomplete',
      }
  })

  rt.setup({
      server = {
        on_attach = function (client, bufnr)
          -- Hover actions
          vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
          -- Code action groups
          vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })

          lspOnAttach(client, bufnr)
        end
      }
  })

  -- vim.api.nvim_create_autocmd({'BufEnter', 'BufWinEnter'}, {
  --     pattern = '*.rs',
  --     callback = function() rt.inlay_hints.set() end,
  -- })

  -- lspconfig.rust_analyzer.setup {
  --     settings = {
  --         ['rust-analyzer'] = {},
  --     },
  --     capabilities = capabilities,
  --     on_attach = function() rt.inlay_hints.enable() end,
  -- }

  local function defaultSetup(server)
    server.setup({
        on_attach = lspOnAttach,
        flags = {
          debounce_text_changes = 300,
        },
        capabilities = capabilities
    })
  end

  -- require('ionide').setup({
  --     on_attach = lspOnAttach,
  --     capabilities = capabilities,
  -- })
lspconfig.fsautocomplete.setup({
    on_attach = lspOnAttach,
    capabilities = capabilities,
})


  defaultSetup(lspconfig.jsonls)
  defaultSetup(lspconfig.elmls)
  defaultSetup(lspconfig.html)

  lspconfig.lua_ls.setup{
    on_attach = lspOnAttach,
    settings = {
      filetypes = { 'lua' },
      Lua = {
        hint = { enable = true },
        runtime = { version = 'LuaJIT' },
        diagnostics = { globals = { 'vim' } },
        semantic = { enable = false }, -- Disable semantic highlighting, treesitter is better imo
        capabilities = capabilities,
      }
    }
  }


  -- Manually refresh codelens for every fsharp buffer
  -- except the first one opened, as they won't refresh
  -- on their own
  FsFirstBuffer = nil
  vim.api.nvim_create_autocmd({"LspAttach"}, {
      pattern = { "*.fs" },
      callback = function(ev)
        if FsFirstBuffer == nil then
          FsFirstBuffer = ev.buf
        end
      end
  })

  vim.api.nvim_create_autocmd({"TextChanged", "InsertLeave"}, {
  -- vim.api.nvim_create_autocmd({"BufWrite"}, {
      pattern = { "*.fs" },
      callback = function(ev)
        if ev.buf ~= FsFirstBuffer then
          vim.lsp.codelens.refresh()
        end
      end
  })

  -- Global mappings.
  -- See `:help vim.diagnostic.*` for documentation on any of the below functions
  vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
  vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

end

return M
