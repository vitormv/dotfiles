#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

source ./_lib/utils/layout.sh

function rename_with_increment() {
  local source_file="$1"
  local target_file="$2"
  local backup_file="$target_file"
  local counter=1

  # Check if the target file already exists
  while [ -e "$backup_file" ]; do
    backup_file="${target_file}_${counter}"
    counter=$((counter + 1))
  done

  # Rename the source file to the target file
  mv "$source_file" "$backup_file"
}

function copy_file() {
  local source_file=$1
  local destination_dir=$2

  if [ -f "$source_file" ]; then
    local filename destination_file output_message
    filename=$(basename "$source_file")
    destination_file="$destination_dir/$filename"

    output_message="Copying $(gray)$(pretty_path "$destination_file" "$destination_dir")$(clr)"

    # Check if the destination file already exists
    if [ -e "$destination_file" ]; then
      inform_tag "$output_message" yellow "already exists"
    else
      cp "$source_file" "$destination_file"
      status "$output_message" $?
    fi
  else
    warning "Source file not found: ${source_file}"
  fi
}

function ensure_directory_exists() {
  local output_message
  local target_dir=$1

  output_message="Create directory $(pretty_path "$target_dir")"
  if [ -d "$target_dir" ]; then
    inform_tag "$output_message" yellow "already exists"
  else
    mkdir -p "$target_dir"
    status "$output_message" $?
  fi
}

function ensure_file_exists() {
  local output_message
  local target_file=$1

  output_message="Create file $(pretty_path "$target_file")"
  if [ -f "$target_file" ]; then
    inform_tag "$output_message" yellow "already exists"
  else
    touch "$target_file"
    status "$output_message" $?
  fi
}
