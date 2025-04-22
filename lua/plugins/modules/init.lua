local M = {}

local exclude = {
  "lsp.cmp", -- Modules to exclude (e.g., plugins/module/lsp/cmp.lua)
  "ui.dashboard",
  "utils.kitty",
  "utils.molten",
}

-- Normalize paths for cross-platform compatibility
local function normalize_path(path) return path:gsub("\\", "/"):gsub("//+", "/") end

-- Get the base module name dynamically based on the directory structure
local function get_base_module(current_dir)
  local config_dir = vim.fn.stdpath "config" -- ~/.config/nvim
  local lua_root = normalize_path(config_dir .. "/lua/")
  current_dir = normalize_path(current_dir)

  -- Extract the relative path after "lua/" and convert it to dot notation
  local relative_path = current_dir:gsub("^" .. lua_root, "")
  return relative_path:gsub("/", "."):gsub("^%.", "")
end

-- Load all Lua files recursively from a given directory
local function load_modules(dir)
  dir = normalize_path(dir)
  local modules = vim.fn.globpath(dir, "**/*.lua", true, true) -- Find all Lua files recursively
  local base_module = get_base_module(dir) -- Dynamically determine the base module name

  for _, path in ipairs(modules) do
    local normalized = normalize_path(path)
    local module_name = normalized:gsub("^" .. dir:gsub("%.", "%%%.") .. "/?", ""):gsub("/", "."):gsub("%.lua$", "")

    -- Skip init.lua and excluded modules
    if module_name ~= "init" and not vim.tbl_contains(exclude, module_name) then
      local full_module = base_module .. "." .. module_name
      local ok, result = pcall(require, full_module)
      if ok then
        if type(result) == "table" then
          if vim.islist(result) then
            vim.list_extend(M, result)
          else
            table.insert(M, result)
          end
        end
      else
        vim.notify(('Failed to load module: %s\nReason: %s'):format(full_module, result), vim.log.levels.ERROR)
      end
    end
  end
end

-- Get the current script path (cross-platform compatibility)
local script_path = normalize_path(debug.getinfo(1, "S").source:sub(2))
local current_dir = vim.fn.fnamemodify(script_path, ":h")

load_modules(current_dir)

return M
