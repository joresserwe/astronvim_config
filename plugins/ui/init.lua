local current_path = ... .. "."
return {
  require(current_path .. "bufferline"),
  require(current_path .. "heirline-winbar"),
  require(current_path .. "lualine"),
  require(current_path .. "neo-tree"),
  require(current_path .. "noice"),
  require(current_path .. "notify"),
  require(current_path .. "rainbow-delimiters"),
  require(current_path .. "telescope"),
}
