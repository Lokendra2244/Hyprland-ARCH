-- ============================================================
-- ~/.config/hypr/conf/environment.lua
-- Environment variables · Ecosystem · Permissions
-- ============================================================
-- See https://wiki.hypr.land/Configuring/Environment-variables/

hl.env("TERM", "ghostty")
hl.env("XCURSOR_THEME", "Moga-Neon-Butter") -- Replace with your desired theme name
hl.env("XCURSOR_SIZE", "32")

-- ============================================================
-- Ecosystem — permission enforcement
-- Note: changes here require a Hyprland restart, not applied on-the-fly
-- ============================================================
hl.config({
  ecosystem = {
    enforce_permissions = 1,
  },
})

-- ============================================================
-- Screencopy / plugin permissions
-- See https://wiki.hypr.land/Configuring/Permissions/
-- ============================================================
hl.permission({ binary = "/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", type = "screencopy", mode = "allow" })
hl.permission({ binary = "/usr/(bin|local/bin)/hyprpm", type = "plugin", mode = "allow" })
hl.permission({ binary = "/usr/bin/grim", type = "screencopy", mode = "allow" })
hl.permission({ binary = "/usr/bin/hyprlock", type = "screencopy", mode = "allow" })
