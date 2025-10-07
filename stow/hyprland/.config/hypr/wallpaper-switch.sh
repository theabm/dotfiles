#!/usr/bin/env bash

set -euo pipefail

# Collect monitor names from Hyprland
mapfile -t MONS < <(hyprctl monitors -j | jq -r '.[].name')

if (( ${#MONS[@]} == 0 )); then
  echo "No monitors found via hyprctl."
  exit 1
fi

# (Optional) ensure swww is running; harmless if already running
swww query >/dev/null 2>&1 || swww init

# Call the Rust binary with all monitor names as args
# Adjust the binary path if different
$HOME/.cargo/bin/wallpaper-switcher "${MONS[@]}" 2>$HOME/wp.txt

