return function() -- this table overrides highlights in all themes
  local colors = require "highlights.colors"
  local highlight_util = require "highlights.utils"
  local get_hlgroup = require("astroui").get_hlgroup

  local tab_color = {
    active = {
      bg = colors.none,
      indicator = colors.lime,
    },
    inactive = {
      fg = colors.inactive_fg,
      bg = colors.none,
    },
    unfocused = {
      fg = highlight_util.blend(colors.unfocus_fg, 0.5, colors.inactive_fg),
      bg = colors.none,
      indicator = colors.crimson,
    },
  }

  local default_color = {
    -- NormalNC = { bg = "#252635" },
    Normal = { bg = colors.none },
    NormalNC = { bg = colors.none },
    NormalFloat = { bg = colors.none },
    FloatTitle = { bg = colors.none },
  }

  local status_hl = {
    StatusLine = { fg = colors.none, bg = colors.none },
    StatusLineNC = { fg = colors.none, bg = colors.none },
  }

  local picker_hl = {
    -- TelescopeNormal = { bg = colors.none },
    -- TelescopePromptTitle = { fg = colors.corn_flower_blue, bg = colors.none },
    -- TelescopePromptBorder = { fg = colors.corn_flower_blue, bg = colors.none },
    -- SnacksPickerBorder = { fg = colors.slate_blue, bg = colors.none },
    -- SnacksPickerInputBorder = { fg = colors.slate_blue },
  }

  local winbar_hl = {
    WinBar = { fg = colors.corn_flower_blue, bg = colors.none },
    WinBarNC = { fg = colors.inactive_fg, bg = default_color.NormalNC.bg },
  }

  local neoTree_hl = {
    NeoTreeNormal = { bg = colors.none },
    NeoTreeNormalNC = { bg = colors.none },
  }

  local bufferLine_hl = {
    BufferLineDuplicate = { fg = tab_color.inactive.fg, bg = tab_color.inactive.bg },
    BufferLineDuplicateSelected = { bg = tab_color.active.bg, bold = true, italic = true },
    BufferLineDuplicateVisible = { fg = tab_color.unfocused.fg, bg = tab_color.unfocused.bg },

    TabLineFill = { bg = tab_color.unfocused.bg },
    BufferLineBackground = { fg = tab_color.inactive.fg, bg = tab_color.inactive.bg },
    BufferLineBufferSelected = { bg = tab_color.active.bg },
    BufferLineBufferVisible = { fg = tab_color.unfocused.fg, bg = tab_color.unfocused.bg },

    BufferLineSeperator = { fg = colors.bg, bg = colors.none },
    BufferLineSeperatorSelected = { fg = colors.none, bg = tab_color.active.indicator },
    BufferLineSeperatorVisible = { fg = colors.bg, bg = colors.none },

    BufferLineIndicatorSelected = { fg = tab_color.active.indicator, bg = tab_color.active.bg },
    BufferLineIndicatorVisible = { fg = tab_color.unfocused.indicator, bg = tab_color.unfocused.bg },

    BufferLineModified = { bg = tab_color.inactive.bg },
    BufferLineModifiedSelected = { bg = tab_color.active.bg },
    BufferLineModifiedVisible = { bg = tab_color.unfocused.bg },

    BufferlineDiagnnosticVisible = { fg = colors.red },

    BufferlineHintVisible = { fg = tab_color.unfocused.fg },
    -- BufferlineHintDiagnosticVisible = { fg = tab.unfocused.fg },
    BufferlineInfoVisible = { fg = tab_color.unfocused.fg },
    -- BufferlineInfoDiagnosticVisible = { fg = tab.unfocused.fg },
    BufferlineWarningVisible = { fg = tab_color.unfocused.fg },
    -- BufferlineWarningDiagnosticVisible = { fg = tab.unfocused.fg },
    BufferlineErrorVisible = { fg = tab_color.unfocused.fg },
    -- BufferlineErrorDiagnosticVisible = { fg = tab.unfocused.fg },
    -- BufferlineHintVisible = { fg = get_hlgroup("DiagnosticHint").fg },
    -- BufferlineHintDiagnosticVisible = { fg = get_hlgroup("DiagnosticHint").fg },
    -- BufferlineInfoVisible = { fg = get_hlgroup("DiagnosticInfo").fg },
    -- BufferlineInfoDiagnosticVisible = { fg = get_hlgroup("DiagnosticInfo").fg },
    -- BufferlineWarningVisible = { fg = get_hlgroup("DiagnosticWarn").fg },
    -- BufferlineWarningDiagnosticVisible = { fg = get_hlgroup("DiagnosticWarn").fg },
    -- BufferlineErrorVisible = { fg = get_hlgroup("DiagnosticError").fg },
    -- BufferlineErrorDiagnosticVisible = { fg = get_hlgroup("DiagnosticError").fg },
  }

  -- for _, icon in pairs(require("mini.icons").get_icons()) do
  --   print(icon.name)
  --   -- if not icon.name then goto continue end
  --   -- bufferLine_hl["BufferLineDevIcon" .. icon.name] = { fg = tab_color.inactive.fg, bg = tab_color.inactive.bg }
  --   -- bufferLine_hl["BufferLineDevIcon" .. icon.name .. "Selected"] = { bg = tab_color.active.bg }
  --   -- bufferLine_hl["BufferLineDevIcon" .. icon.name .. "Inactive"] = { bg = tab_color.unfocused.bg }
  --   -- ::continue::
  -- end

  return vim.tbl_extend("force", default_color, winbar_hl, neoTree_hl, bufferLine_hl, status_hl, picker_hl)
end
