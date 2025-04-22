return {
  "echasnovski/mini.icons",
  lazy = true, -- Lazy load 설정
  config = function()
    require("mini.icons").setup()
    require("mini.icons").mock_nvim_web_devicons()
  end,
}
