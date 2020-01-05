#!/bin/bash


update_packages() {
    if command -v pacman; then
        pacman -Syyuu
    elif command -v apt; then
        apt update 
    else
        echo "no known package manager"
        exit 1
    fi
}
install_package() {
    if command -v pacman; then
        pacman -S "$1"
    elif command -v apt; then
        apt install "$1"
    else
        echo "no known package manager"
        exit 1
    fi
}
install_shell() {
    sh -c "$(curl -fsSL "$1")"
}

update_packages

install_package "i3"
install_package "i3status"
install_package "i3lock"
install_package "zsh"
install_package "vim"
install_shell "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"

