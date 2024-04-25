local ignore_messages = {
  "E79: 만능 글자를 확장할 수 없습니다",
}

return {
  "rcarriga/nvim-notify",
  opts = {
    timeout = 1000,
    background_colour = "#000000",
  },
  config = function()
    vim.notify = function(msg, ...)
      for _, banned in ipairs(ignore_messages) do
        if msg == banned then return end
      end
      require "notify"(msg, ...)
    end
  end,
}
