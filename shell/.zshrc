# shared history in all zsh
# setopt inc_append_history
# setopt share_history
setopt no_share_history
unsetopt share_history

# new terminal in the same directory
# function cd {
#     builtin cd $@
#     pwd > "$ZDOTDIR/.last_dir"
# }

# if [ -f "$ZDOTDIR/.last_dir" ]; then
#     cd "$(cat $ZDOTDIR/.last_dir)"
# fi

export ZSH="$HOME/.config/oh-my-zsh"

ZSH_THEME="alanpeabody"

HYPHEN_INSENSITIVE="true"

DISABLE_MAGIC_FUNCTIONS=true

plugins=(git zsh-autosuggestions zsh-syntax-highlighting extract sudo colored-man-pages)
source $ZSH/oh-my-zsh.sh

if type rg &> /dev/null; then
    export FZF_DEFAULT_COMMAND='rg --files'
    # border is small
    export FZF_DEFAULT_OPTS='--height 50% --border --reverse' # -m
fi

alias l="exa -lamg --sort type --color=automatic"
alias ls="exa --sort type --color=automatic"
alias rg="rg -i"
alias ip="ip -c"
alias ida64="wine /home/brymko/ctf/IDA/ida/ida64.exe &; disown; exit"
alias ida="wine /home/brymko/ctf/IDA/ida/ida.exe &; disown; exit"
alias vi="vim"
alias work="ssh -Y work"
alias ncdu="ncdu -r"
alias virtm="sudo virt-manager&; disown; exit"
alias vm="$HOME/vm/vm.sh"

pdf () { 
    zathura $* &; disown;
}

bindkey '^l' autosuggest-accept
