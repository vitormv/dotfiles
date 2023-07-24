#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

source ./_lib/utils/filesystem.sh

setup_assets() {
  title_h1 "Assets"

  # Copy all files from ./assets/images to ~/Pictures
  for source_file in "$DOTFILES_ROOT/assets/images"/*; do
    copy_file "$source_file" "$HOME/Pictures"
  done

  title_h2 "Install Nerd Fonts"

  # Copy all files from ./assets/fonts to ~/Library/Fonts
  for source_file in "$DOTFILES_ROOT/assets/fonts"/*; do
    copy_file "$source_file" "$HOME/Library/Fonts"
  done

  title_h2 "Ensure directories exist"

  ensure_directory_exists "$HOME/projects" verbose
  ensure_directory_exists "$HOME/.tools" verbose
  ensure_directory_exists "$HOME/.config" verbose
  ensure_directory_exists "$HOME/.config/zsh/completions" verbose
  ensure_directory_exists "$HOME/.config/bash/completions" verbose

  title_h2 "Ensure files exist"

  ensure_file_exists "$HOME/.bashrc.local"
  ensure_file_exists "$DOTFILES_SETTINGS_FILE"
  ensure_file_exists "$HOME/.gitignore_global"

  # @todo add download for git-detal themes automatically
  # download_if_not_exists "https://raw.githubusercontent.com/dandavison/delta/master/themes.gitconfig" "$HOME/.config/git-delta/themes.gitconfig"
}
