#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

setup_dotfiles() {
  title_h1 "HOME Symlinks"

  local DIR="$DOTFILES_ROOT"
  local TARGET_DIR=$1

  local overwrite_all=false backup_all=false skip_all=false

  local json_file="${DIR}/homedir/_mappings.json"

  # Check if the JSON file exists
  if [ -f "${json_file}" ]; then
    local OIFS=$IFS # Store IFS separator within a temp variable

    # Because we need to ask for user input down below (and use "read" again)
    # the file is being read into thefile descriptor 3, to not cause conflict
    while IFS= read -r -u 3 line; do
      local from to
      from=$(echo "$line" | jq -r '.from')
      to=$(echo "$line" | jq -r '.to')

      local source_file_relative existing_link

      # create an array of line items
      local source_file="$DIR/${from}"
      local target_file="$TARGET_DIR/${to}"
      source_file_relative=$(grealpath --relative-base="${DIR}/.." "$source_file")

      local noop=0

      local output_message prompt_message
      output_message="$(gray)Copying $(clr)$(pretty_path "$target_file")   $(gray)← ${source_file_relative}$(clr)"
      prompt_message="${PREFIX_EMPTY} $(yellow)↑ File already exists, what do you want to do?$(clr)"
      local action=""

      if [[ -f "$target_file" || -d "$target_file" || -L "$target_file" ]]; then
        if [ "$overwrite_all" == "false" ] && [ "$backup_all" == "false" ] && [ "$skip_all" == "false" ]; then
          existing_link="$(readlink "$target_file" || true)"

          if [ "$existing_link" == "$source_file" ]; then
            noop=1
          else
            warning "${output_message}"
            echo -en "${prompt_message}\n${PREFIX_EMPTY}  [s]kip, [o]verwrite, [b]ackup?"

            while [[ $action == "" ]]; do
              read -r -s -n 1 choice

              case "$choice" in
              o)
                action="overwrite"
                ;;
              O)
                action="overwrite"
                overwrite_all=true
                ;;
              b)
                action="backup"
                ;;
              B)
                action="backup"
                backup_all=true
                ;;
              s)
                action="skip"
                ;;
              S)
                action="skip"
                skip_all=true
                ;;
              *) ;;
              esac
            done
          fi
        fi
      fi

      local is_skip is_overwrite is_backup
      is_skip=$([[ $action == "skip" || $skip_all == "true" ]] && echo 1 || echo 0)
      is_overwrite=$([[ $action == "overwrite" || $overwrite_all == "true" ]] && echo 1 || echo 0)
      is_backup=$([[ $action == "backup" || $backup_all == "true" ]] && echo 1 || echo 0)

      local clean_message
      clean_message="$PREFIX_EMPTY"$(strip_ansi "$output_message")
      local end_col=${#clean_message} # move cursor to end of prompt mesage

      if [[ $is_overwrite -eq 1 ]]; then
        rm -rf "$target_file"
      fi

      if [[ $is_backup -eq 1 ]]; then
        rename_with_increment "$target_file" "${target_file}.backup"
      fi

      # Create symbolic link
      if [[ $is_skip -eq 0 ]]; then
        ln -fs "${source_file}" "${target_file}"
      fi

      if [[ $action == '' ]]; then
        if [[ $noop -eq 1 ]]; then
          inform_tag "$output_message" yellow "already exists"
        else
          inform_tag "$output_message" green "created"
        fi
      else
        echo -ne '\033[2A\r' # Move cursor up one line, and go to the 1st column
        echo -ne "\033[${end_col}C [$(yellow)${action}$(clr)]\n"
      fi
    done 3< <(jq -c '.[]' "$json_file") # Supply $json_file on file descriptor 3

    IFS=$OIFS # Restore original IFS

    pad_start "" 50 " "
    status "All files have been copied" OK
  else
    echo "JSON file not found: $json_file"
  fi
}
