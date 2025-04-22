-- preview 관련 설정 수정 필요함 (preview일 때 list / list일 때 preview, list일때 h/l을 눌렀을 때 preview로 이동하는 것도 ㄱㅊ을 듯 함)
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
            ["<c-l>"] = "preview_scroll_right",
            ["<c-h>"] = "preview_scroll_left",
          }
        }
      },
    },
  },
}
