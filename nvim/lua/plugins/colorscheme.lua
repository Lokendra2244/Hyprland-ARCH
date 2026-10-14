return {
  "RRethy/base16-nvim",
  lazy = false,
  priority = 1000,
  config = function()
    local ok, pal = pcall(dofile, vim.fn.expand("~/.cache/theme/base16.lua"))
    if ok and pal then
      require("base16-colorscheme").setup(pal)
    end
  end,
}
