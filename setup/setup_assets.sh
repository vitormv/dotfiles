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

  ensure_directory_exists "$HOME/projects"
  ensure_directory_exists "$HOME/.tools"

  ensure_file_exists "$HOME/.bashrc.local"
}
