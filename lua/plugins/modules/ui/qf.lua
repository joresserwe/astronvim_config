---@type LazySpec
return {
  "kevinhwang91/nvim-bqf",
  dependencies = {
    { "junegunn/fzf", run = function() vim.fn["fzf#install"]() end },
  },
  event = "VeryLazy",
  ft = "qf",
  opts = {
    auto_enable = true,
    auto_resize_height = true,
    preview = {
      win_height = 12,
      win_vsplit = true,
    },
    filter = {
      fzf = {
        extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
      },
    },
  },
}
