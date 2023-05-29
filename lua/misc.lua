local M = {}

function M.pathSep()
    if vim.fn.has('win32') == 1 then
        return [[\]]
    else
        return [[/]]
    end
end

function M.buildPath(p)
    local sep = M.pathSep()

    local parts = p or {}
    local path = parts[1] or ""
    local len = #parts
    local i = 2

    while i <= len do
        path = path .. sep .. parts[i]
        i = i + 1
    end
    return path
end

function M.getArgs(fn)
    local args = {}
    local hook = debug.gethook()

    local argHook = function(...)
        local info = debug.getinfo(3)
        if 'pcall' ~= info.name then return end

        for i = 1, math.huge do
            local name, value = debug.getlocal(2, i)
            if '(*temporary)' == name then
                debug.sethook(hook)
                error('')
                return
            end
            table.insert(args, name)
        end
    end

    debug.sethook(argHook, "c")
    pcall(fn)

    return args
end

return M
