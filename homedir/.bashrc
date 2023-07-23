source "$HOME/.dotfiles/utils.sh"

source_for_this_machine "$HOME/.dotfiles/shell/bash_exports"
source_for_this_machine "$HOME/.dotfiles/shell/bash_aliases"
source_for_this_machine "$HOME/.dotfiles/shell/bash_functions"
source_for_this_machine "$HOME/.dotfiles/shell/bash_prompt"

[[ -f "$1" ]] && source "$HOME/.bashrc.local"
