-- heirline은 astroui.status 의존성 때문에 로드는 유지하되,
-- statusline은 lualine, tabline은 bufferline, winbar는 dropbar가 담당하므로
-- 각 슬롯을 nil 처리해 비워둔다.
return {
  "rebelot/heirline.nvim",
  optional = true,
  opts = function(_, opts)
    opts.statusline = nil
    opts.tabline = nil
    opts.winbar = nil
  end,
}
