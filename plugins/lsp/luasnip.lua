return {
  {
    "L3MON4D3/LuaSnip",
    dependencies = { "joresserwe/friendly-snippet" },
    -- lazy = true,
    -- build = vim.fn.has "win32" == 0
    --     and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build\n'; make install_jsregexp"
    --   or nil,
    -- opts = {
    --   history = true,
    --   delete_check_events = "TextChanged",
    --   region_check_events = "CursorMoved",
    -- },
    -- config = require "plugins.configs.luasnip",
  },
  {
    "rafamadriz/friendly-snippets",
    enabled = false,
  },
}
