
#!/bin/bash

# Kill running waybar and scripts
if pgrep waybar > /dev/null; then
    killall waybar
    pkill -f gappname.sh
    pkill -f visualizer.sh
    killall cava  
    sleep 0.5
else

# Start Waybar
hyprctl dispatch exec waybar
fi
