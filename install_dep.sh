#!/bin/bash


update_packages() {
    if $(which pacman); then
        pacman -Syyuu
    elif $(which apt); then
        apt update 
    else
        echo "no known package manager"
        exit 1
    fi
}
install_package() {
    if which pacman; then
        pacman -S "$1"
    elif $(which apt); then
        apt install $1
    else
        echo "no known package manager"
        exit 1
    fi
}
install_shell() {
    sh -c "$(curl -fsSL $1)"
}

update_packages

install_package "i3"
install_package "i3status"
install_package "i3lock"
install_package "zsh"
install_package "vim"
install_shell "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"

