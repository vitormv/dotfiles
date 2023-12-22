starship init fish | source

source "$HOME/dotfiles/shell/bash_aliases"

# override bash reload alias for fish
alias reload "source ~/.config/fish/config.fish"

set -U fish_greeting
