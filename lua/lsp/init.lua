local M = {}
local dap = require('lsp.dap')
local snippets = require('lsp.snippets')

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

local function MasonInstallList(list)
  local pack = require('mason-core.package')
  local registry = require('mason-registry')

  for _, name in pairs(list) do
    local pkg_name, pkg_ver = pack.Parse(name)
    local pkg = registry.get_package(pkg_name)
    if pkg:is_installed() == false then
      print('Installing ' .. pkg_name)
      pkg:install({ version = pkg_ver })
    end
  end
end

function M.setup()
  local comp = cmp.config.compare
  cmp.setup({
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
      end,
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-space>'] = cmp.mapping.complete(),
      ['<C-c>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item

      ['<tab>'] = cmp.mapping.select_next_item(),
      ['<S-tab>'] = cmp.mapping.select_prev_item(),

      ['<Down>'] = cmp.mapping.select_next_item(),
      ['<Up>'] = cmp.mapping.select_prev_item(),
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp_signature_help', priority = 10 },
      { name = 'nvim_lsp',                priority = 5 },
      { name = 'luasnip',                 priority = 1 },
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

  -- Global mappings.
  -- See `:help vim.diagnostic.*` for documentation on any of the below functions
  vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
  vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

  -- Setup custom snippets - only once though
  if SnippetsInit ~= true then
    snippets.addSnippets()
    SnippetsInit = true
  end

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
      'lemminx',
      'fsautocomplete',
      'yamlls',
    }
  })

  MasonInstallList({
    -- DAP Providers
    'netcoredbg',

    -- Linters
    'fantomas',
  })

  rt.setup({
    server = {
      on_attach = function(client, bufnr)
        -- Hover actions
        vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
        -- Code action groups
        vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })

        lspOnAttach(client, bufnr)
      end
    }
  })

  local function defaultSetup(server)
    server.setup({
      on_attach = lspOnAttach,
      flags = {
        debounce_text_changes = 300,
      },
      capabilities = capabilities
    })
  end

  lspconfig.fsautocomplete.setup({
    on_attach = function(client, bufnr)
      lspOnAttach(client, bufnr)

      vim.api.nvim_create_autocmd({ "TextChanged", "InsertLeave", "BufEnter", "CursorHold" }, {
        callback = function(_)
          vim.lsp.codelens.refresh()
        end,
        buffer = bufnr,
      })

      vim.cmd('hi link LspCodeLens Type')
    end,
    capabilities = capabilities,
    settings = {
      FSharp = {
        keywordsAutocomplete = false,
        ExternalAutocomplete = false,

        Linter = true,

        UnionCaseStubGeneration = true,
        UnionCaseStubGenerationBody = 'failwith "todo"',

        RecordStubGeneration = true,
        RecordStubGenerationBody = 'failwith "todo"',

        InterfaceStubGeneration = true,
        InterfaceStubGenerationBody = 'failwith "todo"',
        InterfaceStubGenerationObjectIdentifier = 'this',

        ResolveNamespaces = true,
        SimplifyNameAnalyzer = true,

        UnusedOpensAnalyzer = true,
        UnusedDeclarationsAnalyzer = true,
      }
    },
  })

  lspconfig.lemminx.setup({
    on_attach = lspOnAttach,
    capabilities = capabilities,
    settings = {
      xml = {
        completion = { autoCloseTags = true },
        validation = { noGrammar = "ignore" }
      }
    },
  })

  defaultSetup(lspconfig.jsonls)
  defaultSetup(lspconfig.elmls)
  defaultSetup(lspconfig.html)
  defaultSetup(lspconfig.yamlls)

  lspconfig.lua_ls.setup {
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

  local codelens = require('vim.lsp.codelens')
  local old_on_codelens = codelens.on_codelens

  local function resolve_lenses(lenses, bufnr, client_id, callback)
    lenses = lenses or {}
    local num_lens = vim.tbl_count(lenses)
    if num_lens == 0 then
      callback()
      return
    end

    ---@private
    local function countdown()
      num_lens = num_lens - 1
      if num_lens == 0 then
        callback()
      end
    end

    local client = vim.lsp.get_client_by_id(client_id)
    for _, lens in pairs(lenses or {}) do
      if lens.command then
        countdown()
      else
        client.request('codeLens/resolve', lens, function(_, result)
          if result and result.command then
            lens.command = result.command
          end
          countdown()
        end, bufnr)
      end
    end
  end

  -- Explicitly resolve code lenses before display
  codelens.on_codelens = function(err, result, ctx, a)
    if err then
      old_on_codelens(err, result, ctx, a)
    end

    resolve_lenses(result, ctx.bufnr, ctx.client_id, function()
      -- codelens.display(result, ctx.bufnr, ctx.client_id)

      old_on_codelens(err, result, ctx, a)
    end)
  end
end

return M
