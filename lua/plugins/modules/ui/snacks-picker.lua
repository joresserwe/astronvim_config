return {
  "folke/snacks.nvim",
  ---@type snacks.Config
  opts = {
    picker = {
      win = {
        input = {
          keys = {
            ["<c-l>"] = { "preview_scroll_right", mode = { "i", "n" } },
            ["<c-h>"] = { "preview_scroll_left", mode = { "i", "n" } },
            ["<c-p>"] = { "focus_preview", mode = { "i", "n" } },
            ["<c-n>"] = false,
          },
        },
        list = {
          keys = {
            ["<c-l>"] = "preview_scroll_right",
            ["<c-h>"] = "preview_scroll_left",
            ["<c-p>"] = "focus_preview",
            ["<c-n>"] = false,
          },
        },
        preview = {
          keys = {
            ["<c-i>"] = "focus_input",
            ["<c-p>"] = "focus_list",
            ["<c-l>"] = "focus_list",
          },
        },
      },
      sources = {
        notifications = {
          layout = {
            layout = {
              box = "vertical", -- 전체 구조를 수직으로 배치
              width = 0.7,
              height = 0.6,
              border = "rounded",
              { win = "input", height = 1, border = "bottom", title = "Filter", title_pos = "center" },
              { win = "list", border = "rounded", title = "Notifications", title_pos = "center" },
              { win = "preview", height = 0.5, border = "none" },
            },
          },
          confirm = "close",
          formatters = { severity = { level = true } },
          focus = "list",
        },
      },
    },
  },
}
