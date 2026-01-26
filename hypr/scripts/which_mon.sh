#!/bin/bash

# 1. Defaults
target_ws=${1:-1}
action=${2:-workspace}

# 2. Get Monitor Info (Requires 'jq')
mon_data=$(hyprctl monitors -j | jq '.[] | select(.focused == true)')
active_mon=$(echo "$mon_data" | jq -r '.name')
current_ws=$(echo "$mon_data" | jq -r '.activeWorkspace.id')

# 3. Calculate Target
# If on HDMI (Right), add 10 to the target (1 -> 11)
if [[ "$active_mon" == "HDMI-A-3" ]]; then
    final_ws=$((target_ws + 10))
else
    # DP-1 (Left) stays 1-4
    final_ws=$target_ws
fi

# 4. SAFETY CHECK:
# If we are already on the target workspace, do nothing.
if [ "$action" == "workspace" ] && [ "$current_ws" -eq "$final_ws" ]; then
    exit 0
fi

# 5. Execute
hyprctl dispatch $action $final_ws
