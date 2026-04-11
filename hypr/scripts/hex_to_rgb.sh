#!/usr/bin/env bash

# Source the current pywal colors
. "$HOME/.cache/wal/colors.sh"

# Function to convert Pywal HEX to Zellij RGB
hex_to_rgb() {
  local hex="${1#\#}"
  printf "%d %d %d" "0x${hex:0:2}" "0x${hex:2:2}" "0x${hex:4:2}"
}

# Ensure the native themes directory exists
mkdir -p ~/.config/zellij/themes

# Generate the standard 11-color Zellij theme
cat <<EOF >~/.config/zellij/themes/pywal.kdl
themes {
    pywal {
        fg $(hex_to_rgb "$color7")
        bg $(hex_to_rgb "$color0")
        black $(hex_to_rgb "$color0")
        red $(hex_to_rgb "$color1")
        green $(hex_to_rgb "$color2")
        yellow $(hex_to_rgb "$color3")
        blue $(hex_to_rgb "$color4")
        magenta $(hex_to_rgb "$color5")
        cyan $(hex_to_rgb "$color6")
        white $(hex_to_rgb "$color7")
        orange $(hex_to_rgb "$color9")
    }
}
EOF
