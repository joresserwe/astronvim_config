local filtered_messages = {
  "vim.tbl_islist is deprecated",
  -- 무시할 Message는 요기에 추가
}

return {
  "folke/snacks.nvim",
  ---@type snacks.Config
  opts = {
    notifier = {
      filter = function(notif)
        if notif.msg then
          for _, pattern in ipairs(filtered_messages) do
            if notif.msg:match(pattern) then return false end
          end
        end
        return true
      end,
    },
  },
}
