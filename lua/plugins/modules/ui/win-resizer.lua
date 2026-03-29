return {
  {
    "simeji/winresizer",
    config = function()
      -- winresizer 설정
      vim.g.winresizer_start_key = "<C-e>"

      -- 키 매핑 커스터마이징 (선택사항)
      -- vim.g.winresizer_keycode_left = string.byte("h")
      -- vim.g.winresizer_keycode_down = string.byte("j")
      -- vim.g.winresizer_keycode_up = string.byte("k")
      -- vim.g.winresizer_keycode_right = string.byte("l")

      -- 취소 키 (기본: q)
      -- vim.g.winresizer_keycode_cancel = string.byte("q")

      -- 확인 키 (기본: Enter)
      -- vim.g.winresizer_keycode_finish = 13

      -- GUI Vim에서도 사용 가능하게 설정
      vim.g.winresizer_gui_enable = 1

      -- 창 크기 변경 단위 (기본: 1)
      -- vim.g.winresizer_vert_resize = 5
      -- vim.g.winresizer_horiz_resize = 2
    end,
  },
}
