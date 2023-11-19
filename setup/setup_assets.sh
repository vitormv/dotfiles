#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

source ./lib/filesystem.sh

setup_assets() {
  title_h1 "Assets"

  # Copy all files from ./assets/images to ~/Pictures
  for source_file in "$DOTFILES_ROOT/assets/images"/*; do
    copy_file "$source_file" "$HOME/Pictures"
  done

  title_h2 "Ensure directories exist"

  ensure_directory_exists "$HOME/projects" verbose
  ensure_directory_exists "$HOME/.tools" verbose
  ensure_directory_exists "$HOME/.config" verbose
  ensure_directory_exists "$HOME/.config/zsh/completions" verbose
  ensure_directory_exists "$HOME/.config/bash/completions" verbose

  title_h2 "Ensure files exist"

  ensure_file_exists "$HOME/.bashrc.local" verbose
  ensure_file_exists "$DOTFILES_SETTINGS_FILE" verbose
  ensure_file_exists "$HOME/.gitignore_global" verbose

  # @todo add download for git-delta themes automatically
  # download_if_not_exists "https://raw.githubusercontent.com/dandavison/delta/master/themes.gitconfig" "$HOME/.config/git-delta/themes.gitconfig"
}
