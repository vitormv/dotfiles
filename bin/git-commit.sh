#!/usr/bin/env bash
IFS=$'\n\t'

# Initialize variables
has_message_flag=0

function cyan() { printf "\e[36m"; }
function gray() { printf "\e[38;5;242m"; }
function clr() { printf "\e[0m"; }

# Iterate over all arguments
for arg in "$@"; do
  if [ "$arg" == "-m" ]; then
    has_message_flag=1
    break # Exit loop after finding the message
  fi
done

# Proceed based on whether a commit message was provided
if [[ "$has_message_flag" == "1" ]]; then
  git commit "$@" # Pass all arguments to git commit
else
  branch_name=$(git symbolic-ref --short HEAD)
  message="    $(cyan)◆$(clr) $(gray)Commit message:$(clr) "

  if [[ $branch_name =~ ^([A-Z]+-[0-9]{2,5})\- ]]; then
    jira_ticket="${BASH_REMATCH[1]}"
    read -e -p "$message" -i "$jira_ticket: " commit_msg
  else
    read -e -p "$message" commit_msg
  fi

  git commit "$@" -m "$commit_msg"
fi
