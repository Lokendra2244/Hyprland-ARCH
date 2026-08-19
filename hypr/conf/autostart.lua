-- ============================================================
-- ~/.config/hypr/conf/autostart.lua
-- Autostart — runs once on hyprland.start
-- ============================================================
-- See https://wiki.hypr.land/Configuring/Basics/Autostart/
-- hl.exec_cmd() is fire-and-forget (no & needed).

hl.on("hyprland.start", function()
	hl.exec_cmd("nm-applet")
	hl.exec_cmd("systemctl --user start hyprpolkitagent")
	hl.exec_cmd("/home/lokendra/.config/waybar/scripts/lookp.sh")
	hl.exec_cmd("sleep 2 && waypaper --restore")
	hl.exec_cmd("waybar")
	hl.exec_cmd("hypridle")
	hl.exec_cmd("wl-paste --type text --watch cliphist store")
	hl.exec_cmd("wl-paste --type image --watch cliphist store")
	hl.exec_cmd("sh -c 'hyprpm reload -n && hyprctl reload'")
	hl.exec_cmd("waybar-autohide")
	hl.exec_cmd("sunsetr")
	hl.exec_cmd("sunshine")
	hl.exec_cmd("$HOME/.config/hypr/scripts/waybar_auto_hide &")
end)
