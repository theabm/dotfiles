#!/usr/bin/env bash
set -euo pipefail

# This script configures Hyprland workspace assignment dynamically
# If an external monitor (not eDP-1) is connected, it will use monitors_external.conf
# substituting the actual external monitor name.
# Otherwise, it will fall back to monitors_internal.conf.

# Get all monitor names
MONITORS=$(hyprctl monitors -j | jq -r '.[].name')

# Internal monitor (fixed)
INT_MON="eDP-1"

# Find first monitor that isn't eDP-1
EXT_MON=$(echo "$MONITORS" | grep -v "^${INT_MON}$" | head -n1 || true)

TEMPLATES_DIR="${HOME}/dotfiles/stow/hyprland/.config/hypr"
ACTIVE_CONF="${TEMPLATES_DIR}/monitors_active.conf"

if [[ -n "${EXT_MON}" ]]; then
    echo "[hypr-monitor-setup] External monitor detected: ${EXT_MON}"
    export EXT_MON INT_MON
    envsubst < "${TEMPLATES_DIR}/monitors_external.tmpl" > "${ACTIVE_CONF}"
else
    echo "[hypr-monitor-setup] No external monitor detected — using internal only"
    export INT_MON
    envsubst < "${TEMPLATES_DIR}/monitors_internal.tmpl" > "${ACTIVE_CONF}"
fi

