return {
  "petertriho/nvim-scrollbar",
  opts = function(_, opts)
    opts.handle = require("astrocore").extend_tbl(opts.handle, {
      color = require("highlights.colors").corn_flower_blue,
      blend = 70,
      excluded_filetypes = {
        "dropbar_menu",
        "dropbar_menu_fzf",
        "DressingInput",
        "cmp_docs",
        "cmp_menu",
        "noice",
        "prompt",
        "TelescopePrompt",
        "blink_menu",
        "blink_docs",
      }
    })
  end,
  event = "VeryLazy",
}
