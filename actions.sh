#!/bin/bash
shopt -s dotglob
set -euf -o pipefail

# Functions
log() {
    echo "$1"
}

create_symlink() {
    ln -sr "$1" "$2"
}
backup_if_exists() {
    if [[ -f $1 ]]; then
        if [[ -L "$1" ]]; then
            log "$1 already is a symlink"
            return 1
        fi
        mv "$1" "$1.bak"
    fi
    return 0
}

drop_file() {
    backup_if_exists "$2" || return 1
    create_symlink "$1" "$2"
}

restore_file() {
    if [[ -f "$1.bak" ]]; then
        mv "$1.bak" "$1"
    else
        if [[ -L "$1" ]]; then
            rm "$1"
        fi
    fi
}



# Directories
mkdir -p "$HOME/.vim/autoload"
mkdir -p "$HOME/.config/vim"
mkdir -p "$HOME/.config/i3"
mkdir -p "$HOME/.config/i3status"
mkdir -p "$HOME/.config/i3lock"
mkdir -p "$HOME/.config/shell"
mkdir -p "$HOME/.config/zsh"
mkdir -p "$HOME/.config/terminal"
mkdir -p "$HOME/.config/tmux"
mkdir -p "$HOME/.config/termite"
mkdir -p "$HOME/.config/scripts"

# Files

files=( \
    "x11/.xinitrc" "$HOME/.xinitrc" \
    "vim/plug.vim" "$HOME/.vim/autoload/plug.vim" \
    "vim/.vimrc" "$HOME/.config/vim/.vimrc" \
    "vim/.vimrc" "$HOME/.vimrc" \
    "shell/.zshrc" "$HOME/.config/zsh/.zshrc" \
    "shell/.zshenv" "$HOME/.zshenv" \
    "i3/i3" "$HOME/.config/i3/config" \
    "i3/i3status" "$HOME/.config/i3status/config" \
    "i3/i3blocks" "$HOME/.config/i3blocks/config" \
    "i3/i3lock.sh" "$HOME/.config/i3/i3lock.sh" \
    "terminal/config" "$HOME/.config/termite/config" \
    "scripts/screenshot.sh" "$HOME/.config/scripts/screenshot.sh" \
)


if [ "$1" = "install" ]; then
    for ((i=0; i<${#files[@]}; i+=2)) do
        drop_file "${files[i]}" "${files[i + 1]}"
    done
elif [ "$1" = "uninstall" ]; then
    for ((i=0; i<${#files[@]}; i+=2)) do
        restore_file "${files[i + 1]}"
    done
fi


check_if_installed() {
    if [ ! -f "$(command -v "$1")" ]; then
        log "$1 not installed"
    fi
}

# check install 

check_if_installed "i3"
check_if_installed "i3status"
check_if_installed "zsh"
check_if_installed "vim"
check_if_installed "termite"
if [ ! -d "$HOME/.config/oh-my-zsh" ]; then
    log "oh-my-zsh not installed"
fi
