#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

source lib/system.sh
source lib/layout.sh

function setup_shell() {
  title_h1 "Shell (bash + zsh)"

  # ----------------------
  title_h2 "ZSH" 0

  make_zsh_default_shell

  fnm completions --shell=zsh >"$HOME/.config/zsh/completions/fnm"
  status "FNM completion for ZSH" $?

  # ----------------------
  title_h2 "Bash"

  fnm completions --shell=bash >"$HOME/.config/bash/completions/fnm"
  status "FNM completion for Bash" $?
}
