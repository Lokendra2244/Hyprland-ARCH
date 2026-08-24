-- ============================================================
-- ~/.config/hypr/conf/rules.lua
-- Window rules · Layer rules
-- ============================================================
-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/

-- ============================================================
-- WINDOW RULES
-- ============================================================

-- Waypaper — floating picker, top-right-ish
hl.window_rule({
  match = { class = "waypaper" },
  float = true,
  size = { 800, 900 },
  move = { 560, 90 },
})

-- clipse clipboard manager — small, stays focused
hl.window_rule({
  match = { class = "clipse" },
  float = true,
  size = { 220, 150 },
  stay_focused = true,
})

-- PulseAudio volume control — floating, top-centre
hl.window_rule({
  match = { class = "org.pulseaudio.pavucontrol" },
  float = true,
  size = { 800, 500 },
  move = { 825, 60 },
})

-- Spotify — extra transparent
hl.window_rule({
  match = { class = "Spotify" },
  opacity = "0.6 override 0.4 override",
})

-- Idle inhibit whenever a window is fullscreen. Kept as three rules,
-- same as the old conf's ^(*)$ boilerplate (class / title / fullscreen)
-- — translated to plain regex for the new match fields.
hl.window_rule({
  match = { class = ".*" },
  idle_inhibit = "fullscreen",
})
hl.window_rule({
  match = { title = ".*" },
  idle_inhibit = "fullscreen",
})
hl.window_rule({
  match = { fullscreen = true },
  idle_inhibit = "fullscreen",
})

-- ============================================================
-- LAYER RULES
-- ============================================================
-- See https://wiki.hypr.land/Configuring/Layer-Rules/
-- (for apps Hyprland doesn't affect directly, e.g. the logout menu)

hl.layer_rule({
  name = "waybar",
  match = { namespace = "waybar" },
  blur = true,
  ignore_alpha = 0,
})

hl.layer_rule({
  match = { namespace = "logout_dialog" },
  blur = true,
})

hl.layer_rule({
  match = { namespace = "gtk-layer-shell" },
  blur = true,
})

hl.layer_rule({
  name = "rofi",
  match = { namespace = "rofi" },
  blur = true,
  ignore_alpha = 0,
})
