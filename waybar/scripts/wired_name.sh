#!/bin/bash

# Get the Active Connection Name (e.g., "Wired connection 1" or "My_Office_VPN")
# -t = terse (script friendly), -f = fields
name=$(nmcli -t -f NAME connection show --active | head -n1)

# If no connection is active, show nothing or "Offline"
if [ -z "$name" ]; then
    echo "{\"text\":\"Offline\", \"class\":\"disconnected\"}"
else
    # Output JSON for Waybar
    # You can change the icon () here if you want
    echo "{\"text\":\" $name\", \"class\":\"connected\"}"
fi
