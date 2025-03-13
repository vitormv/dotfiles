#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

function setup_git() {
  title_h1 "Git"

  local git_name git_email

  git_name=$(git config user.name || echo)
  git_email=$(git config user.email || echo)

  ensure_directory_exists "$HOME/.config/git/"

  # @todo move git stuff to ~/.config/.git
  # https://git-scm.com/book/en/v2/Customizing-Git-Git-Configuration

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
    inform_tag "Git user/email already setup" yellow skipping
  fi

  # Set user settings
  git config --global user.useconfigonly true

  # Set core settings
  ensure_file_exists "$HOME/.config/git/gitignore" verbose
  git config --global core.excludesfile "~/.config/git/gitignore"
  git config --global core.filemode false
  git config --global core.autocrlf false
  git config --global core.pager "delta"

  # Set interactive settings
  git config --global interactive.diffFilter "delta --color-only"

  # Set delta settings
  git config --global delta.features "mellow-barbet"      # List options: delta --show-themes
  git config --global delta.syntax-theme "monokai-dimmed" # List options: bat --list-themes && delta --show-syntax-themes
  git config --global delta.line-numbers true
  git config --global delta.light false
  git config --global delta.side-by-side true
  git config --global delta.inline-hint-style "syntax"
  git config --global delta.minus-style "syntax \"#53171c\""
  git config --global delta.plus-style "syntax \"#3a412a\""
  git config --global delta.file-style "yellow ul"
  git config --global delta.file-decoration-style "none"
  git config --global delta.file-added-label "[+]"
  git config --global delta.file-copied-label "[COPIED]"
  git config --global delta.file-modified-label "[*]"
  git config --global delta.file-removed-label "[-]"
  git config --global delta.file-renamed-label "[RENAMED]"
  git config --global delta.hunk-header-decoration-style "\"#3e3e43\" ul"
  git config --global delta.zero-style "dim syntax"
  git config --global include.path "~/.config/git-delta/themes.gitconfig"

  # Set merge settings
  git config --global merge.conflictstyle "diff3"

  # Set diff settings
  git config --global diff.colorMoved "default"

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

  status "Configure global $(pretty_path "~/.gitconfig") settings" OK

  # Set alias settings
  git config --global alias.aa "add --all"
  git config --global alias.abort "rebase --abort"
  git config --global alias.alias "! git config --get-regexp ^alias\\. | sed -e s/^alias\\.// -e s/\\ /\\ =\\ /"
  git config --global alias.amend "commit --amend --no-edit"
  git config --global alias.apply-url "!f() { curl -s \$1 2>nul | git apply \${@:2}; }; f"
  git config --global alias.br "branch"
  git config --global alias.cleanup-branches "! git co main && git branch --merged | grep -v '\\*' | xargs -n 1 git branch -d"
  git config --global alias.caam "commit --all --amend --no-edit"
  git config --global alias.ci "!f() { bash \"$DOTFILES_ROOT/bin/git-commit.sh\" \"\$@\"; }; f"
  git config --global alias.cin "commit --no-verify"
  git config --global alias.co "checkout"
  git config --global alias.cont "rebase --continue"
  git config --global alias.continue "rebase --continue"
  git config --global alias.count '! git ls-files | wc -l'
  git config --global alias.diffs "diff --staged"
  git config --global alias.fpo "fetch --prune origin"
  git config --global alias.ld "log --pretty=format:\"%C(yellow)%h\\ %ad%Cred%d\\ %Creset%s%Cblue\\ [%cn]\" --decorate --date=relative"
  git config --global alias.lds "log --pretty=format:\"%C(yellow)%h\\ %ad%Cred%d\\ %Creset%s%Cblue\\ [%cn]\" --decorate --date=short"
  git config --global alias.ls "log --pretty=format:\"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]\" --decorate"
  git config --global alias.ll "log --pretty=format:\"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]\" --decorate --numstat"
  git config --global alias.lnc "log --pretty=format:\"%h\\ %s\\ [%cn]\""
  git config --global alias.main '!f() { git show-ref -q --heads main && git checkout main || git checkout master; }; f' # go to main/master, whichever exists
  git config --global alias.mergeff "merge --no-ff"
  git config --global alias.ps "push -u"
  git config --global alias.psf "push -u --force"
  git config --global alias.psn "push -u --no-verify"
  git config --global alias.psfn "push -u --force --no-verify"
  git config --global alias.pushfn "push -u --force --no-verify"
  git config --global alias.pushf "push -u --force"
  git config --global alias.pushn "push -u --no-verify"
  git config --global alias.sprout "!f() { bash \"$DOTFILES_ROOT/bin/git-sprout.sh\" \"\$@\"; }; f"
  git config --global alias.st "status"
  git config --global alias.stale "for-each-ref --sort=committerdate refs/heads/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'"
  git config --global alias.tree "log --all --graph --decorate --oneline"
  git config --global alias.undo "reset --soft HEAD^"
  git config --global alias.wip "! git add . && git commit --no-verify -m \"WIP\""

  # alias: temporarily ignore changes to files (avoid commiting changes by mistake)
  git config --global alias.ghost "update-index --assume-unchanged"
  git config --global alias.ghosted "!f() { git ls-files -v | grep \"^[[:lower:]]\"; }; f" # list ghosted files
  git config --global alias.unghost "update-index --no-assume-unchanged"

  # make git always use ssh instead of https
  git config --global url."git@github.com:".insteadOf "https://github.com/"

  status "Git aliases" OK
}

setup_git
