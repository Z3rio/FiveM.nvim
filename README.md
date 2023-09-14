# FiveM.nvim

## Requirements

NVim plugins:

- [stevearc/dressing.nvim](https://github.com/stevearc/dressing.nvim)
- [rcarriga/nvim-notify](https://github.com/rcarriga/nvim-notify)
- [nvim-lua/plenary.nvim](https://github.com/nvim-lua/plenary.nvim)
- [MunifTanjim/nui.nvim](https://github.com/MunifTanjim/nui.nvim)

FiveM scripts:

- [Z3rio/nvimapi](https://github.com/Z3rio/nvimapi)

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
    "rcarriga/nvim-notify", 'stevearc/dressing.nvim', 'nvim-lua/plenary.nvim', 'MunifTanjim/nui.nvim'
  },

  lazy = false
},
```
