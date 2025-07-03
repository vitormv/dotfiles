#!/bin/bash
set -euo pipefail

# Format branches with colorized output similar to 'git stale' but with more compact format
# Limited to last 10 branches by committerdate
branches=$(git for-each-ref --count=10 --sort=-committerdate refs/heads/ --format='%(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) (%(color:green)%(committerdate:relative)%(color:reset))')

if [[ -z "$branches" ]]; then
  echo "No branches found."
  exit 1
fi

# Use fzf to interactively select a branch with keyboard navigation
# --ansi: enable ANSI color interpretation
# --height: set height of the fzf window
# --reverse: display from top to bottom
# --no-preview: explicitly disable the preview window
selected_branch=$(echo "$branches" | fzf --ansi --height=40% --no-preview --reverse --header="Select a branch to checkout (Ctrl-C to quit)" | awk '{print $1}')

# Check if a branch was selected
if [[ -n "$selected_branch" ]]; then
  echo "Checking out: $selected_branch"
  git checkout "$selected_branch"
else
  echo "Operation cancelled."
  exit 0
fi
