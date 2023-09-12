# FiveM.nvim

## Requirements

- [stevearc/dressing.nvim](https://github.com/stevearc/dressing.nvim)
- [rcarriga/nvim-notify](https://github.com/rcarriga/nvim-notify)

## Example Setup

### Lazy.nvim

```lua
{
  "Z3rio/FiveM.nvim",

  config = function()
    require("fivem").setup({
      debug = true
    })
  end,

  dependencies = {
    "rcarriga/nvim-notify", 'stevearc/dressing.nvim'
  },

  lazy = false,
  dev = true
},
```
