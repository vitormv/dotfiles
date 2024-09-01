#!/usr/bin/env bash
IFS=$'\n\t'

# This script is a wrapper around `git commit` that prompts the user for a
# commit message if one is not provided as an argument. It also automatically
# prepends the Jira ticket number to the commit message if the branch name
# starts with a Jira ticket number.

# Initialize variables
has_message_flag=0
has_any_flag=0
no_verify_flag=""

# Check for "-n" as the first argument
if [[ "$1" == "-n" ]]; then
  no_verify_flag="-n"
  shift # Remove "-n" from the arguments list
fi

function cyan() { printf "\e[36m"; }
function gray() { printf "\e[38;5;242m"; }
function clr() { printf "\e[0m"; }

# Iterate over all arguments
for arg in "$@"; do
  if [ "$arg" == "-m" ]; then
    has_message_flag=1
    has_any_flag=1
    break # Exit loop after finding the message
  elif [[ "$arg" == "-"* ]]; then
    has_any_flag=1
  fi
done

# Proceed based on whether a commit message was provided
if [[ "$has_message_flag" == "1" ]]; then
  git commit no_verify_flag "$@" # Pass all arguments to git commit
else
  branch_name=$(git symbolic-ref --short HEAD)
  message="    $(cyan)◆$(clr) $(gray)Commit message:$(clr) "

  msg_prefix=""

  # if branch name starts with a Jira ticket number, use it as prefix
  if [[ $branch_name =~ ^([A-Z]+-[0-9]{2,5})\- ]]; then
    msg_prefix="${BASH_REMATCH[1]}: "
  fi

  # if we dont have ANY flag argument, use all arguments as commit message
  if [[ "$has_any_flag" == "0" ]]; then
    all_args=("$@")
    input="${all_args[@]}"
    commit_msg="${msg_prefix}${input}" # concatenate all args as string

    git commit $no_verify_flag -m "$commit_msg"
  else
    # prompt user for message and prefx with jira ticket
    read -e -p "$message" -i "$msg_prefix" commit_msg
    echo # Add a newline after the prompt

    git commit $no_verify_flag "$@" -m "$commit_msg"
  fi
fi
