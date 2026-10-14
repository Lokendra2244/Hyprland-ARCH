return {
  "nvim-mini/mini.hipatterns",
  opts = function(_, opts)
    local hi = require("mini.hipatterns")

    opts.highlighters = vim.tbl_extend("force", opts.highlighters or {}, {
      -- 1. Quoted 6-digit hex without '#' (e.g. "181818" or 'd08770')
      hex_quoted = {
        pattern = "[\"']()%x%x%x%x%x%x()[\"']",
        group = function(_, match)
          return hi.compute_hex_color_group("#" .. match, "bg")
        end,
        extmark_opts = { priority = 2000 },
      },

      -- 2. Base16 keys (e.g. base00: 181818 or base0A = "fab387")
      base16_key = {
        pattern = "base%x%x%s*[:=]%s*['\"]?()%x%x%x%x%x%x()['\"]?",
        group = function(_, match)
          return hi.compute_hex_color_group("#" .. match, "bg")
        end,
        extmark_opts = { priority = 2000 },
      },
    })
  end,
}
