#!/usr/bin/env bash
set -euo pipefail

usage() {
  printf 'Usage: %s {group|ungroup-active}\n' "${0##*/}" >&2
}

notify() {
  local message="$1"
  hyprctl notify -1 2500 "rgb(89b4fa)" "fontsize:13 ${message}" >/dev/null 2>&1 || true
}

hypr_json() {
  hyprctl -j "$@"
}

focus_window() {
  local address="$1"
  hyprctl dispatch focuswindow "address:${address}" >/dev/null
}

group_members_json() {
  local address="$1"
  hypr_json clients | jq -c --arg address "$address" '
    def normalize_group:
      if . == null then []
      elif type == "array" then .
      elif type == "string" and length > 0 then [.]
      else []
      end;

    (map(select(.address == $address))[0].grouped // []) | normalize_group
  '
}

is_grouped_with() {
  local address="$1"
  local target="$2"

  group_members_json "$target" | jq -e --arg address "$address" 'index($address) != null' >/dev/null
}

group_all_tiled_on_workspace() {
  local active_workspace active_window clients tiled_count target original grouped_count failed_count

  active_workspace="$(hypr_json activeworkspace | jq -r '.id')"
  active_window="$(hypr_json activewindow)"
  original="$(jq -r '.address // empty' <<<"$active_window")"
  clients="$(hypr_json clients)"

  mapfile -t windows < <(
    jq -r --argjson workspace "$active_workspace" '
      map(select(
        .workspace.id == $workspace
        and (.floating | not)
        and (.mapped // true)
      ))
      | sort_by(.focusHistoryID // 999999)
      | .[].address
    ' <<<"$clients"
  )

  tiled_count="${#windows[@]}"
  if (( tiled_count < 2 )); then
    notify "Need at least two tiled windows to create a workspace group"
    return 0
  fi

  target="${windows[0]}"
  if [[ -n "$original" ]]; then
    for address in "${windows[@]}"; do
      if [[ "$address" == "$original" ]]; then
        target="$original"
        break
      fi
    done
  fi

  focus_window "$target"

  if ! group_members_json "$target" | jq -e 'length > 0' >/dev/null; then
    hyprctl dispatch togglegroup >/dev/null
  fi

  failed_count=0
  for address in "${windows[@]}"; do
    [[ "$address" == "$target" ]] && continue
    is_grouped_with "$address" "$target" && continue

    focus_window "$address"
    for direction in l r u d; do
      hyprctl dispatch moveintogroup "$direction" >/dev/null 2>&1 || true
      if is_grouped_with "$address" "$target"; then
        break
      fi
    done

    if ! is_grouped_with "$address" "$target"; then
      failed_count=$((failed_count + 1))
    fi
  done

  focus_window "$target"

  grouped_count="$(group_members_json "$target" | jq 'length')"
  if (( failed_count > 0 )); then
    notify "Grouped ${grouped_count}/${tiled_count} tiled windows; ${failed_count} could not be moved into the group"
  fi
}

ungroup_active() {
  local active_address members_json member_count

  active_address="$(hypr_json activewindow | jq -r '.address // empty')"
  if [[ -z "$active_address" ]]; then
    notify "No active window to ungroup"
    return 0
  fi

  members_json="$(group_members_json "$active_address")"
  member_count="$(jq 'length' <<<"$members_json")"
  if (( member_count < 2 )); then
    notify "Active window is not in a group"
    return 0
  fi

  jq -r '.[]' <<<"$members_json" | while IFS= read -r address; do
    hyprctl dispatch moveoutofgroup "address:${address}" >/dev/null 2>&1 || true
  done

  hypr_json clients | jq -e --arg address "$active_address" 'any(.address == $address)' >/dev/null \
    && focus_window "$active_address"
}

case "${1:-}" in
  group)
    group_all_tiled_on_workspace
    ;;
  ungroup-active)
    ungroup_active
    ;;
  *)
    usage
    exit 2
    ;;
esac
