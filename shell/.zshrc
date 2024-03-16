
# Safe paste https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/safe-paste/safe-paste.plugin.zsh
if [[ ${ZSH_VERSION:0:3} -ge 5.1 ]]; then
    set zle_bracketed_paste  # Explicitly restore this zsh default
    autoload -Uz bracketed-paste-magic
    zle -N bracketed-paste bracketed-paste-magic
fi
#

# Sudo https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/sudo/sudo.plugin.zsh
# ESC ESC => !! <ctrl-a> sudo <enter>
sudo-command-line() {
    [[ -z $BUFFER ]] && zle up-history
    if [[ $BUFFER == sudo\ * ]]; then
        LBUFFER="${LBUFFER#sudo }"
    elif [[ $BUFFER == $EDITOR\ * ]]; then
        LBUFFER="${LBUFFER#$EDITOR }"
        LBUFFER="sudoedit $LBUFFER"
    elif [[ $BUFFER == sudoedit\ * ]]; then
        LBUFFER="${LBUFFER#sudoedit }"
        LBUFFER="$EDITOR $LBUFFER"
    else
        LBUFFER="sudo $LBUFFER"
    fi
}
zle -N sudo-command-line
# Defined shortcut keys: [Esc] [Esc]
bindkey "\e\e" sudo-command-line
#

# Colored man pages https://github.com/MrElendig/dotfiles-alice/blob/master/.zshrc
man() {
  env \
    LESS_TERMCAP_mb=$(printf "\e[1;31m") \
    LESS_TERMCAP_md=$(printf "\e[1;31m") \
    LESS_TERMCAP_me=$(printf "\e[0m") \
    LESS_TERMCAP_se=$(printf "\e[0m") \
    LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
    LESS_TERMCAP_ue=$(printf "\e[0m") \
    LESS_TERMCAP_us=$(printf "\e[1;32m") \
    man "$@"
}

# Prompt stuff
# [[ "$COLORTERM" == (24bit|truecolor) || "${terminfo[colors]}" -eq '16777216' ]] || zmodload zsh/nearcolor

# Color section https://wiki.archlinux.org/index.php/zsh
PS1="%(?..%F{red}=>%? )%F{magenta}%n@%F{magenta}%m %F{blue}%~%f$ "
setopt prompt_subst
# RPS1='$($HOME/.config/zsh/gitp.sh 2>/dev/null)'

zstyle -e ':completion:*:default' list-colors 'reply=(":${(s.:.)LS_COLORS}")'
zstyle ':completion:*' menu select
autoload -Uz compinit && compinit

# fzf
if type rg &> /dev/null; then
    export FZF_DEFAULT_COMMAND='rg --files'
    export FZF_DEFAULT_OPTS='--height 50% --border --reverse' # -m
fi

alias l="eza -lamg --sort type --color=automatic"
alias ls="eza -l --sort type --color=automatic"
alias rg="rg -i"
alias ip="ip -br -c"
alias ida64="wine /home/brymko/ida/ida64.exe &; disown; exit"
alias ida="wine /home/brymko/ida/ida.exe &; disown; exit"
alias binja="/home/brymko/ctf/binaryninja/binaryninja &; disown; exit"
alias work="ssh -Y work"
alias ncdu="ncdu -r"
alias vm="$HOME/vm/vm.sh"
alias sed="sd" 
alias grep="rg"
alias img="sxiv"
alias vim="nvim"
alias vi="nvim"
alias vimdiff="nvim -d"
alias cdoc="cargo doc --no-deps"
alias tsc="yarn exec tsc"
alias q="QHOME=$HOME/q rlwrap -r $HOME/q/l64/q"
alias lastpic="/bin/ls -lt /home/brymko/pics | grep \".png\" | head -n 1 | awk '{print \"/home/brymko/pics/\" \$NF }'"
alias rider="/home/brymko/jetbrains/rider/bin/rider.sh &; disown; exit"
alias clion="/home/brymko/jetbrains/clion/bin/clion.sh &; disown; exit"
alias webstorm="/home/brymko/jetbrains/webstorm/bin/webstorm.sh &; disown; exit"
alias goland="/home/brymko/jetbrains/goland/bin/goland.sh &; disown; exit"
alias k="kubectl"

# git alias
alias gs="git status"
gb() { git stash && git stash branch "${1}" stash@{0}; } 
alias gc="git commit -m"
alias ga="git add"
alias gl="git log --oneline --decorate --color --graph"
alias gr="git reset"

pdf () { 
    zathura $* &; disown;
}


set -o emacs # set emacs mode for shell
bindkey '^E' end-of-line
bindkey '^A' beginning-of-line
bindkey '^U' kill-whole-line
bindkey '^[[Z' reverse-menu-complete
bindkey '^p' up-history
bindkey '^n' down-history
bindkey '^o' autosuggest-accept
bindkey '^h' backward-word
bindkey '^j' backward-char
bindkey '^l' forward-word
bindkey '^k' forward-char

# retarded default setting tbh
setopt no_share_history
unsetopt share_history

export BROWSER="chromium"
export EDITOR="nvim"
export VISUAL="nvim"

export HISTFILE="$HOME/.config/zsh/.zsh_history"
SAVEHIST=10000
HISTSIZE=10000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt INC_APPEND_HISTORY
setopt HIST_SAVE_NO_DUPS
setopt dot_glob 

# fix paste bug
zstyle ':bracketed-paste-magic' active-widgets '.self-*'

# complex plugins
source "$HOME/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$HOME/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "$HOME/.config/zsh/plugins/extract/extract.zsh"

eval "$(dircolors -b)"

[[ ! -r /home/brymko/.opam/opam-init/init.zsh ]] || source /home/brymko/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null 

# solana
export PATH="$PATH:$HOME/.local/share/solana/install/active_release/bin"
