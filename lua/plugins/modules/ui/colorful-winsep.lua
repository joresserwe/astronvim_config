-- 활성 윈도우 테두리 색상 강조 (tmux 스타일)
---@type LazySpec
return {
  {
    "nvim-zh/colorful-winsep.nvim",
    event = "WinLeave",
    opts = {
      border = "single",
      animate = { enabled = false },
      excluded_ft = {
        "neo-tree",
        "noice",
        "qf",
        "trouble",
        "snacks_terminal",
        "snacks_picker_input",
        "mason",
        "lazy",
      },
    },
  },
}