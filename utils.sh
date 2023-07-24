#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# @todo is this still needed?
function source_for_this_machine() {
  # load the desired file
  [[ -f "$1" ]] && source "$1"

  # but also try a machine specific (by hostname) file if it exists
  NAME=$(scutil --get HostName)
  [[ -f "$1@@$NAME" ]] && source "$1@@$NAME"
}
