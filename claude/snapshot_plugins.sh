#!/bin/bash
# Refresh the plugin snapshots in this dir from the live ~/.claude state.
# Run after installing/removing plugins, then commit the JSON diff.
set -euf -o pipefail

dir="$(cd "$(dirname "$0")" && pwd -P)"
src="$HOME/.claude/plugins"

cp "$src/installed_plugins.json"  "$dir/plugins/installed_plugins.json"
cp "$src/known_marketplaces.json" "$dir/plugins/known_marketplaces.json"
echo "snapshot updated"
