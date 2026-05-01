#!/bin/bash
set -euo pipefail

brave_bundle_id="com.brave.Browser"
brave_binary="/Applications/Brave Browser.app/Contents/MacOS/Brave Browser"
new_tab_url="brave://newtab/"

open_brave() {
    if [ -x "$brave_binary" ]; then
        "$brave_binary" "$@" &
    else
        open -a "Brave Browser" --args "$@"
    fi
}

window_id=""
IFS= read -r window_id < <(
    aerospace list-windows \
        --workspace focused \
        --app-bundle-id "$brave_bundle_id" \
        --format '%{window-id}'
) || true

if [ -n "$window_id" ]; then
    aerospace focus --window-id "$window_id"
    open_brave "$new_tab_url"
else
    open_brave --new-window "$new_tab_url"
fi
