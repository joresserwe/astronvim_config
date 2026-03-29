return {
  "anuvyklack/windows.nvim",
  dependencies = {
    "anuvyklack/middleclass",
    "anuvyklack/animation.nvim",
  },
  opts = {
    autowidth = {
      enable = true,
      -- winwidth = 1, -- 최소 너비
      -- filetype = {
      --   help = 2,
      -- },
    },
    ignore = {
      filetype = { "Avante", "AvanteSelectedFiles", "AvanteInput", "codecompanion", "neo-tree" },
      buftype = { "terminal", "nofile" },
    },
  },
  config = function(_, opts)
    -- vim.opt.winwidth = 10
    -- vim.opt.winminwidth = 10
    vim.opt.equalalways = false
    require("windows").setup(opts)
  end,
}
