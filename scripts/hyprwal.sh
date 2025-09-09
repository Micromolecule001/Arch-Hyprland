#!/bin/bash

# Directory containing your wallpapers
WALLPAPER_DIR="$HOME/.config/wallpapers"

# Select a random wallpaper
WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" \) | shuf -n 1)

if [[ -z "$WALLPAPER" ]]; then
    echo "No wallpapers found in $WALLPAPER_DIR"
    exit 1
fi

# Set wallpaper
waypaper --wallpaper "$WALLPAPER"

# Generate Pywal colors
wal -i "$WALLPAPER"

##################################################
# Generates a Hyprland-compatible color file from Pywal's colors.sh 
# 
#
PYWAL_COLORS="${HOME}/.cache/wal/colors.sh"
HYPR_COLORS_DIR="${HOME}/.config/hypr/colors"
mkdir -p "$HYPR_COLORS_DIR"
HYPR_COLORS_FILE="${HYPR_COLORS_DIR}/hyprland-colors.conf"

if [[ ! -f "$PYWAL_COLORS" ]]; then
    echo "Pywal colors file not found: $PYWAL_COLORS"
    exit 1
fi

# Source Pywal colors into this script
source "$PYWAL_COLORS"

# Write to Hyprland file
{
    echo "\$wallpaper = \"$WALLPAPER\""
    for i in {0..15}; do
        # Evaluate variable dynamically
        color_var="color$i"
        color_val="${!color_var}"
        # Strip # and prepend 0x
        hex_val="${color_val#"#"}"
        echo "\$color$i = 0xff$hex_val"
    done
} > "$HYPR_COLORS_FILE"

echo "Hyprland color file generated: $HYPR_COLORS_FILE"

# Reload Hyprland to apply the new colors (optional)
hyprctl reload

# Restart Waybar
pkill waybar
waybar &

