tT = {}

tT.map_expr = function(direction)
	local char = vim.fn.getcharstr()
	return string.format([==[<cmd>lua tT.fun_callback(%s, [=[%s]=])<cr>]==], direction, char)
	-- make it dot-repeatable
	-- i want to call this ultimate hack
end

tT.fun_callback = function(direction, char)
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

return M
