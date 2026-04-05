-- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
return {
  virtual_text = false, -- tiny-inline-diagnostic.nvim이 대체
  underline = true,
  update_in_insert = false,
  -- virtual_lines = false,
  -- virtual_lines = {
  --   only_current_line = true,
  -- },
}
