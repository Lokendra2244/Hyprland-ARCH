-- ============================================================
-- HYPRGLASS — Liquid Glass effect
-- https://github.com/hyprnux/hyprglass
--
-- NOT INSTALLED YET. This whole block is guarded behind
-- `if hl.plugin.hyprglass then`, so it's a no-op right now —
-- nothing here runs until you `hyprpm add`/`hyprpm enable` the
-- plugin. Left in place (rather than deleted) so it's ready to
-- go the moment it's installed; safe to leave required in
-- hyprland.lua either way.
-- ============================================================
if hl.plugin.hyprglass then
  local hg = hl.plugin.hyprglass

  -- color1 comes from conf/colors.lua (pywal), format "rgb(RRGGBB)".
  -- Converts it into hyprglass's 0xRRGGBBAA tint format so the glass
  -- tint follows your wallpaper the same way your borders already do.
  local function tint_from_wal(rgb_str, alpha)
    alpha = alpha or "22"
    local hex = rgb_str and rgb_str:match("rgb%((%x+)%)")
    if not hex then
      return 0x1a1c2622 -- fallback: cool dark tint if wal cache is missing
    end
    return tonumber(hex .. alpha, 16)
  end

  hg.config({
    default_theme = "dark",
    default_preset = "glass",
    tint_color = tint_from_wal(color1, "22"),

    dark = {
      brightness = 1,
      contrast = 1,
      saturation = 1,
      vibrancy = 0,
      adaptive_dim = 0.35,
    },

    layers = { enabled = 1 },
  })

  -- ------------------------------------------------------------
  -- Layer surfaces
  -- ------------------------------------------------------------
  hg.layer("waybar", { preset = "glass", mask_threshold = 0.01 })
  hg.layer("rofi", { preset = "glass", mask_threshold = 0.6 })

  hg.preset("glass", {
    glass_opacity = 0.8,
    blur_strength = 0.4,
    chromatic_aberration = 0.1,
    fresnel_strength = 2.3,
    edge_thickness = 0.07,
    lens_distortion = 4,
    refraction_strength = 4,
  })

  -- ------------------------------------------------------------
  -- Per-window overrides
  -- ------------------------------------------------------------
  hl.window_rule({ match = { class = "mpv" }, tag = "+hyprglass_disabled" })
end
