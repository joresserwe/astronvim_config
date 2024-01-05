return {
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  },
  {
    "nvim-telescope/telescope.nvim",
    config = function(_, opts)
      local utils = require "../../astronvim/utils"
      local telescope = require "telescope"
      local action = require "telescope.actions"
      local fb_action = require "telescope._extensions.file_browser.actions"
      opts.extensions = {
        file_browser = {
          theme = "dropdown",
          hijack_netrw = true,
          path = "%:p:h",
          cwd = vim.fn.expand "%:p:h",
          respect_gitignore = false,
          hidden = true,
          grouped = true,
          previewer = false,
          initial_mode = "normal",
          layout_config = { height = 20 },
          mappings = {
            n = {
              ["."] = fb_action.change_cwd,
              ["h"] = fb_action.goto_parent_dir,
              ["l"] = action.select_default,
              ["o"] = action.select_default,
              ["O"] = fb_action.open,
              ["r"] = fb_action.rename,
              ["H"] = fb_action.toggle_hidden,
              ["-"] = action.select_horizontal,
              ["\\"] = action.select_vertical,
              ["<bs>"] = fb_action.backspace,
              ["<C-k>"] = action.move_selection_previous,
              ["<C-j>"] = action.move_selection_next,
            },
            i = {
              ["<C-k>"] = action.move_selection_previous,
              ["<C-j>"] = action.move_selection_next,
            },
          },
        },
      }
      utils.conditional_func(telescope.load_extension, pcall(require, "file_browser"), "file_browser")
      telescope.setup(opts)
    end,
  },
}
