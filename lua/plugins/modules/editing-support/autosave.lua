return {
  "Pocco81/auto-save.nvim",
  event = { "User AstroFile", "InsertEnter" },
  opts = {
    execution_message = { message = "" },
    condition = function(buf)
      if not vim.api.nvim_buf_is_valid(buf) then return false end
      if vim.bo[buf].buftype == "acwrite" then return false end
      return true
    end,
  },
}
