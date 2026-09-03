#!/bin/bash
shopt -s dotglob
set -euf -o pipefail

source ./actions_common.sh

# AeroSpace keeps inactive workspace windows off-screen; grouping Mission Control by app
# avoids the worst of macOS trying to render that window pile as separate thumbnails.
enable_aerospace_dock_preferences() {
    local expose_group_apps
    expose_group_apps="$(defaults read com.apple.dock expose-group-apps 2>/dev/null || true)"
    if [ "$expose_group_apps" = "1" ]; then
        log "Dock already groups windows by application"
        return 0
    fi

    log "Enabling Dock 'Group windows by application' for AeroSpace"
    defaults write com.apple.dock expose-group-apps -bool true
    killall Dock
}


if [ "$#" -eq 1 ]; then
    files=( \
        "aerospace/aerospace.toml"             "$HOME/.config/aerospace/aerospace.toml" \
        "terminal/wezterm.lua"                 "$HOME/.wezterm.lua"                     \
        "karabiner/karabiner.json"             "$HOME/.config/karabiner/karabiner.json" \
        "scripts/brave-current-workspace.sh"   "$HOME/.local/bin/brave-current-workspace" \
        "claude/settings.json"                 "$HOME/.claude/settings.json"            \
        "claude/CLAUDE.md"                     "$HOME/.claude/CLAUDE.md"                \
        "claude/skills/tufte-viz"              "$HOME/.claude/skills/tufte-viz"         \
        "claude/skills/rust-conventions"       "$HOME/.claude/skills/rust-conventions"  \
        "claude/skills/commit-conventions"     "$HOME/.claude/skills/commit-conventions" \
        "claude/skills/code-search-tools"      "$HOME/.claude/skills/code-search-tools" \
        "vim/init.vim"                         "$HOME/.config/nvim/init.vim"            \
        "vim/init.lua"                         "$HOME/.config/nvim/lua/init.lua"        \
        "vim/keymaps.lua"                      "$HOME/.config/nvim/lua/keymaps.lua"     \
        "vim/plugins.lua"                      "$HOME/.config/nvim/lua/plugins.lua"     \
        "vim/omp.lua"                          "$HOME/.config/nvim/lua/omp.lua"        \
        "vim/ideavimrc"                        "$HOME/.config/ideavim/ideavimrc"        \
        "shell/.zshenv"                        "$HOME/.zshenv"                          \
        "shell/.zshrc"                         "$HOME/.config/zsh/.zshrc"               \
        "shell/gitp.sh"                        "$HOME/.config/zsh/gitp.sh"              \
    )

    if [ "$1" = "install" ]; then
        mkdir -p "$HOME/.config/aerospace"
        mkdir -p "$HOME/.config/karabiner"
        mkdir -p "$HOME/.local/bin"
        mkdir -p "$HOME/.claude/skills"
        mkdir -p "$HOME/.config/nvim/lua"
        mkdir -p "$HOME/.config/ideavim"
        mkdir -p "$HOME/.config/zsh"

        # Run claude plugin bootstrap first so a later symlink failure does not
        # skip it. Tolerate its own failures so it never blocks the file loop.
        ./claude/bootstrap_plugins.sh || log "claude bootstrap failed (non-fatal)"

        for ((i=0; i<${#files[@]}; i+=2)) do
            drop_file "${files[i]}" "${files[i + 1]}"
        done

        enable_aerospace_dock_preferences
    elif [ "$1" = "uninstall" ]; then
        for ((i=0; i<${#files[@]}; i+=2)) do
            restore_file "${files[i + 1]}"
        done
    else
        echo "unknown action: $1"
        exit 1
    fi

    exit 0
fi

echo "usage: $0 <install|uninstall>"
exit 1
