#!/usr/bin/env bash
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

message="    $(cyan)◆$(clr) $(gray)Enter branch name:$(clr) "
branch_name=""

# Prompt the user for a branch name, prefilling with ticket ID
read -e -p "$message" -i "${ticket_id}-" branch_name

# Create the new branch
git checkout -b "$branch_name"
