#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

source ./lib/layout.sh

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
  local output_message mkdir_result mode
  local target_dir=$1

  mode=${2:-}

  output_message="Create directory $(pretty_path "$target_dir")"
  if [ -d "$target_dir" ]; then
    [ "$mode" == "verbose" ] && inform_tag "$output_message" yellow "already exists"
  else
    mkdir -p "$target_dir"
    mkdir_result=$?

    if [ "$mode" == "verbose" ]; then
      status "$output_message" "$mkdir_result"
    fi
  fi

  return 0 # function is always successfull
}

function ensure_file_exists() {
  local output_message
  local target_file=$1

  output_message="Create file $(pretty_path "$target_file")"
  if [ -f "$target_file" ]; then
    inform_tag "$output_message" yellow "already exists"
  else
    ensure_directory_exists "$(dirname "${target_file}")" verbose
    touch "$target_file"

    status "$output_message" $?
  fi

  return 0 # function is always successfull
}

# run function in a subshell, as to not define variables in host process
function get_dotfiles_setting() (
  local variable_name=$1

  [[ -f "$DOTFILES_SETTINGS_FILE" ]] && source "$DOTFILES_SETTINGS_FILE"

  # read variable by its name and avoid "unbound variable" error
  local value="${!variable_name:-}"

  if [ -n "${value}" ]; then
    echo "$value"
  fi
)

# run function in a subshell, as to not mess with variables in host process
function set_dotfiles_setting() (
  local name=$1
  local value=$2
  local sorted_and_unique

  # ensure line is removed (if it exists)
  sed -i '' "/export ${name}=/d" "$DOTFILES_SETTINGS_FILE"

  # save value to file
  echo -e -n "export ${name}=\"${value}\"\n" >>"$DOTFILES_SETTINGS_FILE"

  sorted_and_unique=$(sort "$DOTFILES_SETTINGS_FILE" | uniq)

  echo -e "$sorted_and_unique\n" >"$DOTFILES_SETTINGS_FILE"
)
