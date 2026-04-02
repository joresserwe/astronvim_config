return {
  "catgoose/nvim-colorizer.lua",
  event = "BufReadPre",
  opts = {
    user_default_options = {
      tailwind = true,
      css = true,
    },
    filetypes = {
      "*",
      css = {
        names = true,
      },
      html = {
        names = true,
      },
    },
  },
}
