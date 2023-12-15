#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

DOTFILES_ROOT=$(pwd -P)
DOTFILES_SETTINGS_FILE="${HOME}/.config/dotfiles/settings.env"
if ${DEBUG+"false"}; then
  DEBUG=
fi

source "$DOTFILES_ROOT/setup/lib/strings.sh"
source "$DOTFILES_ROOT/setup/lib/layout.sh"
source "$DOTFILES_ROOT/setup/lib/filesystem.sh"
source "$DOTFILES_ROOT/setup/lib/system.sh"

source "$DOTFILES_ROOT/setup/setup_assets.sh"
source "$DOTFILES_ROOT/setup/setup_dependencies.sh"
source "$DOTFILES_ROOT/setup/setup_dotfiles.sh"
source "$DOTFILES_ROOT/setup/setup_git.sh"
source "$DOTFILES_ROOT/setup/setup_osx.sh"
source "$DOTFILES_ROOT/setup/setup_ssh.sh"
source "$DOTFILES_ROOT/setup/setup_shell.sh"
source "$DOTFILES_ROOT/setup/setup_secrets.sh"

echo "ROOT: $(pretty_path "$DOTFILES_ROOT")"
echo "SETTINGS: $(pretty_path "$DOTFILES_SETTINGS_FILE")"

# ask early, we will be needing it
sudo -v

# @todo add README.md file   https://github.com/aaronbates/dotfiles/blob/master/README.md

setup_dependencies
setup_assets
setup_git
setup_secrets
setup_dotfiles "${HOME}"
setup_osx
setup_ssh
setup_shell

# when pulling from github for the first time, since there is no SSH yet
# repo will be pulled with https. But now that we configure things
# set origin back to SSH if needed
if git --git-dir ~/dotfiles/.git remote get-url origin | grep https; then
  git --git-dir ~/dotfiles/.git remote set-url git@github.com:vitormv/dotfiles.git
fi

# @todo init_iterm vscode kitty
# @todo add firefox extensions?
# @todo add chrome extensions?
# @todo add dotfiles diff APP command for non symlinked things
# @todo add cronjob for checking mouse battery
# @todo Persist Kap changes/ /Users/vitormello/Library/Application\ Support/Kap/config.json
# @todo add Google DNS 1.1.1.1
#       https://osxdaily.com/2015/06/02/change-dns-command-line-mac-os-x/
#       networksetup -getdnsservers Ethernet
#       networksetup -getdnsservers Wi-Fi

echo -e '\n\n✅ All done! Enjoy your new system.'
