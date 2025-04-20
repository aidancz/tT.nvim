tT.nvim - drop-in replacement for builtin f/F t/T

# demo

searching for a single character without hitting enter should not assign six keys: `f F t T ; ,`

if you:

```lua
vim.keymap.set({"n", "x", "o"}, "t", function() return require("tT").expr("next") end, {expr = true})
vim.keymap.set({"n", "x", "o"}, "T", function() return require("tT").expr("prev") end, {expr = true})
```

then:

`tx` works like `/x<cr>` (search next for "x").  
`Tx` works like `?x<cr>` (search prev for "x").  

thus you can repeat the last `tx` or `Tx` with `n` or `N`

thus `tx` and `Tx` are both exclusive  
you can force it to work inclusive via `v`, e.g. `dvtx`, see `:h o_v`  

support dot-repeat
