return function() -- this table overrides highlights in all themes
  local colors = require "user.highlights.colors"
  local highlight_util = require "user.utils.highlight"
  local get_hlgroup = require("astronvim.utils").get_hlgroup

  local tab = {
    active = {
      bg = colors.none,
      indicator = colors.lime,
    },
    inactive = {
      fg = colors.inactive_fg,
      bg = colors.none,
    },
    unfocused = {
      -- fg = colors.unfocus_fg,
      fg = highlight_util.blend(colors.unfocus_fg, 0.7, colors.inactive_fg),
      bg = colors.none,
      indicator = colors.dark_golden_rod,
    },
  }

  local winbar_hl = {
    WinBar = { bg = colors.none },
    WinBarNC = { fg = colors.inactive_fg, bg = colors.none },
  }

  local neoTree_hl = {
    NeoTreeNormal = { bg = colors.none },
    NeoTreeNormalNC = { bg = colors.none },
  }

  local bufferLine_hl = {
    BufferLineDuplicate = { fg = tab.inactive.fg, bg = tab.inactive.bg },
    BufferLineDuplicateSelected = { bg = tab.active.bg, bold = true, italic = true },
    BufferLineDuplicateVisible = { fg = tab.unfocused.fg, bg = tab.unfocused.bg },

    BufferLineBackground = { fg = tab.inactive.fg, bg = tab.inactive.bg },
    BufferLineBufferSelected = { bg = tab.active.bg },
    BufferLineBufferVisible = { fg = tab.unfocused.fg, bg = tab.unfocused.bg },

    BufferLineSeperator = { fg = colors.bg, bg = colors.none },
    BufferLineSeperatorSelected = { fg = colors.none, bg = tab.active.indicator },
    BufferLineSeperatorVisible = { fg = colors.bg, bg = colors.none },

    BufferLineIndicatorSelected = { fg = tab.active.indicator, bg = tab.active.bg },
    BufferLineIndicatorVisible = { fg = tab.unfocused.indicator, bg = tab.unfocused.bg },

    BufferLineModified = { bg = tab.inactive.bg },
    BufferLineModifiedSelected = { bg = tab.active.bg },
    BufferLineModifiedVisible = { bg = tab.unfocused.bg },

    BufferlineDiagnnosticVisible = { fg = colors.red },

    BufferlineHintVisible = { fg = tab.unfocused.fg },
    -- BufferlineHintDiagnosticVisible = { fg = tab.unfocused.fg },
    BufferlineInfoVisible = { fg = tab.unfocused.fg },
    -- BufferlineInfoDiagnosticVisible = { fg = tab.unfocused.fg },
    BufferlineWarningVisible = { fg = tab.unfocused.fg },
    -- BufferlineWarningDiagnosticVisible = { fg = tab.unfocused.fg },
    BufferlineErrorVisible = { fg = tab.unfocused.fg },
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

  for _, icon in pairs(require("nvim-web-devicons").get_icons()) do
    if not icon.name then goto continue end
    bufferLine_hl["BufferLineDevIcon" .. icon.name] = { fg = tab.inactive.fg, bg = tab.inactive.bg }
    bufferLine_hl["BufferLineDevIcon" .. icon.name .. "Selected"] = { bg = tab.active.bg }
    bufferLine_hl["BufferLineDevIcon" .. icon.name .. "Inactive"] = { bg = tab.unfocused.bg }
    ::continue::
  end

  return vim.tbl_extend("force", winbar_hl, neoTree_hl, bufferLine_hl)
end
