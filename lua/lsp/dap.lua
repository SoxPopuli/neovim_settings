local M = {}
local has_dap, dap = pcall(require, 'dap')
local has_misc, misc = pcall(require, 'misc')

function M.bindKeys()
    if not (has_dap and has_misc) then
        return
    end

    vim.keymap.set('n', '<F5>', function() dap.continue() end)
    vim.keymap.set('n', '<F10>', function() dap.step_over() end)
    vim.keymap.set('n', '<F11>', function() dap.step_into() end)
    vim.keymap.set('n', '<F12>', function() dap.step_out() end)
    vim.keymap.set('n', '<Leader>b', function() dap.toggle_breakpoint() end)
    vim.keymap.set('n', '<Leader>B', function() dap.set_breakpoint() end)
    vim.keymap.set('n', '<Leader>lp',
        function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
    vim.keymap.set('n', '<Leader>dr', function() dap.repl.open() end)
    vim.keymap.set('n', '<Leader>dl', function() dap.run_last() end)
    vim.keymap.set({ 'n', 'v' }, '<Leader>dh', function()
        require('dap.ui.widgets').hover()
    end)
    vim.keymap.set({ 'n', 'v' }, '<Leader>dp', function()
        require('dap.ui.widgets').preview()
    end)
    vim.keymap.set('n', '<Leader>df', function()
        local widgets = require('dap.ui.widgets')
        widgets.centered_float(widgets.frames)
    end)
    vim.keymap.set('n', '<Leader>ds', function()
        local widgets = require('dap.ui.widgets')
        widgets.centered_float(widgets.scopes)
    end)
end

function M.config()
    local dotnetPrefix = misc.buildPath({
        vim.fn.stdpath('data'),
        'mason',
        'bin',
    })

    dap.adapters.coreclr = {
        type = 'executable',
        command = misc.buildPath({ dotnetPrefix, 'netcoredbg' })
    }

    local dotnetConfig = {
        {
            type = 'coreclr',
            name = 'launch - netcoredbg',
            request = 'launch',
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
