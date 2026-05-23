-- ============================================================
-- ~/.config/hypr/conf/monitors.lua
-- Monitors · XWayland · Workspace rules
-- ============================================================

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/

hl.monitor({
  output   = "DP-1",
  mode     = "1920x1080@100",
  position = "1920x0",
  scale    = 1.0,
})

-- Force XWayland apps to not be scaled up (keeps them sharp at 1:1)
hl.config({
  xwayland = {
    force_zero_scaling = true,
  },
})

-- Pin each workspace to DP-1
-- (mirrors the `workspace = N, monitor:DP-1` lines from the old conf)
for _, ws in ipairs({ "1", "2", "3", "4" }) do
  hl.workspace_rule({ workspace = ws, monitor = "DP-1" })
end
