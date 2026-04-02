-- markview.nvim 에러 방지: snacks picker preview에서 strict_render 호출 시
-- preview.callbacks가 nil이 되어 에러 발생하는 문제 해결
---@type LazySpec
return {
  "OXY2DEV/markview.nvim",
  opts = {
    preview = {
      callbacks = {
        on_attach = function(_, wins)
          for _, win in ipairs(wins or {}) do
            vim.wo[win].conceallevel = 3
          end
        end,
      },
    },
  },
}
