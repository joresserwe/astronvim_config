return {
  "keaising/im-select.nvim",
  event = "VeryLazy",
  config = function()
    local is_mac = vim.fn.has "macunix" == 1
    require("im_select").setup {
      default_im_select = is_mac and "com.apple.keylayout.ABC" or "1033",
      default_command = is_mac and "macism" or "im-select.exe",
      set_default_events = { "InsertLeave", "CmdlineLeave" },
      set_previous_events = { "InsertEnter" },
      async_switch_im = false,
    }
  end,
}
