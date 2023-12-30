#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_SETTINGS_FILE="${HOME}/.config/dotfiles/settings.env"
if ${DEBUG+"false"}; then
  DEBUG=
fi

source "$DOTFILES_ROOT/setup/utils/strings.sh"
source "$DOTFILES_ROOT/setup/utils/layout.sh"
source "$DOTFILES_ROOT/setup/utils/filesystem.sh"
source "$DOTFILES_ROOT/setup/utils/system.sh"

source "$DOTFILES_ROOT/setup/setup_assets.sh"
source "$DOTFILES_ROOT/setup/setup_dependencies.sh"
source "$DOTFILES_ROOT/setup/setup_dotfiles.sh"
source "$DOTFILES_ROOT/setup/setup_git.sh"
source "$DOTFILES_ROOT/setup/setup_osx.sh"
source "$DOTFILES_ROOT/setup/setup_ssh.sh"
source "$DOTFILES_ROOT/setup/setup_shell.sh"

echo "ROOT: $(pretty_path "$DOTFILES_ROOT")"
echo "SETTINGS: $(pretty_path "$DOTFILES_SETTINGS_FILE")"

# ask early, we will be needing it
sudo -v

# @todo add README.md file   https://github.com/aaronbates/dotfiles/blob/master/README.md

setup_dependencies
setup_assets
setup_git
setup_dotfiles "${HOME}"
setup_osx
setup_ssh
setup_shell

# when pulling from github for the first time, since there is no SSH yet
# repo will be pulled with https. But now that we configure things
# set git origin back to SSH if needed
if git --git-dir ~/dotfiles/.git remote get-url origin | grep https; then
  git --git-dir ~/dotfiles/.git remote set-url git@github.com:vitormv/dotfiles.git
fi

echo -e '\n\n✅ All done! Your System is Certified lit 🔥 🔥 🔥'
