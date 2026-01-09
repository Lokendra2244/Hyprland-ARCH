#!/bin/bash

map_file="$HOME/.cache/class_name_map"

# Loop forever (Waybar reads the continuous output)
while true; do
    window_class=""
    desktop=$(echo "$XDG_CURRENT_DESKTOP" | tr '[:upper:]' '[:lower:]')
    
    # Fallback detection
    if [ -z "$desktop" ]; then
        if pgrep -x "Hyprland" >/dev/null; then desktop="hyprland"; fi
        if pgrep -x "niri" >/dev/null; then desktop="niri"; fi
    fi

    # Fetch Class
    if [[ "$desktop" == *"hyprland"* ]]; then
        window_class=$(hyprctl activewindow -j 2>/dev/null | jq -r '.class')
    elif [[ "$desktop" == *"niri"* ]]; then
        window_class=$(niri msg -j focused-window 2>/dev/null | jq -r '.app_id')
    fi

    # Lookup Name
    if [ "$window_class" == "null" ] || [ -z "$window_class" ]; then
        echo "..."
    else
        pretty_name=$(grep -i -m 1 "^$window_class|" "$map_file" | cut -d'|' -f2)
        if [ -n "$pretty_name" ]; then
            echo "$pretty_name"
        else
            echo "$window_class"
        fi
    fi

    # Wait 0.5s before checking again (Lower = smoother but more CPU)
    sleep 0.5
done
