#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

function strip_ansi() {
  shopt -s extglob # function uses extended globbing
  printf %s "${1//$'\e'\[*([0-9;])m/}"
}

# pad a string up to a minimum length
function pad_start() {
  local string="$1"
  local target_length="$2"
  local pad_char="${3:- }" # Default pad character is space

  local string_length=${#string}
  local padding_length=$((target_length - string_length))

  if [ $padding_length -gt 0 ]; then
    local padding
    padding=$(printf "%${padding_length}s" "$pad_char")
    echo "$padding$string"
  else
    echo "$string"
  fi
}

# Convert string value to float
# @todo is this needed?
function float() {
  if [ "$1" = '""' ] || [ -z "$1" ]; then
    echo 0
    return 0
  fi

  echo "$1" | sed 's/,/\./' | bc -l

  return 0
}

# if a string starts with $HOME, replace it with "~/"
function short_home() {
  local input_string="$1"

  if [[ "$input_string" == "$HOME"* ]]; then
    echo "~${input_string#"$HOME"}"
  else
    echo "$input_string"
  fi
}

# @todo is this needed?
function is_truthy() {
  if [[ "$1" =~ ^(true|TRUE|yes|YES|y|Y|on|ON|1)$ ]]; then
    return 0
  else
    return 1
  fi
}
