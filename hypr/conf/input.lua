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

    accel_profile = "flat",
    follow_mouse = 1,
    sensitivity = 0.8, -- range: -1.0 to 1.0 (0 = no modification)

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

-- Example per-device override
-- See https://wiki.hypr.land/Configuring/Keywords/#per-device-input-configs
hl.device({
  name = "epic-mouse-v1",
  sensitivity = 0,
})
