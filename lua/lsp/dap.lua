local M = {}
local dap = require('dap')

local dotnetConfig = {
    {
        type = 'coreclr',
        name = 'launch - netcoredbg',
        request = 'launch',
    }
}

dap.configurations.cs = dotnetConfig
dap.configurations.fsharp = dotnetConfig

return M
