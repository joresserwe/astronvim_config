-- 프로젝트 전체 검색/치환 (ripgrep 기반)
return {
  "MagicDuck/grug-far.nvim",
  cmd = "GrugFar",
  keys = {
    { "<Leader>fr", function() require("grug-far").open() end, desc = "Find and Replace (GrugFar)" },
  },
  opts = {},
}
