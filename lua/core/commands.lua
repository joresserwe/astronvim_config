return {
  CopyPath = {
    function()
      local path = vim.fn.expand "%:p"
      local rel = vim.fn.expand "%:."
      local name = vim.fn.expand "%:t"

      vim.ui.select({ rel, path, name }, { prompt = "Copy path" }, function(choice)
        if choice then
          vim.fn.setreg("+", choice)
          vim.notify("Copied: " .. choice)
        end
      end)
    end,
    desc = "파일 경로 복사 (절대/상대/파일명)",
  },
}
