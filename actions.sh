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
    elif [[ -L "$1" ]]; then
        rm "$1"
    fi
}



if [ "$#" -eq 1 ]; then
    # Directories
    mkdir -p "$HOME/.config/nvim/"
    mkdir -p "$HOME/.config/nvim/lua"
    mkdir -p "$HOME/.config/nvim/autoload"
    mkdir -p "$HOME/.config/nvim/bundle"
    mkdir -p "$HOME/.config/i3"
    mkdir -p "$HOME/.config/x11"
    mkdir -p "$HOME/.config/git"
    mkdir -p "$HOME/.config/i3status"
    mkdir -p "$HOME/.config/i3lock"
    mkdir -p "$HOME/.config/zsh"
    mkdir -p "$HOME/.config/zsh/plugins"
    mkdir -p "$HOME/.config/terminal"
    mkdir -p "$HOME/.config/tmux"
    mkdir -p "$HOME/.config/termite"
    mkdir -p "$HOME/.config/scripts"
    mkdir -p "$HOME/.config/dunst"
    mkdir -p "$HOME/.config/wezterm"
    mkdir -p "$HOME/.config/ideavim"
    mkdir -p "$HOME/.config/flameshot"
    mkdir -p "$HOME/vm"
    mkdir -p "$HOME/vm/shared"
    mkdir -p "$HOME/vm/preload"
    mkdir -p "$HOME/vm/network"
    mkdir -p "$HOME/vm/images"

    # Files

    files=( \
        "x11/.xinitrc"                           "$HOME/.xinitrc"                                     \
        "x11/Xmodmap"                            "$HOME/.config/x11/Xmodmap"                          \
        "x11/mouse.sh"                           "$HOME/.config/x11/mouse.sh"                         \
        "x11/volume.sh"                          "$HOME/.config/x11/volume.sh"                        \
        "vim/init.vim"                           "$HOME/.config/nvim/init.vim"                        \
        "vim/ideavimrc"                          "$HOME/.config/ideavim/ideavimrc"                    \
        "vim/init.lua"                           "$HOME/.config/nvim/lua/init.lua"                    \
        "vim/keymaps.lua"                        "$HOME/.config/nvim/lua/keymaps.lua"                 \
        "vim/plugins.lua"                        "$HOME/.config/nvim/lua/plugins.lua"                 \
        "shell/.zshenv"                          "$HOME/.zshenv"                                      \
        "shell/.zshrc"                           "$HOME/.config/zsh/.zshrc"                           \
        "shell/gitp.sh"                          "$HOME/.config/zsh/gitp.sh"                          \
        "shell/plugins/zsh-autosuggestions"      "$HOME/.config/zsh/plugins/zsh-autosuggestions"      \
        "shell/plugins/zsh-syntax-highlighting"  "$HOME/.config/zsh/plugins/zsh-syntax-highlighting"  \
        "shell/plugins/extract"                  "$HOME/.config/zsh/plugins/extract"                  \
        "i3/i3"                                  "$HOME/.config/i3/config"                            \
        "i3/i3status"                            "$HOME/.config/i3status/config"                      \
        "i3/i3blocks"                            "$HOME/.config/i3blocks"                             \
        "i3/i3lock.sh"                           "$HOME/.config/i3/i3lock.sh"                         \
        "terminal/config"                        "$HOME/.config/termite/config"                       \
        "terminal/wezterm.lua"                   "$HOME/.config/wezterm/wezterm.lua"                  \
        "i3/dunstrc"                             "$HOME/.config/dunst/dunstrc"                        \
        "flameshot/flameshot.ini"                "$HOME/.config/flameshot/flameshot.ini"              \
        "scripts/screenshot.sh"                  "$HOME/.config/scripts/screenshot.sh"                \
        "scripts/colortest.sh"                   "$HOME/.config/scripts/colortest.sh"                 \
        "vm/vm.sh"                               "$HOME/vm/vm.sh"                                     \
        "vm/smbshare.sh"                         "$HOME/vm/smbshare.sh"                               \
        "vm/preload/Makefile"                    "$HOME/vm/preload/Makefile"                          \
        "vm/preload/xigd.c"                      "$HOME/vm/preload/xigd.c"                            \
        "vm/network/nw_enable.sh"                "$HOME/vm/network/nw_enable.sh"                      \
        "vm/network/bridge_enable.sh"            "$HOME/vm/network/bridge_enable.sh"                  \
        "vm/network/bridge_disable.sh"           "$HOME/vm/network/bridge_disable.sh"                 \
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

    exit 0
fi

# done dropping

install_if_needed() {
    bin="$1"
    if [ $# -eq 2 ]; then
        bin="$2"
    fi
    if [ ! -f "$(command -v "$bin")" ]; then
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

install_if_needed_yay() {
    if [ ! -f "$(command -v "$1")" ]; then
        yay -S "$1" --noconfirm
    fi
}


install_if_needed_cargo() {
    if [ ! -f "$(command -v "$1")" ]; then
        if [ ! "$(command -v cargo)" ]; then
            curl "https://sh.rustup.rs" -sSf | sh -s -- -y
        fi
        cargo install "$1"
    fi
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

install_plug_version() {
    IFS='/' read -r -a parts <<< "$1"
    git clone "$1" || return 0
    pushd "${parts[${#parts[@]}-1]}"
    git checkout "$2"
    popd
}

enable_service() {
    sudo systemctl enable "$1"
    sudo systemctl start "$1"
}


if [ "$2" = "deps" ]; then
    update_packages

    # setup git
    git config --global "core.excludesfile" "$HOME/.config/git/cvsignore"
    git config --global "merge.ff" "only"
    git config --global "diff.tool" "nvimdiff"
    git config --global "alias.d" "difftool"
    git config --global "pull.rebase" "true"
    git config --global "protocol.version" "2"
    git config --global "alias.f" "fetch"
    git config --global "difftool.prompt" "false"
    grep "tags" "$HOME/.config/git/cvsignore" >/dev/null 2>&1 || echo tags >> "$HOME/.config/git/cvsignore"

    install_if_needed "i3"
    install_if_needed "i3status"
    install_if_needed "dmenu"
    install_if_needed "zsh"
    install_if_needed "ssh"
    install_if_needed "yarn"
    install_if_needed "cargo"
    install_if_needed "npm" 
    sudo npm install -g neovim 
    install_if_needed "dunst"
    install_if_needed "ncdu"
    install_if_needed "zathura"
    install_if_needed "virt-manager"
    install_if_needed "perl"
    install_if_needed "python"
    install_if_needed "python3"
    install_if_needed "lldb"
    install_if_needed "gdb"
    install_if_needed "base-devel"
    install_if_needed "chromium"
    install_if_needed "arandr"
    install_if_needed "bluez"
    install_if_needed "bluez-utils"
    install_if_needed "redshift"
    install_if_needed "keepassxc"
    install_if_needed "bitwarden"
    install_if_needed "jq"
    install_if_needed "bitwarden"
    install_if_needed "curl"
    install_if_needed "tor"
    install_if_needed "neofetch"
    install_if_needed "go"
    install_if_needed "amdvlk"
    install_if_needed "amdgpu"
    install_if_needed "pipewire"
    install_if_needed "xorg"
    install_if_needed "xorg-xinit"
    install_if_needed "xsel"
    install_if_needed "xclip"
    install_if_needed "neovim"
    install_if_needed "pipewire-pulse"
    install_if_needed "pavucontrol"
    install_if_needed "sxiv"
    install_if_needed "vlc"
    install_if_needed "fameshot"
    install_if_needed "adobe-source-han-sans-otc-fonts"
    install_if_needed "adobe-source-han-sans-cn-fonts"
    install_if_needed "adobe-source-han-sans-kr-fonts"
    install_if_needed "ttf-hannom"

    if command -v pacman; then
        if [ ! "$(command -v yay)" ]; then 
            pushd /tmp
            git clone https://aur.archlinux.org/yay.git
            cd yay
            makepkg -si --noconfirm
            popd
        fi
		
        install_if_needed "yay"
        install_if_needed_yay "nerd-fonts-complete"
    	install_if_needed_yay "wezterm-nightly-bin"
        install_if_needed_yay "neovim-git"
        install_if_needed_yay "nvim-packer-git"
        install_if_needed_yay "ttf-ancient-fonts"
        install_if_needed_yay "ttf-arabeyes-fonts"
        install_if_needed_yay "ttf-freebanglafont"
        install_if_needed_yay "ttf-ubraille"
        install_if_needed_yay "ttf-paratype"
        install_if_needed_yay "ttf-mgopen"
    fi

    install_if_needed_cargo "exa"
    install_if_needed_cargo "bat"
    install_if_needed_cargo "sd"
    install_if_needed_cargo "ripgrep"
    install_if_needed_cargo "git-delta"

    enable_service bluetooth.service

    chsh -s zsh
fi

