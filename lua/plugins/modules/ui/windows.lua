---@type LazySpec
return {
  -- 수동 리사이즈: <C-w>r 로 resize 모드 진입, hjkl 로 조절
  {
    "mrjones2014/smart-splits.nvim",
    event = "VeryLazy",
    dependencies = { "pogyomo/submode.nvim" },
    config = function()
      require("smart-splits").setup()

      local submode = require "submode"
      -- <C-w>r 또는 <C-w><C-r> 로 resize 모드 진입
      vim.keymap.set("n", "<C-w><C-r>", "<C-w>r", { remap = true, desc = "Resize mode" })

      submode.create("WinResize", {
        mode = "n",
        enter = "<C-w>r",
        desc = "Resize mode",
        leave = { "<Esc>", "q", "<C-c>" },
        hook = {
          on_enter = function() vim.notify "Resize mode: h/j/k/l to resize, <Esc> to exit" end,
          on_leave = function() vim.notify "" end,
        },
        default = function(register)
          register("h", require("smart-splits").resize_left, { desc = "Resize left" })
          register("j", require("smart-splits").resize_down, { desc = "Resize down" })
          register("k", require("smart-splits").resize_up, { desc = "Resize up" })
          register("l", require("smart-splits").resize_right, { desc = "Resize right" })
        end,
      })
    end,
  },
}
