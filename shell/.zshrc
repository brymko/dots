# shared history in all zsh
setopt inc_append_history
setopt share_history

# new terminal in the same directory
function cd {
    builtin cd $@
    pwd > "$ZDOTDIR/.last_dir"
}

if [ -f "$ZDOTDIR/.last_dir" ]; then
    cd "$(cat $ZDOTDIR/.last_dir)"
fi

export ZSH="/home/brymko/.config/oh-my-zsh"

ZSH_THEME="alanpeabody"

HYPHEN_INSENSITIVE="true"

DISABLE_MAGIC_FUNCTIONS=true

plugins=(git zsh-autosuggestions zsh-syntax-highlighting extract sudo colored-man-pages)
source $ZSH/oh-my-zsh.sh

