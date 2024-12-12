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
	local char = vim.fn.getcharstr()
	if char == "\r" then char = [[\n]] end
	return string.format([==[<cmd>lua tT.callback(%s, [=[%s]=])<cr>]==], direction, char)
	-- make it dot-repeatable
	-- i want to call this ultimate hack
end

tT.callback = function(direction, char)
	local pattern = [[\V\C]] .. char

	if direction then
		for i = 1, vim.v.count1 do
			vim.fn.search(pattern, "")
		end
	else
		for i = 1, vim.v.count1 do
			vim.fn.search(pattern, "b")
		end
	end

	vim.fn.setreg("/", pattern)

	if direction then
		vim.v.searchforward = 1
	else
		vim.v.searchforward = 0
	end
end

return tT
