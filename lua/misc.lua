local M = {}

---Get path separator for platform
---@return string
function M.path_sep()
	if vim.fn.has("win32") == 1 then
		return [[\]]
	else
		return [[/]]
	end
end

---Join strings
---@param parts string[]
---@param delimiter string | nil
---@return string
function M.string_join(parts, delimiter)
    local output = ""

    for i, value in ipairs(parts) do
        output = output .. value
        if delimiter ~= nil and i < #parts then
            output = output .. delimiter
        end
    end

    return output
end

---Removes last part of path
---Includes trailing slash
---@param path string
---@return string | nil
function M.path_root(path)
	if path == nil then
		return nil
	end

	local function get_last_sep_index(p2, sep)
		for i = #p2, 1, -1 do
			if p2:sub(i, i) == sep then
				return i
			end
		end
		return -1
	end

	local last_index = get_last_sep_index(path, M.path_sep())

	if last_index > 0 then
		return path:sub(1, last_index)
	else
		return path
	end
end

---comment
---@param p string[]
---@return string
function M.build_path(p)
	local sep = M.path_sep()

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

function M.get_args(fn)
	local args = {}
	local hook = debug.gethook()

	local argHook = function(...)
		local info = debug.getinfo(3)
		if "pcall" ~= info.name then
			return
		end

		for i = 1, math.huge do
			local name, value = debug.getlocal(2, i)
			if "(*temporary)" == name then
				debug.sethook(hook)
				error("")
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
