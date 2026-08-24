-- ============================================================
-- ~/.config/hypr/conf/look_and_feel.lua
-- General · Decoration · Animations · Misc · Layouts
-- ============================================================
-- hl.config() calls can be split or merged — all are cumulative.

-- ------------------------------------------------------------
-- GENERAL
-- ------------------------------------------------------------
-- color1 / color8 are defined in conf/colors.lua
hl.config({
  general = {
    gaps_in = 0,
    gaps_out = 0,
    border_size = 2,
    ["col.active_border"] = color1,
    ["col.inactive_border"] = color8,
    resize_on_border = false,
    allow_tearing = false,
    layout = "scrolling",
  },
})

-- ------------------------------------------------------------
-- DECORATION
-- ------------------------------------------------------------
hl.config({
  decoration = {
    rounding = 7,
    rounding_power = 3,
    active_opacity = 0.50,
    inactive_opacity = 0.20,

    shadow = {
      enabled = true,
      range = 60,
      render_power = 2,
      color = "rgba(000000ff)",
    },

    blur = {
      enabled = true,
      size = 1,
      passes = 6,
      brightness = 0.6,
    },
  },
})

-- ------------------------------------------------------------
-- ANIMATIONS
-- See https://wiki.hypr.land/Configuring/Animations/
-- ------------------------------------------------------------
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1.0 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
-- layersIn/layersOut drive rofi + hyprlock's popup animation — matched
-- to the Desktop branch's "slidefadevert 10%" rather than the old
-- conf's plain "fade" style.
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "slidefadevert 10%" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "slidefadevert 10%" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })

-- Workspace navigation animations — matched to the Desktop branch's
-- values (speed 3, slidefadevert 60%) rather than the old conf's
-- speed 1 / "slide" style.
hl.animation({ leaf = "workspaces", enabled = true, speed = 3, bezier = "almostLinear", style = "slidefadevert 60%" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 3, bezier = "almostLinear", style = "slidefadevert 60%" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 3, bezier = "almostLinear", style = "slidefadevert 60%" })

-- ------------------------------------------------------------
-- MISC
-- ------------------------------------------------------------
hl.config({
  misc = {
    force_default_wallpaper = 0,
    disable_hyprland_logo = true,
  },
})

-- ------------------------------------------------------------
-- MASTER LAYOUT (kept even though active layout is scrolling)
-- ------------------------------------------------------------
hl.config({
  master = {
    new_status = "master",
  },
})

-- ------------------------------------------------------------
-- SCROLLING LAYOUT
-- See https://wiki.hypr.land/Configuring/Scrolling-Layout/
-- ------------------------------------------------------------
hl.config({
  scrolling = {
    fullscreen_on_one_column = true,
    column_width = 0.7,
    focus_fit_method = 1,
    follow_focus = false,
    explicit_column_widths = "0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0",
  },
})
