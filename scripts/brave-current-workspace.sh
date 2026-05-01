#!/bin/bash
set -euo pipefail

brave_bundle_id="com.brave.Browser"
brave_app_name="Brave Browser"
brave_app_bundle="Brave Browser.app"
brave_user_data_dir="$HOME/Library/Application Support/BraveSoftware/Brave-Browser"
brave_local_state="$brave_user_data_dir/Local State"
new_tab_url="brave://newtab/"

last_used_profile_dir() {
    plutil -extract profile.last_used raw -o - "$brave_local_state" 2>/dev/null || printf '%s\n' "Default"
}

open_new_tab_in_focused_window() {
    open -a "$brave_app_name" "$new_tab_url"
}

open_new_window_in_current_workspace() {
    open -na "$brave_app_bundle" --args --profile-directory="$(last_used_profile_dir)" --new-window "$new_tab_url"
}

window_id=""
while IFS= read -r line; do
    [ -n "$line" ] || continue

    id="${line%% *}"
    title="${line#* }"

    # The profile picker is a Brave window, but using it just routes back to
    # an existing profile window on another workspace. Ignore it here.
    [ "$title" = "Who's using Brave?" ] && continue

    window_id="$id"
    break
done < <(
    aerospace list-windows \
        --workspace focused \
        --app-bundle-id "$brave_bundle_id" \
        --format '%{window-id} %{window-title}'
)

if [ -n "$window_id" ]; then
    aerospace focus --window-id "$window_id"
    open_new_tab_in_focused_window
else
    open_new_window_in_current_workspace
fi
