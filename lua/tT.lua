local M = {}

M.search_literal_string = function(direction, literal_string, count)
	direction = direction or "next"
	if not literal_string then
		vim.ui.input(
			nil,
			function(input)
				literal_string = input
			end
		)
		if not literal_string then return end
	end
	count = count or vim.v.count1

	local pattern = [[\V\C]] .. literal_string
	for _ = 1, count do
		if direction == "next" then
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

-- the following is for single-char dot-repeatable search

M.cache = {
	direction = nil,
	literal_string = nil,
	count = nil,
}

M.update_cache = function(direction)
	M.cache.direction = direction
	M.cache.literal_string = vim.fn.getcharstr():gsub("\r", "\\n")
	M.cache.count = vim.v.count1
end

M.apply_cache = function()
	M.search_literal_string(
		M.cache.direction,
		M.cache.literal_string,
		vim.v.count == 0 and M.cache.count or vim.v.count
	)
end

M.new = function(direction)
	M.update_cache(direction)
	M.apply_cache()
end

-- we want M.new:         `t<char>`
-- we want M.apply_cache: `.`
-- how?
-- use expr mapping

M.expr = function(direction)
	M.update_cache(direction)
	return
	[[<cmd>lua require("tT").apply_cache()<cr>]]
end

return M
