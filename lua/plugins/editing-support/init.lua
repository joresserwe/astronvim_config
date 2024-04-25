local current_path = ... .. "."
return {
--  require(current_path .. "autopairs"),
  require(current_path .. "autosave"),
  require(current_path .. "multicursor"),
  -- require(current_path .. "vim-zoom"),
}
