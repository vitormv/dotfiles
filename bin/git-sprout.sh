#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

function cyan() { printf "\e[36m"; }
function gray() { printf "\e[38;5;242m"; }
function clr() { printf "\e[0m"; }

# This script creates a new branch with prefix from JIRA ticket
# it takes a single argument like "https://nelly.atlassian.net/browse/NEL-4399"
# then will prompt the user for a branch name, with prefix "NEL-4399-"

# Check if a URL was provided
if [ "$#" -ne 1 ]; then
  echo -e "\n    Usage: git sprout <JIRA Ticket URL>"
  exit 1
fi

# Extract the ticket ID from the URL
ticket_url="$1"
ticket_id=$(echo "$ticket_url" | grep -oE '[A-Z]+-[0-9]{2,5}')

if [ -z "$ticket_id" ]; then
  echo "Could not extract ticket ID from URL."
  exit 1
fi

# Check if the current branch is clean
if [ -n "$(git status --porcelain)" ]; then
  echo -e "\n  Working directory is not clean. Aborting."
  exit 1
fi

message="    $(cyan)◆$(clr) $(gray)Enter new branch name:$(clr) "
branch_name=""

# Prompt the user for a branch name, prefilling with ticket ID
read -e -p "$message" -i "${ticket_id}-" branch_name

current_branch=$(git symbolic-ref --short HEAD)

if [ "$current_branch" == "main" ]; then
  target_branch="main"
else
  # Prompt the user to choose between main and current branch
  echo -e "    $(cyan)◆$(clr) $(gray)Which branch to use?$(clr) "
  echo -e "       $(gray)1)$(clr) main  $(gray)(default)$(clr)"
  echo -e "       $(gray)2)$(clr) $current_branch (current)"
  echo -e ""
  read -e -p "    $(cyan)◆$(clr) $(gray) Enter your choice [1 or 2] (ENTER for main): $(clr)" choice

  if [ "$choice" == "1" ] || [ "$choice" == "" ]; then
    target_branch="main"
  else
    target_branch="$current_branch"
  fi
fi

if [ "$target_branch" != "$current_branch" ] || [ "$target_branch" == "main" ]; then
  echo -e ""

  git checkout "$target_branch" >/dev/null 2>&1

  echo -e "   $(gray)Pulling latest changes from $(clr)\"main\"$(gray) ...$(clr)"
  git pull >/dev/null 2>&1
fi

# Create the new branch
git checkout -b "$branch_name" >/dev/null 2>&1

echo -e "\n   Switched to a new branch '$branch_name'\n"
