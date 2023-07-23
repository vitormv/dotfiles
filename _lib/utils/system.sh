#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Function for checking script dependencies
function check_dependencies() {
  local result=0
  local code

  for cmd in "${@}"; do
    command -v "$cmd" >/dev/null 2>&1
    code=$?

    status_dbg "DEPENDENCY: $cmd" ${code}

    if [[ ${code} -ne 0 ]]; then
      warning "$(bold)$(blue)$cmd$(clr) command not available"
      result=1
    fi
  done

  debug "check_dependencies() result: $result"

  return ${result}
}

function osx_add_text_replacement() {
  local uuid count quoted_replacement replaced_regex_escaped

  local shortcut="$1"
  local replacement="$2"
  local db_file="$HOME/Library/KeyboardServices/TextReplacements.db"
  local plist_file="$HOME/Library/Preferences/.GlobalPreferences.plist"

  debug "${shortcut}:"

  replaced_regex_escaped=$(printf '%s\nf' "$replacement" | sed -e 's/[\/&]/\\&/g')

  # check if item already exists in TextReplacements.db
  count=$(sqlite3 "$db_file" "SELECT count(*) FROM ZTEXTREPLACEMENTENTRY WHERE ZSHORTCUT = '$shortcut'")
  debug "  $(gray)exists in DB?:$(clr) ${count}"
  if [ "$count" == '0' ]; then
    uuid=$(uuidgen)
    timestamp=$(date +%s)

    quoted_replacement=${replaced_regex_escaped/\'/\'\'}
    local sql="INSERT INTO \"ZTEXTREPLACEMENTENTRY\" VALUES (NULL,1,1,0,0,${timestamp},'${quoted_replacement}','${shortcut}','${uuid}',NULL);"

    sqlite3 "$db_file" "$sql"

    debug " $(gray)added to TextReplacements.db$(clr)"
  fi

  # check if item already exists in the NSUserDictionaryReplacementItems
  local in_dictionary
  in_dictionary=$(plutil -p "$plist_file" | grep --count "$shortcut" || true)

  if [[ $in_dictionary != "false" ]]; then
    # echo ""
    debug "  $(gray)exists in .GlobalPreferences.plist$(clr)"
  else
    defaults write -g NSUserDictionaryReplacementItems -array-add "{ on=1; replace='${shortcut}'; with=\"${replacement}\"; }"
    debug "  $(gray)added to .GlobalPreferences.plist$(clr)"
  fi

  status "Added shortcut ${shortcut}" OK
}
