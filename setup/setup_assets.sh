#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

source "$DOTFILES_ROOT/setup/utils/filesystem.sh"

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

  title_h2 "Ensure files exist"

  ensure_file_exists "$HOME/.bashrc.local" verbose
  ensure_file_exists "$DOTFILES_SETTINGS_FILE" verbose
}

setup_assets
