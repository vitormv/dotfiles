#!/bin/bash
# set -euo pipefail
# IFS=$'\n\t'

source "./lib/strings.sh"

function black() {
  printf "\e[30m"
}

function red() {
  printf "\e[31m"
}

function green() {
  printf "\e[32m"
}

function yellow() {
  printf "\e[33m"
}

function blue() {
  printf "\e[34m"
}

function magenta() {
  printf "\e[35m"
}

function cyan() {
  printf "\e[36m"
}

function white() {
  printf "\e[37m"
}

function gray() {
  printf "\e[38;5;242m"
}

function grey() {
  gray
}

function bold() {
  printf "\e[1m"
}

function clr() {
  printf "\e[0m"
}

pad_start() {
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

PREFIX_LENGTH=17
PREFIX_EMPTY=$(pad_start "" $PREFIX_LENGTH " ")
export PREFIX_EMPTY

# Function for datetime output
function format_date() {
  printf "%s%s%s" "$(gray)" "$(date +%H:%M:%S)" "$(clr)"
}

# Function for error messages
function error() {
  printf "%s [%sERROR%s] $1\n" "$(format_date)" "$(red)" "$(clr)" >&2
}

# Function for informational messages
function inform() {
  printf "%s [%sINFO%s] $1\n" "$(format_date)" "$(blue)" "$(clr)"
}

function inform_tag() {
  local color message tag
  message=$1
  color=$($2)
  tag=$3

  inform "${message} [${color}${tag}$(clr)]"
}

# Function for warning messages
function warning() {
  printf "%s [%sWARN%s] $1\n" "$(format_date)" "$(yellow)" "$(clr)" >&2
}

# Function for debug messages
function debug() {
  [ -z "$DEBUG" ] || printf "%s [%s ?? %s] $1\n" "$(format_date)" "$(gray)" "$(clr)"
}

# Function for operation status
#
# Usage: status MESSAGE STATUS
# Examples:
#     status 'Upload scripts' $?
#     status 'Run operation' OK
#     status 'Run operation' FAIL
function status() {
  if [[ -z $1 ]] || [[ -z $2 ]]; then
    error 'status(): not found required parameters!'
    return 1
  fi

  local result=0
  # shellcheck disable=SC2155
  local -r ok_msg="$(format_date) [$(green)%s$(clr)] "
  # shellcheck disable=SC2155
  local -r err_msg="$(format_date) [$(red)%s$(clr)] "

  if [[ $2 = OK ]]; then
    printf "$ok_msg%b\n" ' OK ' "$1"
  elif [[ $2 = FAIL ]]; then
    printf "$err_msg%b\n" FAIL "$1"
    result=1
  elif [[ $2 = 0 ]]; then
    printf "$ok_msg%b\n" ' OK ' "$1"
  elif [[ $2 -gt 0 ]]; then
    printf "$err_msg%b\n" FAIL "$1"
    result=1
  fi

  return ${result}
}

# Function for status on some command in debug mode only
# Examples:
#     status_dbg 'Debug operation status' $?
#     status_dbg 'Debug operation status' OK
#     status_dbg 'Debug operation status' FAIL
function status_dbg() {
  [ -z "$DEBUG" ] && return 0

  if [[ -z $1 ]] || [[ -z $2 ]]; then
    error 'status_dbg(): not found required parameters!'
    return 1
  fi

  local result=0
  # shellcheck disable=SC2155
  local -r ok_msg="$(format_date) [$(green)%s$(clr)] "
  # shellcheck disable=SC2155
  local -r err_msg="$(format_date) [$(red)%s$(clr)] "

  if [[ $2 = OK ]]; then
    printf "$ok_msg%b\n" ' ++ ' "$1"
  elif [[ $2 = FAIL ]]; then
    printf "$err_msg%b\n" ' -- ' "$1"
  elif [[ $2 = 0 ]]; then
    printf "$ok_msg%b\n" ' ++ ' "$1"
  elif [[ $2 -gt 0 ]]; then
    printf "$err_msg%b\n" ' -- ' "$1"
    result=1
  fi

  return ${result}
}

function title_h1() {
  local title=$1

  echo -e "\n$(gray)# =================================================$(clr)"
  echo -e "$(gray)#$(clr) ${title}:\n"
}

function title_h2() {
  local title=$1
  local margin_top=${2:-1}

  [ "$margin_top" -eq 1 ] && echo ""
  echo -e "$(gray)---------$(clr) ${title}:"
}

# prints a path with the prefix portion (defaults to $HOME) in gray
# if path begins with $HOME, also shorten to ~/
function pretty_path() {
  local input_path base_path
  input_path=$(short_home "$1")
  base_path=$(short_home "${2:-$HOME}/")

  if [[ "$input_path" == "$base_path"* ]]; then
    echo "$(gray)${base_path}$(clr)${input_path#"$base_path"}"
  else
    echo "$input_path"
  fi
}
