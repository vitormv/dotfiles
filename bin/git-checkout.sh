#!/usr/bin/env bash
IFS=$'\n\t'

# This script is a wrapper around `git commit` that prompts the user for a
# commit message if one is not provided as an argument. It also automatically
# prepends the Jira ticket number to the commit message if the branch name
# starts with a Jira ticket number.

# Initialize variables
has_branch_name=0

function cyan() { printf "\e[36m"; }
function gray() { printf "\e[38;5;242m"; }
function clr() { printf "\e[0m"; }

# Iterate over all arguments
for arg in "$@"; do
  if [ "$arg" == "-m" ]; then
    has_branch_name=1
    break # Exit loop after finding the message
  fi
done

# Proceed based on whether a commit message was provided
if [[ "$has_branch_name" == "1" ]]; then
  git checkout "$@" # Pass all arguments to git commit
else
  message="    $(cyan)◆$(clr) $(gray)Branch name:$(clr) "

  if [[ $branch_name =~ atlassian\.net\/browse\/([A-Z]+-[0-9]{2,5}) ]]; then
    jira_ticket="${BASH_REMATCH[1]}"
    read -e -p "$message" -i "$jira_ticket: " branch_name
  else
    read -e -p "$message" branch_name
  fi

  echo # Add a newline after the prompt
  git checkout -b "$branch_name" "$@"
fi
