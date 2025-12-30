#!/usr/bin/env bash

WALLPAPER_DIR="/home/lokendra/wallpaper"
MONITOR="eDP-1"
MONITOR1="HDMI-A-1"
WALL_LIST="$HOME/.cache/wallpapers.list"
LAST_USED="$HOME/.cache/last_wallpaper.txt"

# Generate wallpaper list if it doesn't exist
find "$WALLPAPER_DIR" -type f -iregex ".*\.\(jpg\|jpeg\|png\)" | sort >"$WALL_LIST"

# Read wallpapers into an array
mapfile -t WALLPAPERS <"$WALL_LIST"

# Find index of last used wallpaper
LAST_INDEX=0
LAST_WALL=""
if [ -f "$LAST_USED" ]; then
    LAST_WALL=$(cat "$LAST_USED")
    for i in "${!WALLPAPERS[@]}"; do
        [[ "${WALLPAPERS[$i]}" == "$LAST_WALL" ]] && LAST_INDEX=$i && break
    done
fi

# Calculate next wallpaper index (wrap around)
NEXT_INDEX=$(((LAST_INDEX + 1) % ${#WALLPAPERS[@]}))
WALLPAPER="${WALLPAPERS[$NEXT_INDEX]}"

# Validate the file
if ! identify "$WALLPAPER" &>/dev/null; then
    echo "Invalid image: $WALLPAPER"
    exit 1
fi

# Store the selected wallpaper
echo "$WALLPAPER" >"$LAST_USED"

# 1. Generate pywal colors (Add -n to skip setting wallpaper, we do it manually)
wal -i "$WALLPAPER" -n

# 2. Ensure hyprpaper is running. If not, start it.
if ! pgrep -x "hyprpaper" > /dev/null; then
    hyprpaper &
    # Wait for the socket to be ready
    for i in {1..10}; do
        if hyprctl hyprpaper listloaded &>/dev/null; then break; fi
        sleep 0.1
    done
fi

# 3. Preload the NEW wallpaper (Required before setting it)
hyprctl hyprpaper preload "$WALLPAPER"

# 4. Apply the wallpaper
hyprctl hyprpaper wallpaper "$MONITOR,$WALLPAPER"
hyprctl hyprpaper wallpaper "$MONITOR1,$WALLPAPER"

# 5. Unload the OLD wallpaper to free memory (Instant cleanup)
if [ -n "$LAST_WALL" ] && [ "$LAST_WALL" != "$WALLPAPER" ]; then
    hyprctl hyprpaper unload "$LAST_WALL"
fi


