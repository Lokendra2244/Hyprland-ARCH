-- ============================================================
-- ~/.config/hypr/conf/autostart.lua
-- Autostart — runs once on hyprland.start
-- ============================================================
-- See https://wiki.hypr.land/Configuring/Basics/Autostart/
-- hl.exec_cmd() is fire-and-forget (no trailing & needed, unlike the
-- old exec-once lines).

hl.on("hyprland.start", function()
  hl.exec_cmd("nm-applet")
  hl.exec_cmd("clipse -listen")
  hl.exec_cmd("systemctl --user start hyprpolkitagent")
  hl.exec_cmd("/home/lokendra/.config/waybar/scripts/lookp.sh")
  hl.exec_cmd("~/.config/hypr/scripts/wall.sh")
  hl.exec_cmd("waybar")
  hl.exec_cmd("hypridle")
  hl.exec_cmd("wl-paste --type text --watch cliphist store")
  hl.exec_cmd("wl-paste --type image --watch cliphist store")
  hl.exec_cmd("waypaper --restore")
  hl.exec_cmd("sunsetr")
  hl.exec_cmd("$HOME/.config/hypr/scripts/waybar_auto_hide")
end)
