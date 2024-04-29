local current_path = ... .. "."
return {
  require(current_path .. "kitty"),
  require(current_path .. "which-key"),
}
