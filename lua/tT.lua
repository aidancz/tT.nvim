local M = {}

---@param count number
---@param direction "prev"|"next"
---@param literal_string string
M.search_literal_string = function(count, direction, literal_string)
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

M.search_literal_string_opts = function(opts)
	opts.count = opts.count or vim.v.count1
	opts.direction = opts.direction or "next"
	if not opts.literal_string then
		vim.ui.input(
			nil,
			function(input)
				opts.literal_string = input
			end
		)
		if not opts.literal_string then return end
	end
	-- give them default value is convenient for manual call, it is okay to remove above lines
	M.search_literal_string(opts.count, opts.direction, opts.literal_string)
end

-- # the following is for single-char dot-repeatable search

M.cache = {
	count = nil,
	direction = nil,
	literal_string = nil,
}

M.apply_cache = function()
	if vim.v.count ~= 0 then
		M.cache.count = vim.v.count
	end
	M.search_literal_string_opts(M.cache)
end

---@param opts {
---	direction: "prev"|"next",
---}
M.expr = function(opts)
	opts.count = vim.v.count1
	opts.literal_string = vim.fn.getcharstr():gsub("\r", "\\n")

	local mode = vim.api.nvim_get_mode().mode
	if string.sub(mode, 1, 2) ~= "no" then
		vim.schedule(function()
			M.search_literal_string_opts(opts)
		end)
	else
		M.cache = opts
		return
		[[<cmd>lua require("tT").apply_cache()<cr>]]
	end
end

-- # seperate M.expr?

-- yes, you can seperate them:
-- but nobody wants to map a key twice

-- M.map_nx = function(opts)
-- 	opts.count = vim.v.count1
-- 	opts.literal_string = vim.fn.getcharstr():gsub("\r", "\\n")
-- 	M.search_literal_string_opts(opts)
-- end
-- M.map_o_expr = function(opts)
-- 	opts.count = vim.v.count1
-- 	opts.literal_string = vim.fn.getcharstr():gsub("\r", "\\n")
-- 	M.cache = opts
-- 	return
-- 	[[<cmd>lua require("tT").apply_cache()<cr>]]
-- end

-- vim.keymap.set(
-- 	{"n", "x"},
-- 	"t",
-- 	function()
-- 		require("tT").map_nx({
-- 			direction = "next"
-- 		})
-- 	end
-- )
-- vim.keymap.set(
-- 	"o",
-- 	"t",
-- 	function()
-- 		return
-- 		require("tT").map_o_expr({
-- 			direction = "next"
-- 		})
-- 	end,
-- 	{expr = true}
-- )

return M
