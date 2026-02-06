local M = {}

---@param hex_str string hexadecimal value of a color
local hex_to_rgb = function(hex_str)
  local hex = "[abcdef0-9][abcdef0-9]"
  local pat = "^#(" .. hex .. ")(" .. hex .. ")(" .. hex .. ")$"
  hex_str = string.lower(hex_str)

  assert(string.find(hex_str, pat) ~= nil, "hex_to_rgb: invalid hex_str: " .. tostring(hex_str))

  local red, green, blue = string.match(hex_str, pat)
  return { tonumber(red, 16), tonumber(green, 16), tonumber(blue, 16) }
end

---@param fg string forecrust color
---@param bg string background color
---@param alpha number number between 0 and 1. 0 results in bg, 1 results in fg
local blend = function(fg, bg, alpha)
  bg = hex_to_rgb(bg)
  fg = hex_to_rgb(fg)

  local blendChannel = function(i)
    local ret = (alpha * fg[i] + ((1 - alpha) * bg[i]))
    return math.floor(math.min(math.max(0, ret), 255) + 0.5)
  end

  return string.format("#%02X%02X%02X", blendChannel(1), blendChannel(2), blendChannel(3))
end

local darken = function(hex, amount, bg)
  return blend(hex, bg, math.abs(amount))
end

M.colors = {
  rosewater = "#f5e0dc",
  flamingo = "#f2cdcd",
  pink = "#f5c2e7",
  mauve = "#cba6f7",
  red = "#f38ba8",
  maroon = "#eba0ac",
  peach = "#fab387",
  yellow = "#f9e2af",
  green = "#a6e3a1",
  teal = "#94e2d5",
  sky = "#89dceb",
  sapphire = "#74c7ec",
  blue = "#89b4fa",
  lavender = "#b4befe",
  text = "#cdd6f4",
  subtext1 = "#bac2de",
  subtext0 = "#a6adc8",
  overlay2 = "#9399b2",
  overlay1 = "#7f849c",
  overlay0 = "#6c7086",
  surface2 = "#585b70",
  surface1 = "#45475a",
  surface0 = "#313244",
  base = "#1e1e2e",
  mantle = "#181825",
  crust = "#11111b",
}

--- @class Options
M.options = {
  accent = M.colors.red,
  colors = M.colors,
  integrations = {},
  highlights = function(self)
    -- Reference to default values: https://github.com/catppuccin/nvim/tree/main/lua/catppuccin/groups
    return {
      -- Editor
      ColorColumn = { bg = self.colors.surface0 },                                                                    -- used for the columns set with 'colorcolumn'
      Conceal = { fg = self.colors.overlay1 },                                                                        -- placeholder characters substituted for concealed text (see 'conceallevel')
      Cursor = { fg = self.colors.base, bg = self.colors.rosewater },                                                 -- character under the cursor
      lCursor = { fg = self.colors.base, bg = self.colors.rosewater },                                                -- the character under the cursor when |language-mapping| is used (see 'guicursor')
      CursorIM = { fg = self.colors.base, bg = self.colors.rosewater },                                               -- like Cursor, but used when in IME mode |CursorIM|
      CursorColumn = { bg = self.colors.mantle },                                                                     -- Screen-column at the cursor, when 'cursorcolumn' is set.
      CursorLine = { bg = darken(self.colors.surface0, 0.64, self.colors.base) },                                     -- Screen-line at the cursor, when 'cursorline' is set.  Low-priority if forecrust (ctermfg OR guifg) is not set.
      Directory = { fg = self.colors.blue },                                                                          -- directory names (and other special names in listings)
      EndOfBuffer = { fg = self.colors.base },                                                                        -- filler lines (~) after the end of the buffer.  By default, this is highlighted like |hl-NonText|.
      ErrorMsg = { fg = self.colors.red, italic = true, bold = true },                                                -- error messages on the command line
      VertSplit = { fg = self.colors.crust },                                                                         -- the column separating vertically split windows
      Folded = { fg = self.colors.blue, bg = self.colors.surface1 },                                                  -- line used for closed folds
      FoldColumn = { fg = self.colors.overlay0 },                                                                     -- 'foldcolumn'
      SignColumn = { fg = self.colors.surface1 },                                                                     -- column where |signs| are displayed
      SignColumnSB = { bg = self.colors.crust, fg = self.colors.surface1 },                                           -- column where |signs| are displayed
      Substitute = { bg = self.colors.surface1, fg = self.colors.pink },                                              -- |:substitute| replacement text highlighting
      LineNr = { fg = self.colors.surface1 },                                                                         -- Line number for ":number" and ":#" commands, and when 'number' or 'relativenumber' option is set.
      CursorLineNr = { fg = self.colors.lavender },                                                                   -- Like LineNr when 'cursorline' or 'relativenumber' is set for the cursor line. highlights the number in numberline.
      MatchParen = { fg = self.colors.text, bg = darken(self.colors.surface1, 0.70, self.colors.base), bold = true }, -- The character under the cursor or just before it, if it is a paired bracket, and its match. |pi_paren.txt|
      ModeMsg = { fg = self.colors.text, bold = true },                                                               -- 'showmode' message (e.g., "-- INSERT -- ")
      MsgSeparator = { link = "WinSeparator" },                                                                       -- Separator for scrolled messages, `msgsep` flag of 'display'
      MoreMsg = { fg = self.colors.blue },                                                                            -- |more-prompt|
      NonText = { fg = self.colors.overlay0 },                                                                        -- '@' at the end of the window, characters from 'showbreak' and other characters that do not really exist in the text (e.g., ">" displayed when a double-wide character doesn't fit at the end of the line). See also |hl-EndOfBuffer|.
      Normal = { fg = self.colors.text, bg = self.colors.crust },                                                     -- normal text
      NormalNC = { fg = self.colors.text, bg = self.colors.crust },                                                   -- normal text in non-current windows
      NormalSB = { fg = self.colors.text, bg = self.colors.crust },                                                   -- normal text in non-current windows
      NormalFloat = { fg = self.colors.text, bg = self.colors.crust },                                                -- Normal text in floating windows.
      FloatBorder = { fg = self.colors.blue, bg = self.colors.crust },
      FloatTitle = { fg = self.colors.subtext0, bg = self.colors.crust },                                             -- Title of floating windows
      FloatShadow = { bg = self.colors.overlay0, blend = 80 },
      FloatShadowThrough = { bg = self.colors.overlay0, blend = 100 },
      Pmenu = { bg = self.colors.mantle, fg = self.colors.overlay2 },                                -- Popup menu: normal item.
      PmenuSel = { bg = self.colors.surface0, bold = true },                                         -- Popup menu: selected item.
      PmenuMatch = { fg = self.colors.text, bold = true },                                           -- Popup menu: matching text.
      PmenuMatchSel = { bold = true },                                                               -- Popup menu: matching text in selected item; is combined with |hl-PmenuMatch| and |hl-PmenuSel|.
      PmenuSbar = { bg = self.colors.surface0 },                                                     -- Popup menu: scrollbar.
      PmenuThumb = { bg = self.colors.overlay0 },                                                    -- Popup menu: Thumb of the scrollbar.
      PmenuExtra = { fg = self.colors.overlay0 },                                                    -- Popup menu: normal item extra text.
      PmenuExtraSel = { bg = self.colors.surface0, fg = self.colors.overlay0, bold = true },         -- Popup menu: selected item extra text.
      ComplMatchIns = { link = "PreInsert" },                                                        -- Matched text of the currently inserted completion.
      PreInsert = { fg = self.colors.overlay2 },                                                     -- Text inserted when "preinsert" is in 'completeopt'.
      ComplHint = { fg = self.colors.subtext0 },                                                     -- Virtual text of the currently selected completion.
      ComplHintMore = { link = "Question" },                                                         -- The additional information of the virtual text.
      Question = { fg = self.colors.blue },                                                          -- |hit-enter| prompt and yes/no questions
      QuickFixLine = { bg = darken(self.colors.surface1, 0.70, self.colors.base), bold = true },     -- Current |quickfix| item in the quickfix window. Combined with |hl-CursorLine| when the cursor is there.
      Search = { bg = darken(self.colors.sky, 0.30, self.colors.base), fg = self.colors.text },      -- Last search pattern highlighting (see 'hlsearch').  Also used for similar items that need to stand out.
      IncSearch = { bg = darken(self.colors.sky, 0.90, self.colors.base), fg = self.colors.mantle }, -- 'incsearch' highlighting; also used for the text replaced with ":s///c"
      CurSearch = { bg = self.colors.red, fg = self.colors.mantle },                                 -- 'cursearch' highlighting: highlights the current search you're on differently
      SpecialKey = { link = "NonText" },                                                             -- Unprintable characters: text displayed differently from what it really is.  But not 'listchars' textspace. |hl-Whitespace|
      SpellBad = { sp = self.colors.red, undercurl = true },                                         -- Word that is not recognized by the spellchecker. |spell| Combined with the highlighting used otherwise.
      SpellCap = { sp = self.colors.yellow, undercurl = true },                                      -- Word that should start with a capital. |spell| Combined with the highlighting used otherwise.
      SpellLocal = { sp = self.colors.blue, undercurl = true },                                      -- Word that is recognized by the spellchecker as one that is used in another region. |spell| Combined with the highlighting used otherwise.
      SpellRare = { sp = self.colors.green, undercurl = true },                                      -- Word that is recognized by the spellchecker as one that is hardly ever used.  |spell| Combined with the highlighting used otherwise.
      StatusLine = { fg = self.colors.text, bg = self.colors.crust },                                -- status line of current window
      StatusLineNC = { fg = self.colors.surface1, bg = self.colors.crust },                          -- status lines of not-current windows Note: if this is equal to "StatusLine" Vim will use "^^^" in the status line of the current window.
      TabLine = { bg = self.colors.crust, fg = self.colors.overlay0 },                               -- tab pages line, not active tab page label
      TabLineFill = { bg = self.colors.mantle },                                                     -- tab pages line, where there are no labels
      TabLineSel = { link = "Normal" },                                                              -- tab pages line, active tab page label
      TermCursor = { fg = self.colors.base, bg = self.colors.rosewater },                            -- cursor in a focused terminal
      TermCursorNC = { fg = self.colors.base, bg = self.colors.overlay2 },                           -- cursor in unfocused terminals
      Title = { fg = self.colors.blue, bold = true },                                                -- titles for output from ":set all", ":autocmd" etc.
      Visual = { bg = self.colors.surface1, bold = true },                                           -- Visual mode selection
      VisualNOS = { bg = self.colors.surface1, bold = true },                                        -- Visual mode selection when vim is "Not Owning the Selection".
      WarningMsg = { fg = self.colors.yellow },                                                      -- warning messages
      Whitespace = { fg = self.colors.surface1 },                                                    -- "nbsp", "space", "tab" and "trail" in 'listchars'
      WildMenu = { bg = self.colors.overlay0 },                                                      -- current match in 'wildmenu' completion
      WinBar = { fg = self.colors.rosewater },
      WinBarNC = { link = "WinBar" },
      WinSeparator = { fg = self.colors.base },

      -- Syntax
      Comment = { fg = self.colors.overlay2 },      -- just comments
      SpecialComment = { link = "Special" },        -- special things inside a comment
      Constant = { fg = self.colors.text },         -- (preferred) any constant
      String = { fg = self.colors.green },          -- a string constant: "this is a string"
      Character = { fg = self.colors.text },        --  a character constant: 'c', '\n'
      Number = { fg = self.colors.text },           --   a number constant: 234, 0xff
      Float = { link = "Number" },                  --    a floating point constant: 2.3e10
      Boolean = { fg = self.colors.text },          --  a boolean constant: TRUE, false
      Identifier = { fg = self.colors.text },       -- (preferred) any variable name
      Function = { fg = self.colors.text },         -- function name (also: methods for classes)
      Statement = { fg = self.accent },             -- (preferred) any statement
      Conditional = { fg = self.accent },           --  if, then, else, endif, switch, etc.
      Repeat = { fg = self.accent },                --   for, do, while, etc.
      Label = { fg = self.accent },                 --    case, default, etc.
      Operator = { fg = self.colors.text },         -- "sizeof", "+", "*", etc.
      Keyword = { fg = self.accent, },              --  any other keyword
      Exception = { fg = self.accent },             --  try, catch, throw

      PreProc = { fg = self.colors.subtext0 },      -- (preferred) generic Preprocessor
      Include = { fg = self.colors.subtext0 },      --  preprocessor #include
      Define = { link = "PreProc" },                -- preprocessor #define
      Macro = { fg = self.colors.subtext0 },        -- same as Define
      PreCondit = { link = "PreProc" },             -- preprocessor #if, #else, #endif, etc.

      StorageClass = { fg = self.accent },          -- static, register, volatile, etc.
      Structure = { fg = self.accent },             --  struct, union, enum, etc.
      Special = { fg = self.colors.text },          -- (preferred) any special symbol
      Type = { fg = self.colors.subtext0 },         -- (preferred) int, long, char, etc.
      Typedef = { link = "Type" },                  --  A typedef
      SpecialChar = { link = "Special" },           -- special character in a constant
      Tag = { fg = self.colors.text, bold = true }, -- you can use CTRL-] on this
      Delimiter = { fg = self.colors.overlay2 },    -- character that needs attention
      Debug = { link = "Special" },                 -- debugging statements

      Underlined = { underline = true },            -- (preferred) text that stands out, HTML links
      Bold = { bold = true },
      Italic = { italic = true },

      Error = { fg = self.colors.red },              -- (preferred) any erroneous construct
      Todo = { fg = self.colors.base, bold = true }, -- (preferred) anything that needs extra attention; mostly the keywords TODO FIXME and XXX
      qfLineNr = { fg = self.colors.yellow },
      qfFileName = { fg = self.colors.blue },
      htmlH1 = { fg = self.colors.pink, bold = true },
      htmlH2 = { fg = self.colors.blue, bold = true },
      mkdCodeDelimiter = { bg = self.colors.base, fg = self.colors.text },
      mkdCodeStart = { fg = self.colors.flamingo, bold = true },
      mkdCodeEnd = { fg = self.colors.flamingo, bold = true },

      -- debugging
      debugPC = { bg = self.colors.mantle },                                  -- used for highlighting the current line in terminal-debug
      debugBreakpoint = { bg = self.colors.base, fg = self.colors.overlay0 }, -- used for breakpoint colors in terminal-debug
      -- illuminate
      illuminatedWord = { bg = self.colors.surface1 },
      illuminatedCurWord = { bg = self.colors.surface1 },
      -- diff
      Added = { fg = self.colors.green },
      Changed = { fg = self.colors.blue },
      diffAdded = { fg = self.colors.green },
      diffRemoved = { fg = self.colors.red },
      diffChanged = { fg = self.colors.blue },
      diffOldFile = { fg = self.colors.yellow },
      diffNewFile = { fg = self.colors.peach },
      diffFile = { fg = self.colors.blue },
      diffLine = { fg = self.colors.overlay0 },
      diffIndexLine = { fg = self.colors.teal },
      DiffAdd = { bg = darken(self.colors.green, 0.18, self.colors.base) },   -- diff mode: Added line |diff.txt|
      DiffChange = { bg = darken(self.colors.blue, 0.07, self.colors.base) }, -- diff mode: Changed line |diff.txt|
      DiffDelete = { bg = darken(self.colors.red, 0.18, self.colors.base) },  -- diff mode: Deleted line |diff.txt|
      DiffText = { bg = darken(self.colors.blue, 0.30, self.colors.base) },   -- diff mode: Changed text within a changed line |diff.txt|
      -- NeoVim
      healthError = { fg = self.colors.red },
      healthSuccess = { fg = self.colors.teal },
      healthWarning = { fg = self.colors.yellow },
      -- misc

      -- glyphs
      GlyphPalette1 = { fg = self.colors.red },
      GlyphPalette2 = { fg = self.colors.teal },
      GlyphPalette3 = { fg = self.colors.yellow },
      GlyphPalette4 = { fg = self.colors.blue },
      GlyphPalette6 = { fg = self.colors.teal },
      GlyphPalette7 = { fg = self.colors.text },
      GlyphPalette9 = { fg = self.colors.red },

      -- rainbow
      rainbow1 = { fg = self.colors.red },
      rainbow2 = { fg = self.colors.peach },
      rainbow3 = { fg = self.colors.yellow },
      rainbow4 = { fg = self.colors.green },
      rainbow5 = { fg = self.colors.sapphire },
      rainbow6 = { fg = self.colors.lavender },

      -- csv
      csvCol0 = { fg = self.colors.red },
      csvCol1 = { fg = self.colors.peach },
      csvCol2 = { fg = self.colors.yellow },
      csvCol3 = { fg = self.colors.green },
      csvCol4 = { fg = self.colors.sky },
      csvCol5 = { fg = self.colors.blue },
      csvCol6 = { fg = self.colors.lavender },
      csvCol7 = { fg = self.colors.mauve },
      csvCol8 = { fg = self.colors.pink },

      -- markdown
      markdownHeadingDelimiter = { fg = self.colors.peach, bold = true },
      markdownCode = { fg = self.colors.flamingo },
      markdownCodeBlock = { fg = self.colors.flamingo },
      markdownLinkText = { fg = self.colors.blue, underline = true },
      markdownH1 = { link = "rainbow1" },
      markdownH2 = { link = "rainbow2" },
      markdownH3 = { link = "rainbow3" },
      markdownH4 = { link = "rainbow4" },
      markdownH5 = { link = "rainbow5" },
      markdownH6 = { link = "rainbow6" },

      -- Lsp
      LspReferenceText = { bg = self.colors.surface1 },  -- used for highlighting "text" references
      LspReferenceRead = { bg = self.colors.surface1 },  -- used for highlighting "read" references
      LspReferenceWrite = { bg = self.colors.surface1 }, -- used for highlighting "write" references

      -- highlight diagnostics in numberline
      DiagnosticVirtualTextError = { bg = darken(self.colors.red, 0.095, self.colors.base), fg = self.colors.red },      -- Used as the mantle highlight group. Other Diagnostic highlights link to this by default
      DiagnosticVirtualTextWarn = { bg = darken(self.colors.yellow, 0.095, self.colors.base), fg = self.colors.yellow }, -- Used as the mantle highlight group. Other Diagnostic highlights link to this by default
      DiagnosticVirtualTextInfo = { bg = darken(self.colors.sky, 0.095, self.colors.base), fg = self.colors.sky },       -- Used as the mantle highlight group. Other Diagnostic highlights link to this by default
      DiagnosticVirtualTextHint = { bg = darken(self.colors.teal, 0.095, self.colors.base), fg = self.colors.teal },     -- Used as the mantle highlight group. Other Diagnostic highlights link to this by default
      DiagnosticVirtualTextOk = { bg = darken(self.colors.teal, 0.095, self.colors.base), fg = self.colors.green },      -- Used as the mantle highlight group. Other Diagnostic highlights link to this by default

      DiagnosticError = { fg = self.colors.red },                                                                        -- Used as the mantle highlight group. Other Diagnostic highlights link to this by default
      DiagnosticWarn = { fg = self.colors.yellow },                                                                      -- Used as the mantle highlight group. Other Diagnostic highlights link to this by default
      DiagnosticInfo = { fg = self.colors.sky },                                                                         -- Used as the mantle highlight group. Other Diagnostic highlights link to this by default
      DiagnosticHint = { fg = self.colors.teal },                                                                        -- Used as the mantle highlight group. Other Diagnostic highlights link to this by default
      DiagnosticOk = { fg = self.colors.green },                                                                         -- Used as the mantle highlight group. Other Diagnostic highlights link to this by default

      DiagnosticUnderlineError = { sp = self.colors.red },                                                               -- Used to underline "Error" diagnostics
      DiagnosticUnderlineWarn = { sp = self.colors.yellow },                                                             -- Used to underline "Warn" diagnostics
      DiagnosticUnderlineInfo = { sp = self.colors.sky },                                                                -- Used to underline "Info" diagnostics
      DiagnosticUnderlineHint = { sp = self.colors.teal },                                                               -- Used to underline "Hint" diagnostics
      DiagnosticUnderlineOk = { sp = self.colors.green },                                                                -- Used to underline "Ok" diagnostics

      DiagnosticFloatingError = { fg = self.colors.red },                                                                -- Used to color "Error" diagnostic messages in diagnostics float
      DiagnosticFloatingWarn = { fg = self.colors.yellow },                                                              -- Used to color "Warn" diagnostic messages in diagnostics float
      DiagnosticFloatingInfo = { fg = self.colors.sky },                                                                 -- Used to color "Info" diagnostic messages in diagnostics float
      DiagnosticFloatingHint = { fg = self.colors.teal },                                                                -- Used to color "Hint" diagnostic messages in diagnostics float
      DiagnosticFloatingOk = { fg = self.colors.green },                                                                 -- Used to color "Ok" diagnostic messages in diagnostics float

      DiagnosticSignError = { fg = self.colors.red },                                                                    -- Used for "Error" signs in sign column
      DiagnosticSignWarn = { fg = self.colors.yellow },                                                                  -- Used for "Warn" signs in sign column
      DiagnosticSignInfo = { fg = self.colors.sky },                                                                     -- Used for "Info" signs in sign column
      DiagnosticSignHint = { fg = self.colors.teal },                                                                    -- Used for "Hint" signs in sign column
      DiagnosticSignOk = { fg = self.colors.green },                                                                     -- Used for "Ok" signs in sign column

      LspDiagnosticsDefaultError = { fg = self.colors.red },                                                             -- Used as the mantle highlight group. Other LspDiagnostic highlights link to this by default (except Underline)
      LspDiagnosticsDefaultWarning = { fg = self.colors.yellow },                                                        -- Used as the mantle highlight group. Other LspDiagnostic highlights link to this by default (except Underline)
      LspDiagnosticsDefaultInformation = { fg = self.colors.sky },                                                       -- Used as the mantle highlight group. Other LspDiagnostic highlights link to this by default (except Underline)
      LspDiagnosticsDefaultHint = { fg = self.colors.teal },                                                             -- Used as the mantle highlight group. Other LspDiagnostic highlights link to this by default (except Underline)
      LspSignatureActiveParameter = { bg = self.colors.surface0, bold = true },

      LspDiagnosticsError = { fg = self.colors.red },
      LspDiagnosticsWarning = { fg = self.colors.yellow },
      LspDiagnosticsInformation = { fg = self.colors.sky },
      LspDiagnosticsHint = { fg = self.colors.teal },
      LspDiagnosticsVirtualTextError = { fg = self.colors.red },                                               -- Used for "Error" diagnostic virtual text
      LspDiagnosticsVirtualTextWarning = { fg = self.colors.yellow },                                          -- Used for "Warning" diagnostic virtual text
      LspDiagnosticsVirtualTextInformation = { fg = self.colors.sky },                                         -- Used for "Information" diagnostic virtual text
      LspDiagnosticsVirtualTextHint = { fg = self.colors.teal },                                               -- Used for "Hint" diagnostic virtual text
      LspDiagnosticsUnderlineError = { sp = self.colors.red },                                                 -- Used to underline "Error" diagnostics
      LspDiagnosticsUnderlineWarning = { sp = self.colors.yellow },                                            -- Used to underline "Warning" diagnostics
      LspDiagnosticsUnderlineInformation = { sp = self.colors.sky },                                           -- Used to underline "Information" diagnostics
      LspDiagnosticsUnderlineHint = { sp = self.colors.teal },                                                 -- Used to underline "Hint" diagnostics
      LspCodeLens = { fg = self.colors.overlay0 },                                                             -- virtual text of the codelens
      LspCodeLensSeparator = { link = "LspCodeLens" },                                                         -- virtual text of the codelens separators
      LspInlayHint = { fg = self.colors.overlay0, bg = darken(self.colors.surface0, 0.64, self.colors.base) }, -- virtual text of the inlay hints
      LspInfoBorder = { link = "FloatBorder" },                                                                -- LspInfo border

      -- Terminal
      terminal_color_0 = { fg = self.colors.overlay0 },
      terminal_color_8 = { fg = self.colors.overlay1 },

      terminal_color_1 = { fg = self.colors.red },
      terminal_color_9 = { fg = self.colors.red },

      terminal_color_2 = { fg = self.colors.green },
      terminal_color_10 = { fg = self.colors.green },

      terminal_color_3 = { fg = self.colors.yellow },
      terminal_color_11 = { fg = self.colors.yellow },

      terminal_color_4 = { fg = self.colors.blue },
      terminal_color_12 = { fg = self.colors.blue },

      terminal_color_5 = { fg = self.colors.pink },
      terminal_color_13 = { fg = self.colors.pink },

      terminal_color_6 = { fg = self.colors.sky },
      terminal_color_14 = { fg = self.colors.sky },

      terminal_color_7 = { fg = self.colors.text },
      terminal_color_15 = { fg = self.colors.text },

      -- Treesitter
      ["@variable"] = { fg = self.colors.text },           -- Any variable name that does not have another highlight.
      ["@variable.builtin"] = { fg = self.colors.text },   -- Variable names that are defined by the languages, like this or self.
      ["@variable.parameter"] = { fg = self.colors.text }, -- For parameters of a function.
      ["@variable.member"] = { fg = self.colors.text },    -- For fields.

      ["@constant"] = { link = "Constant" },               -- For constants
      ["@constant.builtin"] = { fg = self.accent },        -- For constant that are built in the language: nil in Lua.
      ["@constant.macro"] = { link = "Macro" },            -- For constants that are defined by macros: NULL in C.

      ["@module"] = { fg = self.colors.text },             -- For identifiers referring to modules and namespaces.
      ["@label"] = { link = "Label" },                     -- For labels: label: in C and :label: in Lua.

      -- literals
      ["@string"] = { link = "String" },                                                     -- For strings.
      ["@string.documentation"] = { fg = self.colors.green },                                -- For strings documenting code (e.g. Python docstrings).
      ["@string.regexp"] = { fg = self.colors.green },                                       -- For regexes.
      ["@string.escape"] = { fg = self.colors.green },                                       -- For escape characters within a string.
      ["@string.special"] = { link = "Special" },                                            -- other special strings (e.g. dates)
      ["@string.special.path"] = { link = "Special" },                                       -- filenames
      ["@string.special.symbol"] = { fg = self.colors.green },                               -- symbols or atoms
      ["@string.special.url"] = { fg = self.colors.green, italic = true, underline = true }, -- urls, links and emails
      ["@punctuation.delimiter.regex"] = { link = "@string.regexp" },

      ["@character"] = { link = "Character" },           -- character literals
      ["@character.special"] = { link = "SpecialChar" }, -- special characters (e.g. wildcards)

      ["@boolean"] = { link = "Boolean" },               -- For booleans.
      ["@number"] = { link = "Number" },                 -- For all numbers
      ["@number.float"] = { link = "Float" },            -- For floats.

      -- types
      ["@type"] = { link = "Type" },             -- For types.
      ["@type.builtin"] = { link = "Type" },     -- For builtin types.
      ["@type.definition"] = { link = "Type" },  -- type definitions (e.g. `typedef` in C)

      ["@attribute"] = { link = "Constant" },    -- attribute annotations (e.g. Python decorators)
      ["@property"] = { fg = self.colors.text }, -- For fields, like accessing `bar` property on `foo.bar`. Overriden later for data languages and CSS.

      -- functions
      ["@function"] = { link = "Function" },             -- For function (calls and definitions).
      ["@function.builtin"] = { link = "Function" },     -- For builtin functions: table.insert in Lua.
      ["@function.call"] = { link = "Function" },        -- function calls
      ["@function.macro"] = { link = "Function" },       -- For macro defined functions (calls and definitions): each macro_rules in Rust.

      ["@function.method"] = { link = "Function" },      -- For method definitions.
      ["@function.method.call"] = { link = "Function" }, -- For method calls.

      ["@constructor"] = { fg = self.colors.text },      -- For constructor calls and definitions: = { } in Lua, and Java constructors.
      ["@operator"] = { link = "Operator" },             -- For any operator: +, but also -> and * in C.

      -- keywords
      ["@keyword"] = { link = "Keyword" },                      -- For keywords that don't fall in previous categories.
      ["@keyword.modifier"] = { link = "Keyword" },             -- For keywords modifying other constructs (e.g. `const`, `static`, `public`)
      ["@keyword.type"] = { link = "Keyword" },                 -- For keywords describing composite types (e.g. `struct`, `enum`)
      ["@keyword.coroutine"] = { link = "Keyword" },            -- For keywords related to coroutines (e.g. `go` in Go, `async/await` in Python)
      ["@keyword.function"] = { fg = self.accent },             -- For keywords used to define a function.
      ["@keyword.operator"] = { fg = self.accent },             -- For new keyword operator
      ["@keyword.import"] = { fg = self.accent },               -- For includes: #include in C, use or extern crate in Rust, or require in Lua.
      ["@keyword.repeat"] = { link = "Repeat" },                -- For keywords related to loops.
      ["@keyword.return"] = { fg = self.accent },
      ["@keyword.debug"] = { link = "Exception" },              -- For keywords related to debugging
      ["@keyword.exception"] = { link = "Exception" },          -- For exception related keywords.

      ["@keyword.conditional"] = { link = "Conditional" },      -- For keywords related to conditionnals.
      ["@keyword.conditional.ternary"] = { link = "Operator" }, -- For ternary operators (e.g. `?` / `:`)

      ["@keyword.directive"] = { link = "PreProc" },            -- various preprocessor directives & shebangs
      ["@keyword.directive.define"] = { link = "Define" },      -- preprocessor definition directives
      -- js & derivative
      ["@keyword.export"] = { fg = self.accent },

      -- punctuation
      ["@punctuation.delimiter"] = { link = "Delimiter" },  -- For delimiters (e.g. `;` / `.` / `,`).
      ["@punctuation.bracket"] = { fg = self.colors.text }, -- For brackets and parenthesis.
      ["@punctuation.special"] = { link = "Special" },      -- For special punctuation that does not fall in the categories before (e.g. `{}` in string interpolation).

      -- comment
      ["@comment"] = { link = "Comment" },
      ["@comment.documentation"] = { link = "Comment" }, -- For comments documenting code

      ["@comment.error"] = { fg = self.colors.base, bg = self.colors.red },
      ["@comment.warning"] = { fg = self.colors.base, bg = self.colors.yellow },
      ["@comment.hint"] = { fg = self.colors.base, bg = self.colors.blue },
      ["@comment.todo"] = { fg = self.colors.base, bg = self.colors.flamingo },
      ["@comment.note"] = { fg = self.colors.base, bg = self.colors.rosewater },

      -- markup
      ["@markup"] = { fg = self.colors.text },                                           -- For strings considerated text in a markup language.
      ["@markup.strong"] = { fg = self.colors.red, bold = true },                        -- bold
      ["@markup.italic"] = { fg = self.colors.red, italic = true },                      -- italic
      ["@markup.strikethrough"] = { fg = self.colors.text, strikethrough = true },       -- strikethrough text
      ["@markup.underline"] = { link = "Underlined" },                                   -- underlined text

      ["@markup.heading"] = { fg = self.colors.blue },                                   -- titles like: # Example
      ["@markup.heading.markdown"] = { bold = true },                                    -- bold headings in markdown, but not in HTML or other markup

      ["@markup.math"] = { fg = self.colors.blue },                                      -- math environments (e.g. `$ ... $` in LaTeX)
      ["@markup.quote"] = { fg = self.colors.pink },                                     -- block quotes
      ["@markup.environment"] = { fg = self.colors.pink },                               -- text environments of markup languages
      ["@markup.environment.name"] = { fg = self.colors.blue },                          -- text indicating the type of an environment

      ["@markup.link"] = { fg = self.colors.lavender },                                  -- text references, footnotes, citations, etc.
      ["@markup.link.label"] = { fg = self.colors.lavender },                            -- link, reference descriptions
      ["@markup.link.url"] = { fg = self.colors.blue, italic = true, underline = true }, -- urls, links and emails

      ["@markup.raw"] = { fg = self.accent },                                            -- used for inline code in markdown and for doc in python (""")

      ["@markup.list"] = { fg = self.colors.teal },
      ["@markup.list.checked"] = { fg = self.colors.green },      -- todo notes
      ["@markup.list.unchecked"] = { fg = self.colors.overlay1 }, -- todo notes

      -- diff
      ["@diff.plus"] = { link = "diffAdded" },    -- added text (for diff files)
      ["@diff.minus"] = { link = "diffRemoved" }, -- deleted text (for diff files)
      ["@diff.delta"] = { link = "diffChanged" }, -- deleted text (for diff files)

      -- tags
      ["@tag"] = { fg = self.colors.blue },                            -- Tags like HTML tag names.
      ["@tag.builtin"] = { fg = self.colors.blue },                    -- JSX tag names.
      ["@tag.attribute"] = { fg = self.colors.yellow, italic = true }, -- XML/HTML attributes (foo in foo="bar").
      ["@tag.delimiter"] = { fg = self.colors.teal },                  -- Tag delimiter like < > /

      -- misc
      ["@error"] = { link = "Error" },

      -- language specific:

      -- bash
      ["@function.builtin.bash"] = { fg = self.accent, italic = true },
      ["@variable.parameter.bash"] = { fg = self.colors.text },

      -- markdown
      ["@markup.heading.1.markdown"] = { link = "rainbow1" },
      ["@markup.heading.2.markdown"] = { link = "rainbow2" },
      ["@markup.heading.3.markdown"] = { link = "rainbow3" },
      ["@markup.heading.4.markdown"] = { link = "rainbow4" },
      ["@markup.heading.5.markdown"] = { link = "rainbow5" },
      ["@markup.heading.6.markdown"] = { link = "rainbow6" },

      -- html
      ["@markup.heading.html"] = { link = "@markup" },
      ["@markup.heading.1.html"] = { link = "@markup" },
      ["@markup.heading.2.html"] = { link = "@markup" },
      ["@markup.heading.3.html"] = { link = "@markup" },
      ["@markup.heading.4.html"] = { link = "@markup" },
      ["@markup.heading.5.html"] = { link = "@markup" },
      ["@markup.heading.6.html"] = { link = "@markup" },

      -- java
      ["@constant.java"] = { fg = self.colors.text },

      -- css
      ["@property.css"] = { fg = self.accent },
      ["@property.scss"] = { fg = self.accent },
      ["@property.id.css"] = { fg = self.accent },
      ["@property.class.css"] = { fg = self.accent },
      ["@type.css"] = { fg = self.colors.subtext0 },
      ["@type.tag.css"] = { fg = self.colors.subtext0 },
      ["@string.plain.css"] = { fg = self.colors.text },
      ["@number.css"] = { fg = self.colors.text },
      ["@keyword.directive.css"] = { link = "Keyword" }, -- CSS at-rules: https://developer.mozilla.org/en-US/docs/Web/CSS/At-rule.

      -- html
      ["@string.special.url.html"] = { fg = self.colors.green }, -- Links in href, src attributes.
      ["@markup.link.label.html"] = { fg = self.colors.text },   -- Text between <a></a> tags.
      ["@character.special.html"] = { fg = self.colors.red },    -- Symbols such as &nbsp;.

      -- lua
      ["@constructor.lua"] = { link = "@punctuation.bracket" }, -- For constructor calls and definitions: = { } in Lua.

      -- python
      ["@constructor.python"] = { fg = self.colors.text }, -- __init__(), __new__().

      -- yaml
      ["@label.yaml"] = { fg = self.colors.text }, -- Anchor and alias names.

      -- ruby
      ["@string.special.symbol.ruby"] = { fg = self.accent },

      -- php
      ["@function.method.php"] = { link = "Function" },
      ["@function.method.call.php"] = { link = "Function" },

      -- c/cpp
      ["@keyword.import.c"] = { fg = self.accent },
      ["@keyword.import.cpp"] = { fg = self.accent },

      -- c#
      ["@attribute.c_sharp"] = { fg = self.colors.text },

      -- gitcommit
      ["@comment.warning.gitcommit"] = { fg = self.colors.yellow },

      -- gitignore
      ["@string.special.path.gitignore"] = { fg = self.colors.text },

      -- misc
      gitcommitSummary = { fg = self.colors.text },
      zshKSHFunction = { link = "Function" },
    }
  end,
}

function M.load()
  vim.o.background = "dark"
  vim.g.colors_name = "nekomi"
  if vim.fn.has("syntax_on") then
    vim.cmd.syntax("reset")
  end

  for group, spec in pairs(M.options:highlights()) do
    vim.api.nvim_set_hl(0, group, spec)
  end
end

--- @param options? Options
function M.setup(options)
  if not options then
    return
  end

  local og_highlights = M.options.highlights

  if options.accent then
    M.options.accent = options.accent
  end

  if options.colors then
    M.options.colors = vim.tbl_extend("force", M.options.colors, options.colors)
  end

  if options.integrations then
    M.options.integrations = vim.tbl_extend("force", M.options.integrations, options.integrations)
  end

  if options.highlights then
    local new_highlights = options.highlights
    M.options.highlights = function(self)
      return vim.tbl_extend("force", og_highlights(self), new_highlights(self))
    end
  end
end

return M
