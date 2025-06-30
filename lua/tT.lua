local M = {}

---@param count number
---@param direction "prev"|"next"
---@param literal_string string
---@param search_history boolean
M.search_literal_string = function(count, direction, literal_string, search_history)
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
	if search_history == nil then
		search_history = true
	end
	-- give them default value is convenient for manual call, it is okay to remove above lines

	local pattern = [[\V\C]] .. literal_string
	for _ = 1, count do
		if direction == "next" then
			vim.fn.search(pattern, "")
			if search_history then
				vim.fn.setreg("/", pattern)
				vim.v.searchforward = 1
			end
		else
			vim.fn.search(pattern, "b")
			if search_history then
				vim.fn.setreg("/", pattern)
				vim.v.searchforward = 0
			end
		end
	end
end

-- # the following is for single-char dot-repeatable search

M.search_literal_string_opts = function(opts)
	M.search_literal_string(opts.count, opts.direction, opts.literal_string, opts.search_history)
end

M.cache_opts_operator_pending_mode = nil
M.cache_opts_operator_pending_mode_not = nil

M.apply_cache_opts = function(is_operator_pending_mode)
	local cache_opts
	if is_operator_pending_mode then
		cache_opts = M.cache_opts_operator_pending_mode
	else
		cache_opts = M.cache_opts_operator_pending_mode_not
	end
	if vim.v.count ~= 0 then
		cache_opts.count = vim.v.count
	end
	M.search_literal_string_opts(cache_opts)
end

---@param opts {
---	count?: number,
---	direction: "prev"|"next",
---	literal_string?: string,
---	search_history?: boolean,
---}
M.expr = function(opts)
	opts.count = opts.count or vim.v.count1
	opts.literal_string = opts.literal_string or vim.fn.getcharstr():gsub("\r", "\\n")

	local mode = vim.api.nvim_get_mode().mode
	local is_operator_pending_mode = string.sub(mode, 1, 2) == "no"
	if is_operator_pending_mode then
		opts.search_history = false
		M.cache_opts_operator_pending_mode = opts
		return
		[[<cmd>lua require("tT").apply_cache_opts(true)<cr>]]
	else
		opts.search_history = true
		M.cache_opts_operator_pending_mode_not = opts
		return
		[[<cmd>lua require("tT").apply_cache_opts(false)<cr>]]
	end
end
-- seperate M.expr?
-- yes, you can seperate them:
-- but nobody wants to map a same key twice

return M
