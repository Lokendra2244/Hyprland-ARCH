-- ============================================================
-- ~/.config/hypr/conf/colors.lua
-- Pywal color integration
-- ============================================================
-- Pywal generates ~/.cache/wal/colors-hyprland.lua automatically
-- when you run: wal -i <wallpaper>
-- It returns a table, so we load it with dofile() and index into it.

local ok, wal = pcall(dofile, "/home/lokendra/.cache/wal/colors-hyprland.lua")

if ok and wal then
  color1 = wal.color1   -- active border
  color8 = wal.color8   -- inactive border
else
  -- Fallback if wal cache is missing (e.g. first boot before wal has run)
  color1 = "rgb(832a40)"
  color8 = "rgb(5c5c70)"
end
