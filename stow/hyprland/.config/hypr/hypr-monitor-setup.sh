#!/usr/bin/env bash
set -euo pipefail

# This script configures Hyprland workspace assignment dynamically.
# If an external monitor is connected, it applies the external template with
# the detected monitor name. Otherwise, it falls back to internal-only rules.

INT_MON="eDP-1"
TEMPLATES_DIR="${XDG_CONFIG_HOME:-${HOME}/.config}/hypr"
RUNTIME_DIR="${XDG_RUNTIME_DIR:-/tmp}/hypr"
ACTIVE_CONF="${RUNTIME_DIR}/monitors_active.conf"

mkdir -p "${RUNTIME_DIR}"

mapfile -t monitors < <(hyprctl monitors -j | jq -r '.[].name')

EXT_MON=""
for monitor in "${monitors[@]}"; do
    if [[ "${monitor}" != "${INT_MON}" ]]; then
        EXT_MON="${monitor}"
        break
    fi
done

render_template() {
    local template="$1"
    local tmp

    tmp="$(mktemp "${RUNTIME_DIR}/monitors_active.XXXXXX")"
    sed \
        -e "s|\${INT_MON}|${INT_MON}|g" \
        -e "s|\${EXT_MON}|${EXT_MON}|g" \
        "${template}" > "${tmp}"
    mv "${tmp}" "${ACTIVE_CONF}"
}

if [[ -n "${EXT_MON}" ]]; then
    echo "[hypr-monitor-setup] External monitor detected: ${EXT_MON}"
    render_template "${TEMPLATES_DIR}/monitors_external.tmpl"
else
    echo "[hypr-monitor-setup] No external monitor detected - using internal only"
    render_template "${TEMPLATES_DIR}/monitors_internal.tmpl"
fi

batch=""
while IFS= read -r line; do
    [[ -z "${line}" || "${line}" =~ ^[[:space:]]*# ]] && continue
    rule="${line#workspace = }"
    batch+="keyword workspace ${rule};"
done < "${ACTIVE_CONF}"

if [[ -n "${batch}" ]]; then
    hyprctl --batch "${batch}"
fi
