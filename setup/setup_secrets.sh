#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

function setup_secrets() {
  title_h1 "Secrets"

  # List of secrets that need to exist in OSX Keychain
  # @todo use associative array with helper lines https://linuxhint.com/associative_array_bash/
  declare -a required_secrets=(
    "HOMEBREW_GITHUB_API_TOKEN"
  )

  for VARIABLE_NAME in "${required_secrets[@]}"; do
    if security find-generic-password -a "$USER" -s "$VARIABLE_NAME" -w &>/dev/null; then
      status "$(gray)Keychain secret $(clr)${VARIABLE_NAME}" OK
    else
      warning "Missing Keychain secret '${VARIABLE_NAME}'. Please add:"
      security add-generic-password -a "$USER" -s "$VARIABLE_NAME" -w
    fi
  done
}
