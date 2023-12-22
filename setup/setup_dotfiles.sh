#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

function process_dotfile() {
  local from to

  local TARGET_DIR="$1"
  local file_path="$2"
  local mode="$3"

  from="home/${file_path}"
  to="${file_path}"

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
        echo -en "${prompt_message}\n${PREFIX_EMPTY} $(gray)delta \"$source_file\" \"$target_file\"$(clr)\n${PREFIX_EMPTY}  [s|S]kip, [o|O]verwrite, [b|B]ackup? "

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

  if [[ $is_overwrite -eq 1 ]]; then
    rm -rf "$target_file"
  fi

  if [[ $is_backup -eq 1 ]]; then
    rename_with_increment "$target_file" "${target_file}.backup"
  fi

  # Create symbolic link
  if [[ $is_skip -eq 0 ]]; then
    ensure_directory_exists "$(dirname "${target_file}")"
    ln -fs "${source_file}" "${target_file}"
  fi

  if [[ $action == '' ]]; then
    if [[ $noop -eq 1 ]]; then
      inform_tag "$output_message" yellow "already exists"
    else
      inform_tag "$output_message" green "created"
    fi
  else
    # echo -ne '\033[3A\r' # Move cursor up one line, and go to the 1st column
    echo -ne "[$(yellow)${action}$(clr)]\n"
  fi
}

setup_dotfiles() {
  title_h1 "HOME Symlinks"

  local DIR="$DOTFILES_ROOT"
  local TARGET_DIR=$1

  local overwrite_all=false backup_all=false skip_all=false

  process_dotfile "$TARGET_DIR" ".config/bat/themes/monokai-dimmed.tmTheme" symlink
  process_dotfile "$TARGET_DIR" ".config/fish/config.fish" symlink
  process_dotfile "$TARGET_DIR" ".config/git-delta/themes.gitconfig" symlink
  process_dotfile "$TARGET_DIR" ".config/kitty/kitty.conf" symlink
  process_dotfile "$TARGET_DIR" ".config/kitty/theme.conf" symlink
  process_dotfile "$TARGET_DIR" ".config/starship.toml" symlink
  process_dotfile "$TARGET_DIR" ".bashrc.dotfiles" symlink
  process_dotfile "$TARGET_DIR" ".zshrc.dotfiles" symlink
  process_dotfile "$TARGET_DIR" "Brewfile" symlink
  process_dotfile "$TARGET_DIR" "Library/Application Support/Code/User/keybindings.json" symlink
  process_dotfile "$TARGET_DIR" "Library/Application Support/Code/User/settings.json" symlink
  process_dotfile "$TARGET_DIR" "Library/Preferences/org.videolan.vlc/vlcrc" symlink
}
