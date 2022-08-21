# change config path
export ZDOTDIR="$HOME/.config/zsh"

if [ -x /usr/bin/dircolors ]; then
    eval "$(dircolors -b)"
fi

# This is done to edit my vim config faster
export MYVIMRC="$HOME/.config/nvim/init.vim"

# rust binaries 
export PATH="$PATH:$HOME/.cargo/bin"

# local binaries
export PATH="$PATH:$HOME/.local/bin"

# fucking ruby
# why the fuck does every new language drop their stuff in a new local folder
export PATH="$PATH:$HOME/.gem/ruby/2.7.0/bin"

# go 
# why the fuck does every new language drop their stuff in a new local folder
export PATH="$PATH:$HOME/go/bin"

# solana
export PATH="$PATH:$HOME/.local/share/solana/install/active_release/bin"

