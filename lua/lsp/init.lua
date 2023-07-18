local M = {}
local dap = require('lsp.dap')
local snippets = require('lsp.snippets')

local lspconfig = require('lspconfig')
local cmp = require('cmp')
local rt = require('rust-tools')
local hints = require('inlay-hints')

local function apply_formatting(bufnr)
  vim.lsp.buf.format({
    filter = function(client)
      -- Apply formatting logic here
      local filetypes = {
        typescript = "tsserver",
        fsharp = "null-ls",
      }

      local ft = vim.bo.filetype
      -- Use formatter for filetype if specified, else use any formatter available
      if filetypes[ft] ~= nil then
        return filetypes[ft] == client.name
      else
        return true
      end
    end,
    bufnr = bufnr,
    async = true,
  })
end

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
  -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts)
  vim.keymap.set('n', '<space>wq', vim.lsp.buf.workspace_symbol, opts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  vim.keymap.set('n', '<space>f', function()
    apply_formatting(bufnr)
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

local function setupCmp()
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
end

local function setupKeys()
  -- Global mappings.
  -- See `:help vim.diagnostic.*` for documentation on any of the below functions
  vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
  vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)
end

local function codelensFix()
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
  return function(err, result, ctx, a)
    if err then
      old_on_codelens(err, result, ctx, a)
      return
    end

    resolve_lenses(result, ctx.bufnr, ctx.client_id, function()
      old_on_codelens(err, result, ctx, a)
    end)
  end
end

-- Scala LSP
local function setupScala(capabilities)
  local metals_config = require('metals').bare_config()
  metals_config.settings = {
    showImplicitArguments = true,
    excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
  }
  metals_config.capabilities = capabilities
  metals_config.on_attach = function(_, _)
    require('metals').setup_dap()
  end

  -- Autocmd that will actually be in charging of starting the whole thing
  local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    -- NOTE: You may or may not want java included here. You will need it if you
    -- want basic Java support but it may also conflict if you are using
    -- something like nvim-jdtls which also works on a java filetype autocmd.
    pattern = { "scala", "sbt", "java" },
    callback = function()
      require("metals").initialize_or_attach(metals_config)
    end,
    group = nvim_metals_group,
  })
end

function M.setup()
  setupCmp()
  setupKeys()

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
      'cssls',
      'lemminx',
      'fsautocomplete',
      'yamlls',
      'marksman',
      'tsserver',
    }
  })

  MasonInstallList({
    -- DAP Providers
    'netcoredbg',

    -- Linters
    'fantomas',
    'prettier',
    'stylua',
  })

  local function setupCodelensRefresh(bufnr)
    vim.api.nvim_create_autocmd({ "TextChanged", "InsertLeave", "BufEnter", "CursorHold" }, {
      callback = function(_)
        vim.lsp.codelens.refresh()
      end,
      buffer = bufnr,
    })

    vim.cmd('hi link LspCodeLens Type')
  end

  local function defaultSetup(server)
    server.setup({
      on_attach = lspOnAttach,
      flags = {
        debounce_text_changes = 300,
      },
      capabilities = capabilities
    })
  end

  defaultSetup(lspconfig.jsonls)
  defaultSetup(lspconfig.elmls)
  defaultSetup(lspconfig.html)
  defaultSetup(lspconfig.cssls)
  defaultSetup(lspconfig.yamlls)
  defaultSetup(lspconfig.marksman)
  defaultSetup(lspconfig.tsserver)

  lspconfig.ocamllsp.setup({
    on_attach = function (client, bufnr)
      lspOnAttach(client, bufnr)
      setupCodelensRefresh(bufnr)
    end,
    capabilities = capabilities,
    get_language_id = function(_, ftype) return ftype end,
    settings = {
      extendedHover = { enable = true },
      codelens = { enable = true },
    }
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

  lspconfig.fsautocomplete.setup({
    on_attach = function(client, bufnr)
      lspOnAttach(client, bufnr)
      setupCodelensRefresh(bufnr)
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

  setupScala(capabilities)

  require('vim.lsp.codelens').on_codelens = codelensFix()

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover,
    { border = "rounded" }
  )
  dap.config()
  dap.bindKeys()
end

return M
