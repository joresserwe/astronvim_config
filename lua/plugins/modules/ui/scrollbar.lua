return {
  {
    "petertriho/nvim-scrollbar",
    opts = {
      handle = {
        color = require("highlights.colors").slate_blue,
        blend = 60,
      },
      handlers = {
        gitsigns = require("astrocore").is_available "gitsigns.nvim",
        search = require("astrocore").is_available "nvim-hlslens",
        ale = require("astrocore").is_available "ale",
      },
      excluded_filetypes = {
        "dropbar_menu",
        "dropbar_menu_fzf",
        "DressingInput",
        "cmp_docs",
        "cmp_menu",
        "noice",
        "prompt",
        "TelescopePrompt",
        -- "blink-cmp-menu",
        -- "blink-cmp-documentation",
      },
    },
    event = "VeryLazy",
  },
  {
    "saghen/blink.cmp",
    ---@module "blink.cmp"
    ---@type blink.cmp.Config
    opts = {
      completion = {
        menu = {
          scrollbar = false,
        },
      },
    },
  },
}
