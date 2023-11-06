#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

DOTFILES_ROOT=$(pwd -P)
DOTFILES_SETTINGS_FILE="${HOME}/.config/dotfiles/settings.env"
if ${DEBUG+"false"}; then
  DEBUG=
fi

source "./lib/strings.sh"
source "./lib/filesystem.sh"
source "./lib/layout.sh"
source "./lib/system.sh"

source "./setup/setup_assets.sh"
source "./setup/setup_dependencies.sh"
source "./setup/setup_dotfiles.sh"
source "./setup/setup_git.sh"
source "./setup/setup_osx.sh"
source "./setup/setup_ssh.sh"
source "./setup/setup_shell.sh"
source "./setup/setup_secrets.sh"

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
# @todo init_iterm vscode kitty
# @todo add firefox extensions?
# @todo add chrome extensions?
# @todo add all my vscode extensions?
# @todo add cronjob for checking mouse battery

echo -e '\n\n✅ All done! Enjoy your new system.'
