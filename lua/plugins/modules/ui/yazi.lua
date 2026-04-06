-- yazi 파일매니저 플로팅 윈도우 연동
return {
  "mikavilpas/yazi.nvim",
  dependencies = { "folke/snacks.nvim" },
  keys = {
    { "sf", "<Cmd>Yazi<CR>", desc = "Yazi (current file)" },
    { "sF", "<Cmd>Yazi cwd<CR>", desc = "Yazi (cwd)" },
  },
  opts = {},
}
