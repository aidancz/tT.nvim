tT.nvim - drop-in replacement for builtin f/F t/T

# demo

searching for a single character without hitting enter shouldn't require six keys: `f F t T ; ,`

this plugin introduces `new t` and `new T` commands:

`tx` works like `/x<cr>` (search forward for "x").  
`Tx` works like `?x<cr>` (search backward for "x").  

thus `new t` and `new T` are both exclusive  
you can force it to work inclusive via `v`, e.g. `dvtx`, see `:h o_v`  

# setup

## setup example:

```
require("tT").setup()
```

this uses default settings, which is equivalent to:

```
require("tT").setup({
	t = "t",
	T = "T",
})
```
