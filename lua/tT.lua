local M = {}

M.search_char = function(direction, char, count)
	local pattern = [[\V\C]] .. char
	for _ = 1, count do
		if direction then
			vim.fn.search(pattern, "")
			vim.fn.setreg("/", pattern)
			vim.v.searchforward = 1
		else
			vim.fn.search(pattern, "b")
			vim.fn.setreg("/", pattern)
			vim.v.searchforward = 0
		end
	end
end

M.cache = {
	direction = nil,
	char = nil,
	count = nil,
}

M.update_cache = function(direction)
	M.cache.direction = direction

	local char
	char = vim.fn.getcharstr()
	if char == "\r" then char = [[\n]] end
	M.cache.char = char

	local count
	count = vim.v.count1
	M.cache.count = count
end

M.search_char_cache = function()
	M.search_char(
		M.cache.direction,
		M.cache.char,
		vim.v.count == 0 and M.cache.count or vim.v.count
	)
end

M.search_char_new = function(direction)
	M.update_cache(direction)
	M.search_char_cache()
end

-- we want search_char_new:   `f<char>`
-- we want search_char_cache: `.` (dot-repeat)
-- how?
-- use expr mapping

M.search_char_forward = function()
	M.update_cache(true)
	return
	[[<cmd>lua require("tT").search_char_cache()<cr>]]
end

M.search_char_backward = function()
	M.update_cache(false)
	return
	[[<cmd>lua require("tT").search_char_cache()<cr>]]
end

return M
