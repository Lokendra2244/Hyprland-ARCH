-- ============================================================
-- CLAMSHELL MODE  (internal display vs external monitor)
-- ============================================================
local INTERNAL = "eDP-1"

-- best-effort sync at config load — if eDP-1 isn't in the active
-- monitor list right now, assume it's currently disabled
local internal_disabled = (hl.get_monitor(INTERNAL) == nil)

local function set_internal(disabled)
	hl.monitor({ output = INTERNAL, disabled = disabled })
	internal_disabled = disabled
end

local function external_connected()
	for _, mon in ipairs(hl.get_monitors()) do
		if mon.name ~= INTERNAL then
			return true
		end
	end
	return false
end

-- Lid closed: only turn the panel off if something else is actually
-- driving the desktop. No external monitor = leave it alone.
hl.bind("switch:on:Lid Switch", function()
	if external_connected() then
		set_internal(true)
	end
end, { locked = true })

-- Lid opened: always bring the internal panel back
hl.bind("switch:off:Lid Switch", function()
	set_internal(false)
end, { locked = true })

-- External monitor unplugged: if the internal panel is currently off,
-- bring it back immediately — same effect as opening the lid — so you
-- never end up with zero active outputs if the cable comes out before
-- you open the laptop
hl.on("monitor.removed", function(mon)
	if mon.name ~= INTERNAL and internal_disabled then
		set_internal(false)
	end
end)
