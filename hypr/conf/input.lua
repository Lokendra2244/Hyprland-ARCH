-- ============================================================
-- ~/.config/hypr/conf/input.lua
-- Input · Gestures · Per-device config
-- ============================================================

hl.config({
	input = {
		kb_layout = "us",
		kb_variant = "",
		kb_model = "",
		kb_options = "",
		kb_rules = "",

		follow_mouse = 1,
		sensitivity = 0.6, -- range: -1.0 to 1.0 (0 = no modification)
		accel_profile = "flat",

		touchpad = {
			natural_scroll = true,
		},
	},
})

-- Touchpad multi-finger gestures
-- 3-finger horizontal swipe → switch workspace (0.5x scale)
hl.gesture({
	fingers = 3,
	direction = "horizontal",
	scale = 0.5,
	action = "workspace",
})

-- Per-device overrides
-- See https://wiki.hypr.land/Configuring/Keywords/#per-device-input-configs
hl.device({
	name = "epic-mouse-v1",
	sensitivity = 0,
})
