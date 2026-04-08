return {
  "keaising/im-select.nvim",
  event = "VeryLazy",
  cond = function() return require("core.platform").is_mac end,
  config = function()
    require("im_select").setup {
      default_im_select = "com.apple.keylayout.ABC",
      default_command = "macism",
      set_default_events = { "InsertLeave", "CmdlineLeave" },
      set_previous_events = { "InsertEnter" },
      async_switch_im = false,
    }
  end,
}
