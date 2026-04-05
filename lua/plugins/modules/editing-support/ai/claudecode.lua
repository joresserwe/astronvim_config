-- Claude Code 공식 Neovim IDE 확장
-- MCP 프로토콜을 통해 에디터↔Claude Code CLI 간 양방향 통신
return {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },
  event = "VeryLazy",
  opts = {
    terminal = {
      split_side = "right",
      split_width_percentage = 0.35,
    },
    diff_opts = {
      auto_close_on_accept = true,
      vertical_split = true,
      open_in_current_tab = true,
    },
  },
}
