-- 커서 이동 시 스미어(잔상) 애니메이션 효과
return {
  "sphamba/smear-cursor.nvim",
  event = "VeryLazy",
  cond = vim.g.neovide == nil, -- Neovide는 자체 커서 애니메이션 사용
  opts = {
    smear_between_buffers = true,
    smear_between_neighbor_lines = true,
    scroll_buffer_space = true,
    hide_target_hack = true,
  },
}
