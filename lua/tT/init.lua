-- vim.keymap.set({"n", "x", "o"}, "f", "<nop>")
-- vim.keymap.set({"n", "x", "o"}, "F", "<nop>")
-- vim.keymap.set({"n", "x", "o"}, "t", "<nop>")
-- vim.keymap.set({"n", "x", "o"}, "T", "<nop>")
-- vim.keymap.set({"n", "x", "o"}, ";", "<nop>")
-- vim.keymap.set({"n", "x", "o"}, ",", "<nop>")

require("tT/tT")

vim.keymap.set({"n", "x", "o"}, "t", function() return tT.map_expr(true) end, {expr = true})
vim.keymap.set({"n", "x", "o"}, "T", function() return tT.map_expr(false) end, {expr = true})
