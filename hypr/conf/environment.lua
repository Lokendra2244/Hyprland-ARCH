-- ============================================================
-- ~/.config/hypr/conf/environment.lua
-- Environment variables · Ecosystem · Permissions
-- ============================================================

-- See https://wiki.hypr.land/Configuring/Environment-variables/
-- NOTE: If you run Hyprland via uwsm, prefer putting env vars in
--       ~/.config/uwsm/env-hyprland instead of here.

hl.env("TERM", "ghostty")
hl.env("HYPRCURSOR_THEME", "Nordic-cursors")
hl.env("HYPRCURSOR_SIZE", "28")
hl.env("XCURSOR_THEME", "Nordic-cursors")
hl.env("XCURSOR_SIZE", "28")

-- ============================================================
-- Ecosystem — permission enforcement
-- Set enforce_permissions = 1 to enable strict permission checks
-- ============================================================
hl.config({
	ecosystem = {
		enforce_permissions = 0,
	},
})

-- ============================================================
-- Screencopy / plugin permissions
-- See https://wiki.hypr.land/Configuring/Permissions/
-- Note: Changes here require a Hyprland restart.
-- API: hl.permission({ binary = "...", type = "...", mode = "allow" })
-- ============================================================
local function allow_screencopy(binary)
	hl.permission({ binary = binary, type = "screencopy", mode = "allow" })
end

allow_screencopy("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland")
allow_screencopy("/usr/bin/grim")
allow_screencopy("/usr/bin/hyprshot")
allow_screencopy("/usr/bin/hyprpicker")
allow_screencopy("/usr/bin/hyprlock")
allow_screencopy("/usr/(bin|local/bin)/hyprpm")
allow_screencopy("/usr/bin/sunshine")
allow_screencopy("/usr/bin/wayvnc")

hl.permission({ binary = "/usr/(bin|local/bin)/hyprpm", type = "plugin", mode = "allow" })
