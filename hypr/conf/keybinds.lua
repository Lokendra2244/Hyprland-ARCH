-- ============================================================
-- ~/.config/hypr/conf/keybinds.lua
-- Keybindings
-- ============================================================
-- See https://wiki.hypr.land/Configuring/Basics/Binds/

local M = "SUPER" -- main modifier (Windows key)

-- Programs
local terminal = "ghostty"
local fileManager = "ghostty -e yazi"
local menu = "rofi"

-- Shorthand helpers
local exec = hl.dsp.exec_cmd
local dsp = hl.dsp

-- ============================================================
-- CORE APP LAUNCHERS
-- ============================================================
hl.bind(M .. " + Q", exec(terminal))
hl.bind(M .. " + C", dsp.window.kill())
hl.bind(M .. " + E", exec(fileManager))
hl.bind(M .. " + W", dsp.window.float({ action = "toggle" }))
hl.bind(M .. " + F", dsp.window.fullscreen())
hl.bind(M .. " + P", dsp.window.pseudo()) -- pseudo-tile (dwindle; harmless on scrolling)
hl.bind(M .. " + l", exec("wlogout"))

-- Wallpaper toggle
hl.bind(M .. " + H", exec("killall waypaper || waypaper"))

-- App launcher (toggle rofi)
hl.bind(M .. " + SPACE", exec(menu .. " -show drun -show-icons || killall " .. menu))

-- Browser
hl.bind(M .. " + B", exec("zen-browser"))

-- Colour picker
hl.bind("CTRL + p", exec("hyprpicker"))

-- Emoji picker
hl.bind(M .. " + period", exec(menu .. " -show emoji || killall " .. menu))

-- Waybar toggle script
hl.bind(M .. " + Z", exec("/home/lokendra/.config/hypr/scripts/barstart.sh"))

-- Cava / clock overlay
hl.bind(M .. " + ALT_L + C", exec("/home/lokendra/.config/hypr/scripts/cava.sh"))
hl.bind("CTRL + ALT_L + C", exec("/home/lokendra/.config/waybar/scripts/clock.sh"))

-- Bluetooth picker
hl.bind(M .. " + ALT_L + B", exec("/home/lokendra/rofi-bluetooth/rofi-bluetooth"))

-- Clipboard manager (cliphist → rofi → wl-copy)
hl.bind(
	M .. " + V",
	exec("killall " .. menu .. " || cliphist list | " .. menu .. " -dmenu | cliphist decode | wl-copy")
)

-- VPN / caden login helper
hl.bind(M .. " + SHIFT + V", exec("/home/lokendra/Downloads/cadenlogin.sh"))

-- ============================================================
-- SCREENSHOTS  (hyprshot)
-- ============================================================
hl.bind(M .. " + Print", exec("hyprshot -m window --freeze"))
hl.bind("Print", exec("hyprshot -m output --freeze"))
hl.bind(M .. " + SHIFT + Print", exec("hyprshot -m region --freeze"))

-- ============================================================
-- AUDIO / VOLUME  (wpctl)
-- ============================================================
hl.bind(
	"XF86AudioRaiseVolume",
	exec("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind("XF86AudioLowerVolume", exec("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", exec("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute", exec("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })

-- ============================================================
-- BACKLIGHT  (brightnessctl)
-- ============================================================
hl.bind("XF86MonBrightnessUp", exec("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", exec("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- XF86Tools / XF86AudioStop repurposed as backlight keys
hl.bind("XF86Tools", exec("/home/lokendra/.config/waybar/scripts/backlight_control.sh 5%-"), { locked = true })
hl.bind("XF86AudioStop", exec("/home/lokendra/.config/waybar/scripts/backlight_control.sh 5%+"), { locked = true })

-- ============================================================
-- MEDIA PLAYBACK  (playerctl → ncspot)
-- ============================================================
hl.bind("XF86AudioNext", exec("playerctl --player=ncspot next"), { locked = true })
hl.bind("XF86AudioPause", exec("playerctl --player=ncspot play-pause"), { locked = true })
hl.bind("XF86AudioPlay", exec("playerctl --player=ncspot play-pause"), { locked = true })
hl.bind("XF86AudioPrev", exec("playerctl --player=ncspot previous"), { locked = true })

-- ============================================================
-- WINDOW FOCUS  (arrow keys)
-- Direction strings must be full words: "left"/"right"/"up"/"down"
-- ============================================================
hl.bind(M .. " + Left", dsp.focus({ direction = "left" }))
hl.bind(M .. " + Right", dsp.focus({ direction = "right" }))
hl.bind(M .. " + Up", dsp.focus({ direction = "up" }))
hl.bind(M .. " + Down", dsp.focus({ direction = "down" }))

-- ============================================================
-- WORKSPACE SWITCHING  (1–4, all on DP-1)
-- dsp.focus({ workspace = N }) is the correct Lua API for
-- switching workspaces (replaces the old `workspace, N` dispatch).
-- ============================================================
for i = 1, 4 do
	hl.bind(M .. " + " .. i, dsp.focus({ workspace = i }))
	hl.bind(M .. " + SHIFT + " .. i, dsp.window.move({ workspace = i }))
end

-- Relative workspace navigation (e+1 / e-1 syntax)
-- dsp.workspace.relative() does NOT exist — use dsp.focus({ workspace = "e±N" })
hl.bind(M .. " + ALT_L + Down", dsp.focus({ workspace = "e+1" }))
hl.bind(M .. " + ALT_L + Up", dsp.focus({ workspace = "e-1" }))

-- ============================================================
-- SPECIAL WORKSPACE  (scratchpad)
-- ============================================================
hl.bind(M .. " + S", dsp.workspace.toggle_special("magic"))
hl.bind(M .. " + SHIFT + S", dsp.window.move({ workspace = "special:magic" }))

-- ============================================================
-- WINDOW RESIZE  (keyboard)
-- dsp.window.resize() handles both mouse and keyboard resize.
-- For keyboard: pass { x, y, relative = true }
-- ============================================================
hl.bind(M .. " + SHIFT + Right", dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true })
hl.bind(M .. " + SHIFT + Left", dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })
hl.bind(M .. " + SHIFT + Up", dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true })
hl.bind(M .. " + SHIFT + Down", dsp.window.resize({ x = 0, y = 10, relative = true }), { repeating = true })

-- ============================================================
-- MOVE / RESIZE  (mouse drag)
-- ============================================================
hl.bind(M .. " + mouse:272", dsp.window.drag(), { mouse = true })
hl.bind(M .. " + mouse:273", dsp.window.resize(), { mouse = true })

-- ============================================================
-- FLOATING WINDOW CYCLE  (Super+Tab)
-- ============================================================
hl.bind("SUPER + Tab", function()
	hl.dispatch(dsp.window.cycle_next())
	hl.dispatch(dsp.window.bring_to_top())
end)

-- ============================================================
-- SCROLLING LAYOUT CONTROLS
-- hl.dsp.layout() is the Lua equivalent of the old `layoutmsg` dispatcher.
-- See https://wiki.hypr.land/Configuring/Scrolling-Layout/
-- ============================================================

-- Scroll the tape left / right (independent of window focus)
hl.bind(M .. " + mouse_down", dsp.layout("move -col"))
hl.bind(M .. " + mouse_up", dsp.layout("move +col"))

-- Swap column with its left / right neighbour
hl.bind(M .. " + SHIFT + bracketleft", dsp.layout("swapcol l"))
hl.bind(M .. " + SHIFT + bracketright", dsp.layout("swapcol r"))

-- Cycle through explicit_column_widths (defined in look_and_feel.lua)
hl.bind(M .. " + equal", dsp.layout("colresize +conf"))
hl.bind(M .. " + minus", dsp.layout("colresize -conf"))

-- Promote focused window to its own column
hl.bind(M .. " + SHIFT + P", dsp.layout("promote"))

-- Fit the active column to the screen width
hl.bind(M .. " + M", dsp.layout("fit active"))

-- ============================================================
-- REMOTE CONNECTION KEYBIND RESET
-- Empty submap = Hyprland stops consuming keys, so everything
-- passes through to the focused app (e.g. a VNC/RDP window).
-- SUPER+Escape again backs out via "reset".
-- ============================================================
hl.define_submap("passthrough", function()
	hl.bind(M .. " + Escape", dsp.submap("reset"))
end)

hl.bind(M .. " + Escape", dsp.submap("passthrough"))
