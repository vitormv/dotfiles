#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# https://github.com/mathiasbynens/dotfiles/blob/master/.macos

# Gist with nice stuff: https://gist.github.com/steinbrueckri/02287553f62597c6de77295c4dcdcaea

# Here is a rough cheatsheet for syntax.
#   Key Modifiers
#   $ : (⇧) Shift
#   ^ : (⌃) Ctrl
#   ~ : (⌥) Option (Alt)
#   @ : (⌘) Command (Apple)
#   # : Numeric Keypad
#
# Non-Printable Key Codes
#
#   Standard
#   Up Arrow:     \UF700        Backspace:    \U0008        F1:           \UF704
#   Down Arrow:   \UF701        Tab:          \U0009        F2:           \UF705
#   Left Arrow:   \UF702        Escape:       \U001B        F3:           \UF706
#   Right Arrow:  \UF703        Enter:        \U000A        ...
#   Insert:       \UF727        Page Up:      \UF72C
#   Delete:       \UF728        Page Down:    \UF72D
#   Home:         \UF729        Print Screen: \UF72E
#   End:          \UF72B        Scroll Lock:  \UF72F
#   Break:        \UF732        Pause:        \UF730
#   SysReq:       \UF731        Menu:         \UF735
#   Help:         \UF746
#
# OS X
#   delete:       \U007F
#
# For a good reference see http://osxnotes.net/keybindings.html.

function setup_osx() {
  title_h1 "macOS Setup"

  # Close any open System Preferences panes, to prevent them from overriding
  # settings we’re about to change
  osascript -e 'tell application "System Preferences" to quit'
  killall keyboardservicesd &>/dev/null || true

  if [ "$(uname)" != "Darwin" ]; then
    warning "Not a macOS (Darwin) system, skipping"
  else
    source "$DOTFILES_ROOT/setup/osx/settings.sh"
    status "System settings and preferences" OK

    local is_dock_items_configured
    is_dock_items_configured=$(get_dotfiles_setting "DOCK_ITEMS_CONFIGURED" || echo "false")

    if is_truthy "$is_dock_items_configured"; then
      inform_tag "Dock Items already configured" yellow "skipping"
    else
      source "$DOTFILES_ROOT/setup/osx/dock_items.sh"
      set_dotfiles_setting "DOCK_ITEMS_CONFIGURED" "true"

      status "Rearranged Dock Items" OK
    fi

    local cmd="@"
    local shift="\$"
    local ctrl="^"
    local optn="~"

    defaults write -g NSUserKeyEquivalents -dict-add 'Lock Screen' "${cmd}${shift}L"

    # MacOS 14 and below
    if [[ $(sw_vers -productVersion | cut -d "." -f 1 | cut -d "," -f 1) -lt 15 ]]; then
      defaults write -g NSUserKeyEquivalents -dict-add 'Move Window to Left Side of Screen' "${cmd}${optn}${ctrl}${shift}\UF702"
      defaults write -g NSUserKeyEquivalents -dict-add 'Move Window to Right Side of Screen' "${cmd}${optn}${ctrl}${shift}\UF703"
    fi

    # MacOS 15 and above
    if [[ $(sw_vers -productVersion | cut -d "." -f 1 | cut -d "," -f 1) -ge 15 ]]; then
      defaults write -g NSUserKeyEquivalents -dict-add '\033Window\033Fill' "${cmd}${optn}${ctrl}${shift}\UF700"
      defaults write -g NSUserKeyEquivalents -dict-add '\033Window\033Move & Resize\033Left' "${cmd}${optn}${ctrl}${shift}\UF702"
      defaults write -g NSUserKeyEquivalents -dict-add '\033Window\033Move & Resize\033Right' "${cmd}${optn}${ctrl}${shift}\UF703"
    fi

    status "Added keyboard shortcuts" OK

    # machine name
    setup_machine_name

    # input text replacemetns
    osx_add_text_replacement '&shrug;' '¯\_(ツ)_/¯'
    osx_add_text_replacement '&flip;' '(╯°□°)╯︵ ┻━┻'
    osx_add_text_replacement '&noflip;' '┬─┬ノ( º _ ºノ)'
    osx_add_text_replacement '&orly;' "﴾͡๏̯͡๏﴿ O'RLY?"
    osx_add_text_replacement '&smirk;' "( ͡° ͜ʖ ͡°)"
    osx_add_text_replacement '&wat;' "ಠ_ಠ"
    osx_add_text_replacement '&fuckyou;' '╭∩╮(´• ᴗ •`˵)╭∩╮'
    osx_add_text_replacement '&fuckoff;' '╭∩╮（︶_︶）╭∩╮'

    status "Added Input Text Replacements" OK

    # persist changes
    defaults read -g &>/dev/null
    killall cfprefsd

    # ----------------------
    # title_h2 "Application Icons"
    # @todo does not seem to work on OSX Ventura :(
    # replace_app_icon kitty.app kitty.icns "assets/app_icons/kitty.icns"
    # replace_app_icon iTerm.app AppIcon.icns "assets/app_icons/iTerm2.icns"
    # replace_app_icon 'Visual Studio Code.app' Code.icns "assets/app_icons/vscode.icns"
    # VLC: also had to overwrite the VLC.icns manually inside the folder
    # READ current icon defaults read "defaults read /Applications/kitty.app/Contents/Info CFBundleIconFile"

    # ----------------------
    duti $([[ -n "$DEBUG" ]] && echo -n "-v") "$DOTFILES_ROOT/setup/osx/default_apps.duti"

    status "Default \"Open With\" applications" OK

    title_h2 "Sublime Text"

    local MAX_WAIT=30 # Maximum number of seconds to wait
    local waited=0
    local sublime_dir="$HOME/Library/Application Support/Sublime Text"
    local sublime_packages_dir="$HOME/Library/Application Support/Sublime Text/Installed Packages"
    local package_control_settings="${sublime_dir}/Packages/User/Package Control.sublime-settings"

    # check if we need to create sublime config dirs
    if ! [[ -d "$sublime_packages_dir" ]]; then
      inform_tag "Sublime Text settings directory" yellow "MISSING"

      # Open Sublime Text to create necessary folders
      subl .

      until [[ -d "$sublime_packages_dir" ]] || [[ $waited -ge $MAX_WAIT ]]; do
        echo "Waiting for Sublime Text to initialize..."
        sleep 1
        ((waited++))
      done

      if [[ -d "$sublime_packages_dir" ]]; then
        sleep 2
        status "Sublime Settings directory created" OK
      else
        status "Sublime Text did not initialize within $MAX_WAIT seconds." FAIL
        exit 1
      fi

      # Quit Sublime after folder are created
      # osascript -e 'quit app "Sublime Text"'

      echo -r "Please COMPLETELY QUIT Sublime Text manually."
      echo -e -n "    Press ENTER to continue... "
      read # Wait for user to press enter.
    else
      inform_tag "Sublime Text settings directory" yellow "already exists"
    fi

    # install package control if not already installed
    if ! [ -f "${sublime_dir}/Installed Packages/Package Control.sublime-package" ]; then
      wget -P "${sublime_dir}/Installed Packages" --quiet https://packagecontrol.io/Package%20Control.sublime-package
      status "Package Control installed" OK
    fi

    # init "Package Control.sublime-settings" json if it doesnt exist or if file is empty
    if ! [ -f "$package_control_settings" ] || [ ! -s "$package_control_settings" ]; then
      echo "{}" >"${sublime_dir}/Packages/User/Package Control.sublime-settings"
      status "Package Control settings file created" OK
    fi

    bat "$package_control_settings"

    # use jq to append some items to installed_packages uniquely
    jq '.installed_packages |= (. + ["A File Icon"] | unique | sort_by(. as $s | ascii_downcase))' "$package_control_settings" | sponge "$package_control_settings"
    jq '.installed_packages |= (. + ["ayu"] | unique | sort_by(. as $s | ascii_downcase))' "$package_control_settings" | sponge "$package_control_settings"
    jq '.installed_packages |= (. + ["Package Control"] | unique | sort_by(. as $s | ascii_downcase))' "$package_control_settings" | sponge "$package_control_settings"

    status "Sublime Text fully configured" OK
  fi
}

setup_osx
