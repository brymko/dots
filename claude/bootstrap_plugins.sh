#!/bin/bash
# Reinstall Claude Code marketplaces + plugins from snapshots in this dir.
# Re-run snapshot.sh after installing/removing plugins to update the JSON.
set -euf -o pipefail

dir="$(cd "$(dirname "$0")" && pwd -P)"
markets="$dir/plugins/known_marketplaces.json"
plugins="$dir/plugins/installed_plugins.json"

if ! command -v claude >/dev/null; then
    echo "claude CLI not found in PATH" >&2
    exit 1
fi
if ! command -v jq >/dev/null; then
    echo "jq required" >&2
    exit 1
fi

jq -r 'to_entries[] | "\(.key)\t\(.value.source.repo // .value.source.url // .value.source.path)"' "$markets" |
while IFS=$'\t' read -r name source; do
    echo "==> marketplace: $name ($source)"
    claude plugin marketplace add "$source" || true
done

jq -r '.plugins | to_entries[] | .key' "$plugins" |
while read -r plugin; do
    echo "==> plugin: $plugin"
    claude plugin install "$plugin" || true
done
