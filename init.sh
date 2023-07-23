#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

DOTFILES_ROOT=$(pwd -P)
if ${DEBUG+"false"}; then
  DEBUG=
fi

source "${DOTFILES_ROOT}/_lib/utils/strings.sh"
source "${DOTFILES_ROOT}/_lib/utils/filesystem.sh"
source "${DOTFILES_ROOT}/_lib/utils/layout.sh"
source "${DOTFILES_ROOT}/_lib/utils/system.sh"

source "${DOTFILES_ROOT}/setup/setup_assets.sh"
source "${DOTFILES_ROOT}/setup/setup_dependencies.sh"
source "${DOTFILES_ROOT}/setup/setup_git.sh"
source "${DOTFILES_ROOT}/setup/setup_secrets.sh"
source "${DOTFILES_ROOT}/setup/setup_dotfiles.sh"
source "${DOTFILES_ROOT}/setup/setup_osx.sh"

echo "ROOT: $DOTFILES_ROOT"

setup_dependencies
setup_assets
setup_git
setup_secrets
setup_dotfiles "${HOME}/playground"
setup_osx
# @todo init_iterm vscode kitty
# @todo init fnm node manager   # https://freddiecarthy.com/blog/use-git-and-bash-to-automate-your-developer-tooling
# @todo add cronjob for checking mouse battery

echo -e '\n\n✅ All done! Enjoy your new system.'
