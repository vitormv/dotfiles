#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

function install_homebrew() {
  inform "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

  inform "Running 'brew doctor'"

  brew doctor
  [[ $? ]] && success "Homebrew installed" OK
}

function setup_dependencies() {
  title_h1 "Dependencies"

  if check_dependencies brew; then
    status "Checking homebrew installation" OK
  else
    install_homebrew
  fi

  title_h2 "Install Homebrew packages"
  brew bundle --no-lock --file "${DOTFILES_ROOT}/homedir/Brewfile"
}
