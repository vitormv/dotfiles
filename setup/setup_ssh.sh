#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

source lib/system.sh
source lib/layout.sh

function setup_ssh() {
  title_h1 "SSH"

  ensure_directory_exists "$HOME/.ssh" verbose

  local github_id_file="$HOME/.ssh/github_id_rsa"

  if [ -f "${github_id_file}" ]; then
    inform_tag "Github SSH credentials" yellow "already exists"
  else
    ssh-keygen -q -t ed25519 -C "vitor@vmello.com" -f "$github_id_file" -N ""
    inform_tag "Github SSH credentials" green "created"

    ssh-add -K "$github_id_file"

    echo -e "\n$(red)Paste this SSH key into your Github account:$(clr)"
    echo -e "cat ${github_id_file}.pub\n"
    echo -e "$(cat "${github_id_file}.pub")"
    echo -e

    read -n 1 -p "  Press ENTER to continue"
  fi
}
