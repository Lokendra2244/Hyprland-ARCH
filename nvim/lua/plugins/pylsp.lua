return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      pylsp = {
        settings = {
          pylsp = {
            plugins = {
              pycodestyle = {
                -- Ignore the E501 "line too long" error entirely
                ignore = { "E501", "W391" },
              },
            },
          },
        },
      },
    },
  },
}
