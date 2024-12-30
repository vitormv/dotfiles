#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

source "$DOTFILES_ROOT/setup/utils/system.sh"
source "$DOTFILES_ROOT/setup/utils/layout.sh"

function setup_ssh() {
  title_h1 "SSH & Secrets"

  [ -z "$DEBUG" ] || ensure_directory_exists "$HOME/.ssh" verbose
  [ -z "$DEBUG" ] || ensure_file_exists "$HOME/.ssh/config" verbse

  local github_id_file="$HOME/.ssh/github_id_rsa"

  if [ -f "${github_id_file}" ]; then
    inform_tag "Github SSH credentials" yellow "already exists"
  else
    ssh-keygen -q -t ed25519 -C "vitor@vmello.com" -f "$github_id_file" -N ""
    inform_tag "Github SSH credentials" green "created"

    ssh-add --apple-use-keychain "$github_id_file"

    echo -e "\n$(red)Paste this SSH key into your Github account:$(clr)"
    echo -e "cat ${github_id_file}.pub\n"
    echo -e "$(cat "${github_id_file}.pub")"
    echo -e

    read -n 1 -p "  Press ENTER to continue"
  fi

  # add Github config if not yet exists
  local ssh_config_file="$HOME/.ssh/config"
  if grep --quiet 'IdentityFile ~/.ssh/github_id_rsa' "$ssh_config_file"; then
    inform_tag "Add github.com to SSH config" yellow "already exists"
  else
    echo "
host github.com
  User git
  Hostname github.com
  PreferredAuthentications publickey
  IdentityFile ~/.ssh/github_id_rsa
" >>"$ssh_config_file"

    status "Add github.com to SSH config" OK
  fi

  # ----------------------
  # Secrets

  # List of secrets that need to exist in OSX Keychain
  declare -a required_secrets=(
    "HOMEBREW_GITHUB_API_TOKEN"
  )

  for VARIABLE_NAME in "${required_secrets[@]}"; do
    if security find-generic-password -a "$USER" -s "$VARIABLE_NAME" -w &>/dev/null; then
      inform_tag "$(gray)Keychain secret $(clr)${VARIABLE_NAME}" yellow "already exists"
    else
      warning "Missing Keychain secret '${VARIABLE_NAME}'. Please add:"
      security add-generic-password -a "$USER" -s "$VARIABLE_NAME" -w
    fi
  done

  # TO UPDATE SECRETS:
  # Usually once a year since Github API tokens expire after a while:
  #   security delete-generic-password -U -a "$USER" -s HOMEBREW_GITHUB_API_TOKEN
}

setup_ssh
