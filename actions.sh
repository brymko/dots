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
    mkdir -p "$HOME/.config/neomutt"
    mkdir -p "$HOME/.config/dunst"
    mkdir -p "$HOME/.config/wezterm"
    mkdir -p "$HOME/vm"
    mkdir -p "$HOME/vm/shared"
    mkdir -p "$HOME/vm/preload"
    mkdir -p "$HOME/vm/network"
    mkdir -p "$HOME/vm/images"

    # Files

    files=( \
        "x11/.xinitrc"                           "$HOME/.xinitrc"                                     \
        "x11/.Xmodmap"                           "$HOME/.config/x11/.Xmodmap"                         \
        "x11/mouse.sh"                           "$HOME/.config/x11/mouse.sh"                         \
        "x11/volume.sh"                          "$HOME/.config/x11/volume.sh"                        \
        "vim/init.vim"                           "$HOME/.config/nvim/init.vim"                        \
        "vim/pathogen.vim"                       "$HOME/.config/nvim/autoload/pathogen.vim"           \
        "vim/coc-settings.json"                  "$HOME/.config/nvim/coc-settings.json"               \
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
        "terminal/wezterm.lua"                   "$HOME/.config/wezterm/wezterm.lua"
        "i3/dunstrc"                             "$HOME/.config/dunst/dunstrc"                        \
        "mail/neomuttrc"                         "$HOME/.config/neomutt/neomuttrc"                    \
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
    grep "tags" "$HOME/.config/git/cvsignore" >/dev/null 2>&1 || echo tags >> "$HOME/.config/git/cvsignore"

    install_if_needed "i3"
    install_if_needed "i3status"
    install_if_needed "zsh"
    install_if_needed "nvim"
    install_if_needed "neovim"
    install_if_needed "yarn"

    # install plugins for nvim
    pushd "$HOME/.config/nvim/bundle"
    install_plug_version "https://github.com/iamcco/markdown-preview.nvim" e5bfe9b89dc9c2fbd24ed0f0596c85fd0568b143
    cd "markdown-preview.nvim"
    yarn install
    cd ..
    install_plug_version "https://github.com/junegunn/fzf.vim" ee91c93d4cbc6f29cf82877ca39f3ce23d5c5b7b
    install_plug_version "https://github.com/ap/vim-buftabline" 73b9ef5dcb6cdf6488bc88adb382f20bc3e3262a
    install_plug_version "https://github.com/tpope/vim-fugitive" bebe504e38d0a20c30d6dd666c4c793b3cc66104 
    install_plug_version "https://github.com/tpope/vim-commentary" f8238d70f873969fb41bf6a6b07ca63a4c0b82b1
    install_plug_version "https://github.com/tpope/vim-surround" f51a26d3710629d031806305b6c8727189cd1935
    install_plug_version "https://github.com/tpope/vim-endwise" 97180a73ad26e1dcc1eebe8de201f7189eb08344
    install_plug_version "https://github.com/rstacruz/vim-closer" c61667d27280df171a285b1274dd3cf04cbf78d4
    install_plug_version "https://github.com/tpope/vim-repeat" c947ad2b6a16983724a0153bdf7f66d7a80a32ca
    install_plug_version "https://github.com/neoclide/coc.nvim" 5b4b18d2ed2b18870034c7ee853164e1274ab158
    install_plug_version "https://github.com/rust-lang/rust.vim" 96e79e397126be1a64fb53d8e3656842fe1a4532
    popd

    install_if_needed "cargo"
    install_if_needed "termite"
    install_if_needed "nodejs" "node" # for fucking coc
    install_if_needed "npm" # fucking coc
    sudo npm install -g neovim # fucking coc
    install_if_needed "dunst"
    install_if_needed "neomutt"
    install_if_needed "ncdu"
    install_if_needed "zathura"
    install_if_needed "virt-manager"
    install_if_needed "pamixer"
    install_if_needed "perl"

    install_if_needed_cargo "exa"
    install_if_needed_cargo "bat"
    install_if_needed_cargo "sd"

    # if uname -a | grep debian; then
    #     install_if_needed "vim-nox"
    # else
    #     install_if_needed "vim"
    # fi

    install_if_needed "curl"

fi

