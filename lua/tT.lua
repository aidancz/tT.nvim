local M = {}

---@param count number
---@param direction "prev"|"next"
---@param literal_string string
M.search_literal_string = function(count, direction, literal_string)
	count = count or vim.v.count1
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
	-- give them default value is convenient for manual call, it is okay to remove above lines

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

-- # the following is for single-char dot-repeatable search

M.search_literal_string_opts = function(opts)
	M.search_literal_string(opts.count, opts.direction, opts.literal_string)
end

M.cache_opts = nil

M.apply_cache_opts = function()
	if vim.v.count ~= 0 then
		M.cache_opts.count = vim.v.count
	end
	M.search_literal_string_opts(M.cache_opts)
end

---@param opts {
---	count?: number,
---	direction: "prev"|"next",
---	literal_string?: string,
---}
M.expr = function(opts)
	opts.count = opts.count or vim.v.count1
	opts.literal_string = opts.literal_string or vim.fn.getcharstr():gsub("\r", "\\n")

	local mode = vim.api.nvim_get_mode().mode
	local is_operator_pending_mode = string.sub(mode, 1, 2) == "no"
	if is_operator_pending_mode then
		M.cache_opts = opts
		return
		[[<cmd>lua require("tT").apply_cache_opts()<cr>]]
	else
		vim.schedule(function()
			M.search_literal_string_opts(opts)
		end)
	end
end
-- seperate M.expr?
-- yes, you can seperate them:
-- but nobody wants to map a same key twice

return M
