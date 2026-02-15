<h1 align="center">
    Nekomi for Neovim
</h1>

![nekomi-preview](https://imgur.com/if39V8m.png)

Minimal neovim theme based on the [Catppuccin](https://github.com/catppuccin/nvim) Mocha.

# Installation #

[Native Package Manager](https://neovim.io/doc/user/pack.html#_plugin-manager)
```lua
vim.pack.add({ "https://github.com/kotsuban/nekomi.nvim" })
```

Or you can just copy `colors/nekomi.lua` and `lua/nekomi.lua` directly into your neovim config.

# Usage #

```lua
vim.cmd.colorscheme("nekomi")
```

# Customize #

```lua
local nekomi = require("nekomi")

nekomi.setup({
    accent = nekomi.colors.blue, -- Change the accent color to blue, check lua/nekomi.lua for all available colors.
    colors = { -- Override base and mantle colors. 
      base = "#11111b",
      mantle = "#11111b",
    },
    integrations = { -- Disable all integrations, check lua/nekomi.lua for all available integrations.
      gitsigns = false,
      mason = false,
      fugitive = false,
    },
    highlights = function(self)
      return { -- Change the string color to grey.
        String = { fg = self.colors.overlay2 },
      }
    end
})
```
# Thank You! #

- [Cattpuccin](https://github.com/catppuccin/nvim) - For the amazing color palette.
- [Gruber Darker](https://github.com/rexim/gruber-darker-theme/) - For the initial idea.

