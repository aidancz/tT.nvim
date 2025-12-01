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

M.cache_n = {
-- normal mode (include visual mode)
	count = 1,
	direction = "next",
	literal_string = " ",
	search_history = true,
}

M.cache_o = {
-- operator pending mode
	count = 1,
	direction = "next",
	literal_string = " ",
	search_history = false,
}

M.cache_n_apply = function()
	if vim.v.count ~= 0 then
		M.cache_n.count = vim.v.count
	end
	M.search_literal_string(
		M.cache_n.count,
		M.cache_n.direction,
		M.cache_n.literal_string,
		M.cache_n.search_history
	)
end

M.cache_o_apply = function()
	if vim.v.count ~= 0 then
		M.cache_o.count = vim.v.count
	end
	M.search_literal_string(
		M.cache_o.count,
		M.cache_o.direction,
		M.cache_o.literal_string,
		M.cache_o.search_history
	)
end

---@param opts? {
---	count?: number,
---	direction?: "prev"|"next",
---	literal_string?: string,
---	search_history?: boolean,
---}
M.expr = function(opts)
	opts = opts or {}
	if opts.literal_string == nil then
		opts.literal_string = vim.fn.getcharstr():gsub("\r", "\\n")
	end

	if M.is_operator_pending_mode() then
		M.cache_o = vim.tbl_extend(
			"force",
			{
				count = 1,
				direction = "next",
				literal_string = " ",
				search_history = false,
			},
			opts
		)
		return [[<cmd>lua require("tT").cache_o_apply()<cr>]]
	else
		M.cache_n = vim.tbl_extend(
			"force",
			{
				count = 1,
				direction = "next",
				literal_string = " ",
				search_history = true,
			},
			opts
		)
		return [[<cmd>lua require("tT").cache_n_apply()<cr>]]
	end
end

M.is_operator_pending_mode = function()
	local mode = vim.api.nvim_get_mode().mode
	return string.sub(mode, 1, 2) == "no"
end

return M
