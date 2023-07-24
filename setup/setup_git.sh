#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

function setup_git() {
  title_h1 "Git"

  local git_name git_email

  git_name=$(git config user.name || echo)
  git_email=$(git config user.email || echo)

  if [[ -z "$git_name" ]]; then
    # ask the user for Git Name
    inform "Setting up Git Author"
    echo -n "${PREFIX_EMPTY}→ please type your name: "
    read chosen_git_name

    if [[ -n "$chosen_git_name" ]]; then
      git_name="${chosen_git_name}"
      git config --global user.name "$git_name"
    else
      warning "No Git user name has been set.  Please update manually"
    fi

    # ask the user for Git Email
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

  # Set user settings
  git config --global user.useconfigonly true

  # Set core settings
  git config --global core.excludesfile "~/.gitignore_global"
  git config --global core.filemode false
  git config --global core.autocrlf false
  git config --global core.pager "delta"

  # Set interactive settings
  git config --global interactive.diffFilter "delta --color-only"

  # Set delta settings
  git config --global delta.features "mellow-barbet"
  git config --global delta.syntax-theme "Monokai Extended Origin"
  git config --global delta.line-numbers true
  git config --global delta.light false
  git config --global delta.side-by-side true
  git config --global delta.inline-hint-style "syntax"
  git config --global delta.minus-style "syntax \"#53171c\""
  git config --global delta.plus-style "syntax \"#3a412a\""

  # Set include settings
  git config --global include.path "~/.config/git-delta/themes.gitconfig"

  # Set merge settings
  git config --global merge.conflictstyle "diff3"

  # Set diff settings
  git config --global diff.colorMoved "default"

  # Set alias settings
  git config --global alias.cleanup-branches "!git co master && git branch --merged | grep -v '\\*' | xargs -n 1 git branch -d"
  git config --global alias.apply-url "!f() { curl -s \$1 2>nul | git apply \${@:2}; }; f"
  git config --global alias.switch "!legit switch"
  git config --global alias.branches "!legit branches"
  git config --global alias.sprout "!legit sprout \"\$@\""
  git config --global alias.undo "reset --soft HEAD^"
  git config --global alias.diffs "diff --staged"
  git config --global alias.pushf "push -u --force"
  git config --global alias.st "status"
  git config --global alias.ci "commit"
  git config --global alias.co "checkout"
  git config --global alias.br "branch"
  git config --global alias.push "push -u"
  git config --global alias.fpo "fetch --prune origin"
  git config --global alias.caam "commit --all --amend --no-edit"
  git config --global alias.aa "add --all"
  git config --global alias.amend "commit --amend --no-edit"
  git config --global alias.ls "log --pretty=format:\"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]\" --decorate"
  git config --global alias.ll "log --pretty=format:\"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]\" --decorate --numstat"
  git config --global alias.lnc "log --pretty=format:\"%h\\ %s\\ [%cn]\""
  git config --global alias.lds "log --pretty=format:\"%C(yellow)%h\\ %ad%Cred%d\\ %Creset%s%Cblue\\ [%cn]\" --decorate --date=short"
  git config --global alias.ld "log --pretty=format:\"%C(yellow)%h\\ %ad%Cred%d\\ %Creset%s%Cblue\\ [%cn]\" --decorate --date=relative"
  git config --global alias.resync "!legit resync"
  git config --global alias.stale "for-each-ref --sort=committerdate refs/heads/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'"
  git config --global alias.alias "! git config --get-regexp ^alias\\. | sed -e s/^alias\\.// -e s/\\ /\\ =\\ /"

  # Set other settings
  git config --global push.default current
  git config --global color.ui true
  git config --global color.diff true
  git config --global pull.ff only
  git config --global init.defaultBranch main
  git config --global filter.lfs.clean "git-lfs clean -- %f"
  git config --global filter.lfs.smudge "git-lfs smudge -- %f"
  git config --global filter.lfs.process "git-lfs filter-process"
  git config --global filter.lfs.required true
}
