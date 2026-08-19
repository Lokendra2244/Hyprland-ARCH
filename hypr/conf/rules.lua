-- ============================================================
-- ~/.config/hypr/conf/rules.lua
-- Window rules · Layer rules
-- ============================================================
-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/

-- ============================================================
-- WINDOW RULES
-- ============================================================

-- Waypaper — floating picker at top-right
hl.window_rule({
	match = { class = "waypaper" },
	float = true,
	size = { 800, 900 },
	move = { 560, 90 },
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

-- clipse clipboard manager — launched as a floating kitty window
hl.window_rule({
	match = { class = "clipse" },
	float = true,
})

-- Idle inhibit: prevent sleep when any window is fullscreen
hl.window_rule({
	match = { fullscreen = true },
	idle_inhibit = "fullscreen",
})

-- ============================================================
-- LAYER RULES
-- ============================================================
-- See https://wiki.hypr.land/Configuring/Layer-Rules/

-- Logout dialog
hl.layer_rule({
	match = { namespace = "logout_dialog" },
	blur = true,
})

-- GTK layer shell (e.g. eww, nwg-bar)
hl.layer_rule({
	match = { namespace = "gtk-layer-shell" },
	blur = true,
})

-- Rofi launcher
hl.layer_rule({
	name = "launcher-styling",
	match = { namespace = "rofi" },
	blur = true,
	ignore_alpha = 0.3,
})

-- Waybar
hl.layer_rule({
	name = "bar-styling",
	match = { namespace = "waybar" },
	blur = true,
	ignore_alpha = 0.1,
})

--zen
hl.window_rule({
	match = { class = "zen" },
	opacity = "0.55 override 0.4 override",
})
