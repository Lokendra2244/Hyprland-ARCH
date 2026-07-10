#!/bin/bash

# Get the Active Connection Name (e.g., "Wired connection 1" or "My_Office_VPN")
# -t = terse (script friendly), -f = fields
name=$(nmcli -t -f NAME,TYPE connection show --active | grep "802-3-ethernet" | cut -d: -f1 | head -n1)

# If no connection is active, show nothing or "Offline"
if [ -z "$name" ]; then
  echo ""
else
  # Output JSON for Waybar
  # You can change the icon () here if you want
  echo "{\"text\":\" $name\", \"class\":\"connected\"}"
fi
