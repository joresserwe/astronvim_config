if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

return {
  "windwp/nvim-autopairs",
  config = function(plugin, opts)
    require "plugins.configs.nvim-autopairs"(plugin, opts) -- setup 호출을 하는 기본 astronvim 구성 포함
    -- 사용자 정의 자동 쌍 설정 등 추가적인 autopairs 구성
    local npairs = require "nvim-autopairs"
    local Rule = require "nvim-autopairs.rule"
    local cond = require "nvim-autopairs.conds"
    npairs.add_rules(
      {
        Rule("$", "$", { "tex", "latex" })
          -- 다음 문자가 %일 경우 쌍을 추가하지 않음
          :with_pair(cond.not_after_regex "%%")
          -- 이전 문자가 xxx일 경우 쌍을 추가하지 않음
          :with_pair(
            cond.not_before_regex("xxx", 3)
          )
          -- 반복 문자일 경우 오른쪽으로 이동하지 않음
          :with_move(cond.none())
          -- 다음 문자가 xx일 경우 삭제하지 않음
          :with_del(cond.not_after_regex "xx")
          -- <cr>를 눌렀을 때 새 줄 추가 안 함
          :with_cr(cond.none()),
      },
      -- .vim 파일에는 비활성화하지만, 다른 파일 타입에는 작동
      Rule("a", "a", "-vim")
    )
  end,
}
