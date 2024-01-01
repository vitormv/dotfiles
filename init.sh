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

echo ""
echo "$(bgCyan)$(black) DOTFILES $(clr) ($(gray)root:$(clr) $(pretty_path "$DOTFILES_ROOT"))"

echo -e "\n$(gray)Using settings from:$(clr) $(pretty_path "$DOTFILES_SETTINGS_FILE")"

# ask for sudo permssions only if needed
if ! sudo --validate -n &>/dev/null; then
  echo -e "\nGet sudo permissions"
  sudo -v --prompt="  $(cyan)◆$(clr) %p password: "
fi

# ask early, we will be needing it

# @todo add README.md file   https://github.com/aaronbates/dotfiles/blob/master/README.md

source "$DOTFILES_ROOT/setup/setup_dependencies.sh"
source "$DOTFILES_ROOT/setup/setup_assets.sh"
source "$DOTFILES_ROOT/setup/setup_git.sh"
source "$DOTFILES_ROOT/setup/setup_homedir.sh" "${HOME}"
source "$DOTFILES_ROOT/setup/setup_osx.sh"
source "$DOTFILES_ROOT/setup/setup_ssh.sh"
source "$DOTFILES_ROOT/setup/setup_shell.sh"

echo -e '\n\n✅ All done! Your system is ready to roll! 🔥 🔥 🔥'
