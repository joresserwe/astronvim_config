---@type LazySpec
return {
  "nvim-focus/focus.nvim",
  event = "VeryLazy",
  config = function()
    vim.opt.equalalways = false
    vim.opt.splitkeep = "cursor"
    require("focus").setup()

    -- neo-tree, Avante 등 특수 창에서 자동 리사이즈 비활성화
    local ignore_filetypes = { "neo-tree", "Avante", "AvanteSelectedFiles", "AvanteInput", "codecompanion" }
    local ignore_buftypes = { "nofile", "prompt", "popup" }

    local augroup = vim.api.nvim_create_augroup("FocusDisable", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      group = augroup,
      callback = function()
        if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
          vim.b.focus_disable = true
        end
      end,
      desc = "Disable focus autoresize for special filetypes",
    })
    vim.api.nvim_create_autocmd("BufEnter", {
      group = augroup,
      callback = function()
        if vim.tbl_contains(ignore_buftypes, vim.bo.buftype) then
          vim.w.focus_disable = true
        end
      end,
      desc = "Disable focus autoresize for special buftypes",
    })
  end,
}
