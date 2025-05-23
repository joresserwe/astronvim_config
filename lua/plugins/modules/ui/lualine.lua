local colors = {
  none = "none",
  blue = "#80a0ff",
  cyan = "#79dac8",
  black = "#080808",
  white = "#c6c6c6",
  red = "#ff5189",
  violet = "#d183e8",
  grey = "#303030",
  lightgrey = "#777777",
}

local bubbles_theme = {
  normal = {
    a = { fg = colors.black, bg = colors.violet },
    b = { fg = colors.white, bg = colors.grey },
    c = { fg = colors.none, bg = colors.none },
  },

  insert = { a = { fg = colors.black, bg = colors.blue } },
  visual = { a = { fg = colors.black, bg = colors.cyan } },
  replace = { a = { fg = colors.black, bg = colors.none } },

  inactive = {
    a = { fg = colors.white, bg = colors.none },
    b = { fg = colors.white, bg = colors.none },
    c = { fg = colors.lightgrey, bg = colors.none },
  },
}

-- Multicursor
local function is_active()
  local ok, hydra = pcall(require, "hydra.statusline")
  return ok and hydra.is_active()
end

local function get_name()
  local ok, hydra = pcall(require, "hydra.statusline")
  if ok then return hydra.get_name() end
  return ""
end

return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        theme = bubbles_theme,
        -- theme = "vscode",
        component_separators = "|",
        section_separators = { left = "", right = "" },
        disabled_filetypes = { "neo-tree", "qf" },
        ignore_focus = {
          "qf",
          "neo-tree",
          "toggleterm",
          "telescopePrompt",
          "mason",
          "lazy",
          "newtr",
        },
      },
      sections = {
        lualine_a = {
          { "mode", separator = { left = "" } },
          --{ "vim.fn['zoom#statusline']()", separator = { right = "" }, padding = { right = 1 } },
        },
        lualine_b = {
          { "filename", path = 1 },
          "branch",
          { get_name, cond = is_active },
        },
        -- lualine_c = { 'fileformat' },
        lualine_c = {
          -- {
          --   "filename",
          --   file_status = true, -- displays file status (readonly status, modified status)
          --   path = 0, -- 0 = just filename, 1 = relative path, 2 = absolute path
          -- },
        },
        lualine_x = {
          {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            symbols = { error = " ", warn = " ", info = " ", hint = " " },
          },
          "encoding",
        },
        lualine_y = { "filetype", "progress" },
        lualine_z = {
          { "location", separator = { right = "" }, left_padding = 2 },
        },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          {
            "filename",
            file_status = true, -- displays file status (readonly status, modified status)
            path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
          },
        },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      extensions = { "fugitive" },
    },
  },
  {
    "rebelot/heirline.nvim",
    optional = true,
    opts = function(_, opts) opts.statusline = nil end,
  },
}
