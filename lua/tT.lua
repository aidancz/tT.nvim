tT = {}

tT.setup = function(config)
	tT.config = vim.tbl_deep_extend("force", tT.config, config or {})
	vim.keymap.set({"n", "x", "o"}, tT.config.t, function() return tT.map_expr(true) end, {expr = true})
	vim.keymap.set({"n", "x", "o"}, tT.config.T, function() return tT.map_expr(false) end, {expr = true})
end

tT.config = {
	t = "t",
	T = "T",
}

tT.map_expr = function(direction)
	tT.direction = direction

	local char
	char = vim.fn.getcharstr()
	if char == "\r" then char = [[\n]] end
	tT.char = char

	return [[<cmd>lua tT.callback()<cr>]]
end

tT.callback = function()
	local pattern = [[\V\C]] .. tT.char

	if tT.direction then
		for i = 1, vim.v.count1 do
			vim.fn.search(pattern, "")
		end
	else
		for i = 1, vim.v.count1 do
			vim.fn.search(pattern, "b")
		end
	end

	vim.fn.setreg("/", pattern)

	if tT.direction then
		vim.v.searchforward = 1
	else
		vim.v.searchforward = 0
	end
end

return tT
