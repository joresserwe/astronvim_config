return {
  "goolord/alpha-nvim",
  opts = function(_, opts)
    local get_icon = require("astroui").get_icon

    opts.section.header.val = {
      " █████  ███████ ████████ ██████   ██████",
    }

    opts.section.buttons.val = {
      opts.button("LDR n  ", get_icon("FileNew", 2, true) .. "New File  "),
      opts.button("LDR f f", get_icon("Search", 2, true) .. "Find File  "),
      opts.button("LDR f e", get_icon("DefaultFile", 2, true) .. "Recents  "),
      opts.button("LDR f /", get_icon("WordFile", 2, true) .. "Find Word  "),
      opts.button("LDR f `", get_icon("Bookmarks", 2, true) .. "Bookmarks  "),
      opts.button("LDR s l", get_icon("Refresh", 2, true) .. "Last Session  "),
    }

    opts.config.layout = {
      { type = "padding", val = vim.fn.max { 2, vim.fn.floor(vim.fn.winheight(0) * 0.2) } },
      opts.section.header,
      { type = "padding", val = 5 },
      opts.section.buttons,
      { type = "padding", val = 3 },
      opts.section.footer,
    }
  end,
}
