#!/bin/bash

source_if_exists() {
  [[ -f "$1" ]] && source "$1"
}

function source_for_this_machine() {
  local target_file=$1

  # load the desired file
  source_if_exists "$target_file"

  # but also try a machine specific (by hostname) file if it exists
  machine_name=$(scutil --get HostName)
  source_if_exists "$target_file@@$machine_name"
}

function is_truthy() {
  if [[ "$1" =~ ^(true|TRUE|yes|YES|y|Y|on|ON|1)$ ]]; then
    return 0
  else
    return 1
  fi
}

function get-filename() {
  local file_path file_name

  file_path=$(readlink -f "$1")
  file_name=$(basename "$file_path")

  echo "${file_name%.*}"
}

function get-extension() {
  local file_path file_name

  file_path=$(readlink -f "$1")
  file_name=$(basename "$file_path")

  echo "${file_name##*.}"
}
