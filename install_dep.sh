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
if uname -a | grep debian; then
    install_package "vim-nox"
else
    install_package "vim"
fi
install_package "nvim"
install_package "curl"

# zsh stuff
install_shell "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"
mv "$HOME/.oh-my-zsh" "$HOME/.config/oh-my-zsh"
git clone "https://github.com/zsh-users/zsh-autosuggestions" "$HOME/.config/oh-my-zsh/custom/plugins/zsh-autosuggestions"
git clone "https://github.com/zsh-users/zsh-syntax-highlighting.git" "$HOME/.config/oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
#

