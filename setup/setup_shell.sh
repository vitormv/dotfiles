#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

source lib/system.sh
source lib/layout.sh

function setup_shell() {
  title_h1 "Shell (bash + zsh)"

  # ----------------------
  title_h2 "ZSH" 0

  make_zsh_default_shell

  fnm completions --shell=zsh >"$HOME/.config/zsh/completions/fnm"
  status "FNM completion for ZSH" $?

  ensure_line_exists "${HOME}/.zshrc" 'source "$HOME/.zshrc.dotfiles"'
  ensure_line_exists "${HOME}/.zshrc" '# ZSH command green/red highlighting (HAS TO BE THE LAST COMMAND!!) (for apple and intel)'
  ensure_line_exists "${HOME}/.zshrc" 'source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"'

  status "Add sourcing of .zshrc.dotfiles" OK

  # ----------------------
  title_h2 "Bash"

  fnm completions --shell=bash >"$HOME/.config/bash/completions/fnm"
  status "FNM completion for Bash" $?

  ensure_line_exists "${HOME}/.bashrc" 'source "$HOME/.bashrc.dotfiles"'

  status "Add sourcing of .bashrc.dotfiles" OK
}
