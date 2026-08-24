-- ============================================================
-- ~/.config/hypr/conf/monitors.lua
-- Monitors · XWayland
-- ============================================================
-- See https://wiki.hypr.land/Configuring/Basics/Monitors/

hl.monitor({
  output   = "eDP-1",
  mode     = "1920x1080@60.01",
  position = "0x0",
  scale    = 1.00,
})

-- Mirrors eDP-1, same as your old `monitor=HDMI-A-1,...,mirror,eDP-1` line
hl.monitor({
  output   = "HDMI-A-1",
  mode     = "1920x1080@60.00",
  position = "1920x0",
  scale    = 1.00,
  mirror   = "eDP-1",
})

-- Force XWayland apps to not be scaled up (keeps them sharp at 1:1)
hl.config({
  xwayland = {
    force_zero_scaling = true,
  },
})
