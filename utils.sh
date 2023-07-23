#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# @todo rename to source_for_this_machine
function source_for_this_machine() {
  NAME=$(scutil --get HostName)
  [[ -f "$1" ]] && source "$1"
  [[ -f "$1@@$NAME" ]] && source "$1@@$NAME"
}
