local current_path = ... .. "."
return {
  require(current_path .. "language"),

  require(current_path .. "cmp"),
  require(current_path .. "inlay-hints"),
  require(current_path .. "lint"),
  require(current_path .. "luasnip"),
}
