-- diagnostics, references, quickfix 통합 리스트
return {
  "folke/trouble.nvim",
  cmd = "Trouble",
  opts = {
    focus = true,
    auto_close = true, -- 마지막 항목 해결되면 자동 닫힘
  },
  init = function()
    -- 빌트인 quickfix 창 대신 Trouble로 열기
    vim.api.nvim_create_autocmd("QuickFixCmdPost", {
      callback = function()
        vim.schedule(function() vim.cmd "Trouble qflist open" end)
      end,
    })
  end,
}
