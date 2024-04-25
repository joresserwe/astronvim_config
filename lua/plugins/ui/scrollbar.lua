return {
  "petertriho/nvim-scrollbar",
  opts = function(_, opts)
    opts.handle = require("astrocore").extend_tbl(opts.handle, {
      color = require("highlights.colors").black_gray,
    })
  end,
  event = "VeryLazy",
}
