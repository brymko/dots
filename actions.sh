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
    "i3/i3blocks" "$HOME/.config/i3blocks" \
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

# done dropping 

install_if_needed() {
    if [ ! -f "$(command -v "$1")" ]; then
        if command -v pacman; then
            sudo pacman -S "$1" --noconfirm
        elif command -v apt; then
            yes | sudo apt install "$1"
        else
            echo "no known package manager"
            exit 1
        fi
    fi
}

install_if_need_omzsh() {
    if [ ! -d "$HOME/.config/oh-my-zsh" ]; then 
        # big brain time at oh-my-zsh LLC to autoprompt
        echo "n" | sh -c "$(curl -fsSL "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh")"
        mv "$HOME/.oh-my-zsh/*" "$HOME/.config/oh-my-zsh"
        git clone "https://github.com/zsh-users/zsh-autosuggestions" "$HOME/.config/oh-my-zsh/custom/plugins/zsh-autosuggestions"
        git clone "https://github.com/zsh-users/zsh-syntax-highlighting.git" "$HOME/.config/oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
    fi
}

install_if_needed_cargo() {
    cargo install "$1"
}
update_packages() {
    if command -v pacman; then
        sudo pacman -Syy
    elif command -v apt; then
        sudo apt update && yes | sudo apt upgrade
    else
        echo "no known package manager"
        exit 1
    fi
}

if [ "$2" = "install_deps"]; then 
    update_packages

    install_if_needed "i3"
    install_if_needed "i3status"
    install_if_needed "zsh"
    install_if_needed "vim"
    install_if_needed "termite"
    install_if_needed "exa"
    install_if_needed "cargo"
    install_if_needed_cargo "exa"
    if uname -a | grep debian; then
        install_package "vim-nox"
    else
        install_package "vim"
    fi
    install_package "nvim"
    install_if_needed "curl"

    install_if_need_omzsh
fi

