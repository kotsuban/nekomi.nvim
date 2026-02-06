<h1 align="center">
    Nekomi for Neovim
</h1>

![nekomi-preview](https://imgur.com/NjOChr5.png)

You can think of this theme as a minimal version of catppuccin-mocha. 
It uses a single accent color for language statements and a small set of additional colors for comments, types, and strings.
Everything else is rendered as plain white text.

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

