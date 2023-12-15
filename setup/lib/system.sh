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

function setup_machine_name() {
  local current_name
  current_name=$(get_dotfiles_setting MACHINE_NAME)

  if [[ -n $current_name ]]; then
    debug "Machine Name already configured"
  else
    inform "This machine doesn't have a name yet"
    echo -n "${PREFIX_EMPTY}→ how do you want to call it (no dots)? "
    read current_name
  fi

  sudo scutil --set HostName "$current_name"
  sudo scutil --set LocalHostName "$current_name"
  sudo scutil --set ComputerName "$current_name"

  set_dotfiles_setting 'MACHINE_NAME' "$current_name"

  status "Configured ComputerName, HostName and LocalHostName" OK
}

function make_zsh_default_shell() {
  local zsh_path
  zsh_path="$(which zsh)"

  # Check zsh is not already the default shell
  if [ "$SHELL" != "$zsh_path" ]; then
    # If zsh is not listed as a shell, list it
    if ! grep -q "^$(which zsh)$" /etc/shells; then
      inform "Adding zsh to the list of shells (/etc/shells)"

      sudo sh -c "echo $(which zsh) >> /etc/shells"
    fi

    chsh -s "$zsh_path"

    status "$zsh_path configured as the default shell" OK
  else
    inform_tag "ZSH is already the default shell" green "OK"
  fi
}

function replace_app_icon() {
  local application=$1
  local app_icon_name=$2
  local new_icon=$3

  local app_path="/Applications/${application}"
  local app_icon_path="${app_path}/Contents/Resources/${app_icon_name}"
  local new_icon_path="${DOTFILES_ROOT}/${new_icon}"

  if [ ! -d "$app_path" ]; then
    echo "APP NOT FOUND"
    exit 1
  fi

  if [ ! -f "$app_icon_path" ]; then
    echo "ICON NOT FOUND"
  fi

  echo "NEW ICON PATH: $new_icon_path"
  echo "APP ICON PATH: $app_icon_path"

  # sudo mv "$app_icon_path" "$app_icon_path.backup"
  sudo cp -f "$new_icon_path" "$app_icon_path"
  touch "${app_path}"
}
