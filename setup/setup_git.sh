#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

function setup_git() {
  local git_name git_email

  git_name=$(git config user.name || echo)
  git_email=$(git config user.email || echo)

  if [[ -z "$git_name" ]]; then
    inform "Setting up Git Author"
    echo -n "${PREFIX_EMPTY}→ please type your name: "
    read chosen_git_name

    if [[ -n "$chosen_git_name" ]]; then
      git_name="${chosen_git_name}"
      git config --global user.name "$git_name"
    else
      warning "No Git user name has been set.  Please update manually"
    fi

    echo -n "${PREFIX_EMPTY}→ now type your email: "
    read chosen_git_email

    if [[ -n "$chosen_git_email" ]]; then
      git_email="${chosen_git_email}"
      git config --global user.email "$git_email"
    else
      warning "No Git user email has been set.  Please update manually"
    fi
  else
    status "Git is already configured" OK
  fi
}
