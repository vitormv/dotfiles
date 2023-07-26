# @todo is this still needed?
function source_for_this_machine() {
  # load the desired file
  [[ -f "$1" ]] && source "$1"

  # but also try a machine specific (by hostname) file if it exists
  NAME=$(scutil --get HostName)
  [[ -f "$1@@$NAME" ]] && source "$1@@$NAME"
}

function is_truthy() {
  if [[ "$1" =~ ^(true|TRUE|yes|YES|y|Y|on|ON|1)$ ]]; then
    return 0
  else
    return 1
  fi
}
