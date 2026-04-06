-- 사용자 색상 설정
-- nil이면 테마 색상을 자동으로 따라감
-- 직접 색상값("#RRGGBB")을 지정하면 테마 대신 해당 색상을 사용

local NONE = "NONE"

return {
  transparent_bg = true,

  -- 시맨틱 색상
  bg = nil, -- 배경
  fg = nil, -- 전경
  accent = nil, -- 주요 강조 (winbar, scrollbar 등)
  indicator = require("highlights.palette").lime, -- 활성 탭 indicator
  inactive = nil, -- 비활성 요소 (비활성 탭, winbar 등)
  unfocused = nil, -- 포커스 없는 요소
  danger = require("highlights.palette").crimson, -- 비포커스 indicator
  scrollbar = require("highlights.palette").slate_blue, -- scrollbar handle
  winsep = nil, -- 활성 창 구분선 (colorful-winsep)

  --- highlight group 정의 (c: resolve된 시맨틱 색상, bg: 투명 처리된 배경)
  ---@param c table
  ---@param bg string
  highlights = function(c, bg)
    return {
      -- 줄번호
      LineNr = { fg = require("highlights.palette").dim_gray },
      LineNrAbove = { fg = require("highlights.palette").dim_gray },
      LineNrBelow = { fg = require("highlights.palette").dim_gray },

      -- 배경
      Normal = { bg = bg },
      NormalNC = { bg = bg },
      NormalFloat = { bg = bg },
      FloatTitle = { bg = bg },
      StatusLine = { fg = NONE, bg = NONE },
      StatusLineNC = { fg = NONE, bg = NONE },

      -- WinBar
      WinBar = { fg = c.accent, bg = NONE },
      WinBarNC = { fg = c.inactive, bg = bg },

      -- NeoTree
      NeoTreeNormal = { bg = bg },
      NeoTreeNormalNC = { bg = bg },

      -- BufferLine: 탭 배경
      TabLineFill = { bg = NONE },
      BufferLineBackground = { fg = c.inactive, bg = NONE },
      BufferLineBufferSelected = { bg = NONE },
      BufferLineBufferVisible = { fg = c.unfocused, bg = NONE },

      -- BufferLine: 중복 표시
      BufferLineDuplicate = { fg = c.inactive, bg = NONE },
      BufferLineDuplicateSelected = { bg = NONE, bold = true, italic = true },
      BufferLineDuplicateVisible = { fg = c.unfocused, bg = NONE },

      -- BufferLine: 구분선
      BufferLineSeparator = { fg = c.bg, bg = NONE },
      BufferLineSeparatorSelected = { fg = NONE, bg = c.indicator },
      BufferLineSeparatorVisible = { fg = c.bg, bg = NONE },

      -- BufferLine: indicator
      BufferLineIndicatorSelected = { fg = c.indicator, bg = NONE },
      BufferLineIndicatorVisible = { fg = c.danger, bg = NONE },

      -- BufferLine: 수정됨 표시
      BufferLineModified = { bg = NONE },
      BufferLineModifiedSelected = { bg = NONE },
      BufferLineModifiedVisible = { bg = NONE },

      -- Scrollbar
      SatelliteBar = { bg = c.scrollbar },

      -- 활성 창 구분선
      ColorfulWinSep = { fg = c.winsep },

      -- BufferLine: visible 탭 진단 표시
      BufferLineHintVisible = { fg = c.unfocused },
      BufferLineInfoVisible = { fg = c.unfocused },
      BufferLineWarningVisible = { fg = c.unfocused },
      BufferLineErrorVisible = { fg = c.unfocused },
    }
  end,
}
