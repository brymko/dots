
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
RPS1='$($HOME/.config/zsh/gitp.sh)'

# menu highlighting, straight ripped from oh-my-zsh
unsetopt menu_complete
unsetopt flowcontrol
setopt auto_menu
setopt complete_in_word
setopt always_to_end
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' special-dirs true
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*:*:*:users' ignored-patterns \
        adm amanda apache at avahi avahi-autoipd beaglidx bin cacti canna \
        clamav daemon dbus distcache dnsmasq dovecot fax ftp games gdm \
        gkrellmd gopher hacluster haldaemon halt hsqldb ident junkbust kdm \
        ldap lp mail mailman mailnull man messagebus  mldonkey mysql nagios \
        named netdump news nfsnobody nobody nscd ntp nut nx obsrun openvpn \
        operator pcap polkitd postfix postgres privoxy pulse pvm quagga radvd \
        rpc rpcuser rpm rtkit scard shutdown squid sshd statd svn sync tftp \
        usbmux uucp vcsa wwwrun xfs '_*'
autoload -U +X compinit && compinit -i -C

zstyle -e ':completion:*:default' list-colors 'reply=("${PREFIX:+=(#bi)($PREFIX:t)(?)*==02=01}:${(s.:.)LS_COLORS}")'
zstyle -e ':completion:*:default' list-colors 'reply=("${PREFIX:+=(#bi)($PREFIX:t)(?)*==34=34}:${(s.:.)LS_COLORS}")'

# fzf
if type rg &> /dev/null; then
    export FZF_DEFAULT_COMMAND='rg --files'
    export FZF_DEFAULT_OPTS='--height 50% --border --reverse' # -m
fi

alias l="exa -lamg --sort type --color=automatic"
alias ls="exa --sort type --color=automatic"
alias rg="rg -i"
alias ip="ip -br -c"
alias ida64="wine /home/brymko/ctf/IDA/ida/ida64.exe &; disown; exit"
alias ida="wine /home/brymko/ctf/IDA/ida/ida.exe &; disown; exit"
alias vi="vim"
alias work="ssh -Y work"
alias ncdu="ncdu -r"
alias vm="$HOME/vm/vm.sh"
alias sed="sd" 
alias grep="rg"

pdf () { 
    zathura $* &; disown;
}

bindkey '^[[Z' reverse-menu-complete
bindkey '^p' up-line-or-history
bindkey '^n' down-line-or-history
bindkey '^o' autosuggest-accept
bindkey '^h' backward-word
bindkey '^j' backward-char
bindkey '^l' forward-word
bindkey '^k' forward-char

# retarded default setting tbh
setopt no_share_history
unsetopt share_history

export BROWSER="chromium"
export EDITOR="vim"

export HISTFILE="$HOME/.config/zsh/.zsh_history"
SAVEHIST=10000
HISTSIZE=10000

# fix paste bug
zstyle ':bracketed-paste-magic' active-widgets '.self-*'

# complex plugins
source "$HOME/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$HOME/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "$HOME/.config/zsh/plugins/extract/extract.zsh"

