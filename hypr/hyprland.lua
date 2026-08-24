-- ============================================================
-- ~/.config/hypr/hyprland.lua
-- Main entry point — requires all sub-configs
-- ============================================================
-- Hyprland 0.55+ uses Lua instead of hyprlang (.conf).
-- Split into modules under ~/.config/hypr/conf/, same layout as
-- the Desktop branch of Hyprland-ARCH.
--
-- Load order matters: colors must come first (other modules read color vars).
-- Each require() runs in its own scope, so errors are isolated.
-- See https://wiki.hypr.land/Configuring/Start/
-- ============================================================

-- 1. Colors — pywal integration / manual fallbacks
require("conf.colors")

-- 2. Monitors, XWayland
require("conf.monitors")

-- 3. Environment variables, ecosystem settings, screencopy permissions
require("conf.environment")

-- 4. Autostart programs (via hyprland.start event)
require("conf.autostart")

-- 5. Look & feel: general, decoration, animations, misc, layouts
require("conf.look_and_feel")

-- 5b. HyprGlass — liquid glass effect (inert: plugin not installed, see conf/look.lua)
require("conf.look")

-- 6. Input: keyboard, mouse, touchpad, gestures, per-device
require("conf.input")

-- 7. Keybindings
require("conf.keybinds")

-- 8. Window rules and layer rules
require("conf.rules")
