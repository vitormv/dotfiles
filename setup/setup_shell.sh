#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

source "$DOTFILES_ROOT/setup/utils/layout.sh"
source "$DOTFILES_ROOT/setup/utils/system.sh"

function setup_shell() {
  title_h1 "Shell & Terminal"

  # -- ZSH ---------------------------------------------------------------------
  make_zsh_default_shell

  ensure_directory_exists "$HOME/.config/zsh/completions" verbose

  fnm completions --shell=zsh >"$HOME/.config/zsh/completions/fnm"
  status "zsh: FNM completion for ZSH" $?

  ensure_line_exists "${HOME}/.zshrc" 'source "$HOME/.zshrc.dotfiles"'

  # avoid Error "zsh compinit: insecure directories" warnings when loading zsh-completions
  # remove group write permissions recursively (@see: https://github.com/zsh-users/zsh-completions/issues/433)
  chmod go-w "$(brew --prefix)/share"
  chmod -R go-w "$(brew --prefix)/share/zsh"

  status "zsh: Add sourcing of .zshrc.dotfiles" OK

  # -- BASH --------------------------------------------------------------------

  ensure_directory_exists "$HOME/.config/bash/completions" verbose

  fnm completions --shell=bash >"$HOME/.config/bash/completions/fnm"
  status "bash: FNM completion for Bash" $?

  ensure_line_exists "${HOME}/.bashrc" 'source "$HOME/.bashrc.dotfiles"'

  status "bash: Add sourcing of .bashrc.dotfiles" OK

  # -- ITERM -------------------------------------------------------------------

  # Specify the preferences directory
  defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$DOTFILES_ROOT/home/.config/iTerm"

  # Tell iTerm2 to use the custom preferences in the directory
  defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true

  status "iTerm: Setup external config file" OK

  # make sure bat reads any new syntax-highlight themes installed
  bat cache --build >/dev/null
}

setup_shell
