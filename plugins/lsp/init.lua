local current_path = ... .. "."
return {
  require(current_path .. "cmp"),
  require(current_path .. "mason"),
  require(current_path .. "null-ls"),
  require(current_path .. "treesitter"),
}
