local M = {}

function M.pathSep()
    if vim.fn.has('win32') == 1 then
        return [[\]]
    else
        return [[/]]
    end
end

---comment
---@param p string[]
---@return string
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


---Check if an item in list matches predicate
---@param list any[]
---@param pred fun(item: any): boolean
function M.contains(list, pred)
    for _, value in pairs(list) do
        if pred(value) then
            return true
        end
    end

    return false
end

return M
