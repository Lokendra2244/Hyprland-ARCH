-- ============================================================
-- ~/.config/hypr/conf/colors.lua
-- Pywal color integration
-- ============================================================
-- Your old conf did: source = /home/lokendra/.cache/wal/colors-hyprland.conf
-- Lua config needs the .lua template instead: pywal writes it out as
-- ~/.cache/wal/colors-hyprland.lua when you run: wal -i <wallpaper>
-- It returns a table, so we load it with dofile() and index into it.

local ok, wal = pcall(dofile, "/home/lokendra/.cache/theme/colors-hyprland.lua")

if ok and t then
	color1 = t.accent -- active border + HyprGlass tint
	color8 = t.color8 -- inactive border
else
	color1 = "rgb(89b4fa)"
	color8 = "rgb(45475a)"
end
