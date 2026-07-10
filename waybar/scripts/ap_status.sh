#!/bin/bash
SSID="AMBHI-Arch"

# 1. If the hotspot is already ON, always show it
if nmcli connection show --active | grep -qw "$SSID"; then
  echo " [ AP: ON 🚀 ] "
  exit 0
fi

# 2. If the hotspot is OFF, only show the button if Ethernet is plugged in
if nmcli -t -f TYPE connection show --active | grep -q "ethernet"; then
  echo " [ AP: OFF 📴 ] "
else
  # We are on Wi-Fi (or offline), hide the useless button completely
  echo ""
fi
