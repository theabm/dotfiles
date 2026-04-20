#!/usr/bin/env bash
set -euo pipefail

# This script configures Hyprland workspace assignment dynamically.
# If an external monitor (not eDP-1) is connected, it applies the external
# template with the detected monitor name. Otherwise, it falls back to internal.

# Get all monitor names
MONITORS=$(hyprctl monitors -j | jq -r '.[].name')

# Internal monitor (fixed)
INT_MON="eDP-1"

# Find first monitor that isn't eDP-1
EXT_MON=$(echo "$MONITORS" | grep -v "^${INT_MON}$" | head -n1 || true)

TEMPLATES_DIR="${XDG_CONFIG_HOME:-${HOME}/.config}/hypr"
RUNTIME_DIR="${XDG_RUNTIME_DIR:-/tmp}/hypr"
ACTIVE_CONF="${RUNTIME_DIR}/monitors_active.conf"
mkdir -p "${RUNTIME_DIR}"

if [[ -n "${EXT_MON}" ]]; then
    echo "[hypr-monitor-setup] External monitor detected: ${EXT_MON}"
    export EXT_MON INT_MON
    envsubst < "${TEMPLATES_DIR}/monitors_external.tmpl" > "${ACTIVE_CONF}"
else
    echo "[hypr-monitor-setup] No external monitor detected - using internal only"
    export INT_MON
    envsubst < "${TEMPLATES_DIR}/monitors_internal.tmpl" > "${ACTIVE_CONF}"
fi

batch=""
while IFS= read -r line; do
    [[ -z "${line}" || "${line}" =~ ^[[:space:]]*# ]] && continue
    rule="${line#workspace = }"
    batch+="keyword workspace ${rule};"
done < "${ACTIVE_CONF}"

hyprctl --batch "${batch}"
