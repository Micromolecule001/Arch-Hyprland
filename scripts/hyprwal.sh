#!/bin/bash

# Directory containing your wallpapers
WALLPAPER_DIR="$HOME/.config/wallpapers"

# Select a random wallpaper from the directory
WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" \) | shuf -n 1)

# Check if a wallpaper was found
if [ -z "$WALLPAPER" ]; then
    echo "No wallpapers found in $WALLPAPER_DIR"
    exit 1
fi

# Set the wallpaper using Waypaper
waypaper --wallpaper "$WALLPAPER"

# Generate and apply the color scheme using Pywal
wal -i "$WALLPAPER"

# Reload Hyprland to apply the new colors (optional)
hyprctl reload

