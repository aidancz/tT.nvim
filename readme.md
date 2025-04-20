tT.nvim - drop-in replacement for builtin f/F t/T

# demo

searching for a single character without hitting enter should not assign six keys: `f F t T ; ,`

this plugin introduces `new t` and `new T`:

`tx` works like `/x<cr>` (search forward for "x").  
`Tx` works like `?x<cr>` (search backward for "x").  

thus you can repeat the last `new t` or `new T` with `n` or `N`

thus `new t` and `new T` are both exclusive  
you can force it to work inclusive via `v`, e.g. `dvtx`, see `:h o_v`  

dot-repeatable

# setup

```
vim.keymap.set({"n", "x", "o"}, "t", require("tT").search_char_forward, {expr = true})
vim.keymap.set({"n", "x", "o"}, "T", require("tT").search_char_backward, {expr = true})
```
