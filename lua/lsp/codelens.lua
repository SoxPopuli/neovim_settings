local M = {}

local api = vim.api

local function resolve_lenses(lenses, bufnr, client_id, callback)
  lenses = lenses or {}

  local num_lens = vim.tbl_count(lenses)
  if num_lens == 0 then
    callback()
    return
  end

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

-- Move codelens from eol to above
local function redirect_codelens()
  
end

function M.codelens_fix()
  local codelens = require('vim.lsp.codelens')
  local old_on_codelens = codelens.on_codelens

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

function M.setup_codelens_refresh(bufnr)
  api.nvim_create_autocmd({ "TextChanged", "InsertLeave", "BufEnter", "CursorHold" }, {
    callback = function(_)
      vim.lsp.codelens.refresh()
    end,
    buffer = bufnr,
  })

  vim.cmd('hi link LspCodeLens Type')

  --also do a manual refresh just cause
  vim.lsp.codelens.refresh()
end

--api.nvim_create_autocmd("LspAttach", {
--  pattern = { "*.fs", "*.ml", "*.mli" },
--  callback = function(args)
--    -- local client = vim.lps.get_client_by_id(args.data.client_id)
--    print('pog')
--    setup_codelens_refresh(args.buf)
--  end
--})

-- require('vim.lsp.codelens').on_codelens = codelens_fix()

return M
