#!/bin/bash

HOTSPOT_SSID="AMBHI-Arch"

# Correctly search for "802-11-wireless" instead of ":wireless"
CURRENT_WIFI=$(nmcli -t -f NAME,TYPE connection show --active | grep "802-11-wireless" | cut -d: -f1 | head -n1)

# Only output if connected to Wi-Fi AND it is not the hotspot
if [ -n "$CURRENT_WIFI" ] && [ "$CURRENT_WIFI" != "$HOTSPOT_SSID" ]; then
  # Grab the signal strength safely
  SIGNAL=$(nmcli -t -f IN-USE,SIGNAL device wifi list | grep '^\*' | cut -d: -f2)
  echo " [ ${SIGNAL}%   ${CURRENT_WIFI} ] "
else
  # Output nothing, hiding the module
  echo ""
fi
