-- 비활성 윈도우 dim 처리
---@type LazySpec
return {
  {
    "TaDaa/vimade",
    event = "VeryLazy",
    opts = {
      recipe = { "default", { animate = true } },
      fadelevel = 0.8,
      ncmode = "windows",
    },
  },
}