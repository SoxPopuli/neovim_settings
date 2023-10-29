local M = {}
local has_dap, dap = pcall(require, 'dap')
local has_misc, misc = pcall(require, 'misc')
local has_dapui, dapui = pcall(require, 'dapui')

function M.bindKeys()
    if not (has_dap and has_misc and has_dapui) then
        return
    end
    dapui.setup()

    vim.keymap.set('n', '<leader>do', function() dapui.open() end, { desc = "Open dap ui" })
    vim.keymap.set('n', '<leader>dc', function() dapui.close() end, { desc = "Close dap ui" })
    vim.keymap.set('n', '<leader>dt', function() dapui.toggle() end, { desc = "Toggle dap ui" })

    vim.keymap.set('n', '<F5>', function() dap.continue() end, { desc = "Continue debug" })
    vim.keymap.set('n', '<F10>', function() dap.step_over() end, { desc = "Step over" })
    vim.keymap.set('n', '<F11>', function() dap.step_into() end, { desc = "Step into" })
    vim.keymap.set('n', '<F12>', function() dap.step_out() end, { desc = "Step out" })
    vim.keymap.set('n', '<Leader>b', function() dap.toggle_breakpoint() end, { desc = "Toggle breakpoint" })
    vim.keymap.set('n', '<Leader>B', function() dap.set_breakpoint() end, { desc = "Set breakpoint" })
    vim.keymap.set('n', '<Leader>lp',
        function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end, { desc = "Set logpoint" })
    vim.keymap.set('n', '<Leader>dr', function() dap.repl.open() end, { desc = "Open dap repl" })
    vim.keymap.set('n', '<Leader>dl', function() dap.run_last() end, { desc = "Run last debug" })
    vim.keymap.set({ 'n', 'v' }, '<Leader>dh', function()
        require('dap.ui.widgets').hover()
    end, { desc = "dap hover" })
    vim.keymap.set({ 'n', 'v' }, '<Leader>dp', function()
        require('dap.ui.widgets').preview()
    end, { desc = "dap preview" })
    vim.keymap.set('n', '<Leader>df', function()
        local widgets = require('dap.ui.widgets')
        widgets.centered_float(widgets.frames)
    end, { desc = "Show debug frames" })
    vim.keymap.set('n', '<Leader>ds', function()
        local widgets = require('dap.ui.widgets')
        widgets.centered_float(widgets.scopes)
    end, { desc = "Show debug scopes" })
end

function M.config()
    local dotnetPrefix = misc.buildPath({
        vim.fn.stdpath('data'),
        'mason',
        'bin',
    })

    dap.adapters.coreclr = {
        type = 'executable',
        command = misc.buildPath({ dotnetPrefix, 'netcoredbg' }),
        args = { '--interpreter=vscode' },
    }

    local dotnetConfig = {
        {
            type = 'coreclr',
            name = 'launch - netcoredbg',
            request = 'launch',
            program = function()
                local items = vim.fn.globpath(vim.fn.getcwd(), '**/*.dll', false, true)
                local indexed = {}
                for i = 1, #items do
                    indexed[i] = i .. ': ' .. items[i]
                end

                local choice = vim.fn.inputlist(indexed)
                return items[choice]
            end
        }
    }

    dap.configurations.cs = dotnetConfig
    dap.configurations.fsharp = dotnetConfig

    dap.configurations.scala = {
        {
            type = "scala",
            request = "launch",
            name = "RunOrTest",
            metals = {
                runType = "runOrTestFile",
                --args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
            },
        },
        {
            type = "scala",
            request = "launch",
            name = "Test Target",
            metals = {
                runType = "testTarget",
            },
        },
    }
end

return M
