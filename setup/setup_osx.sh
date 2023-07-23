#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# https://github.com/mathiasbynens/dotfiles/blob/master/.macos

# Amazing MACOS shortcuts and settings, and bash functions
# https://github.com/webpro/dotfiles/blob/main/system/.alias.macos

# Gist with nice stuff: https://gist.github.com/steinbrueckri/02287553f62597c6de77295c4dcdcaea

# Here is a rough cheatsheet for syntax.
#   Key Modifiers
#   ^ : Ctrl
#   $ : Shift
#   ~ : Option (Alt)
#   @ : Command (Apple)
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

# ⌘ Command (or Cmd)
# ⇧ Shift
# ⌥ Option (or Alt)
# ⌃ Control (or Ctrl)

function setup_osx() {
  title_h1 "OSX Setup"

  # Close any open System Preferences panes, to prevent them from overriding
  # settings we’re about to change
  osascript -e 'tell application "System Preferences" to quit'
  killall keyboardservicesd &>/dev/null || true

  if [ "$(uname)" != "Darwin" ]; then
    warning "Not a macOS (Darwin) system, skipping"
  else

    local cmd="@"
    local shift="\$"
    local ctrl="^"
    local optn="~"

    # @todo: add configurations OSX
    # defaults write NSGlobalDomain KeyRepeat -int 1
    # defaults write com.apple.dock tilesize -int 70

    title_h2 "Add MacOS keyboard shortcuts" 0

    defaults write -g NSUserKeyEquivalents -dict-add 'Move Window to Left Side of Screen' "${cmd}${optn}${ctrl}${shift}\UF702"
    defaults write -g NSUserKeyEquivalents -dict-add 'Move Window to Right Side of Screen' "${cmd}${optn}${ctrl}${shift}\UF703"
    defaults write -g NSUserKeyEquivalents -dict-add 'Lock Screen' "${cmd}${shift}L"
    status "Shortcuts added" OK

    title_h2 "Add MacOS keyboard replacements"

    osx_add_text_replacement '&shrug;' '¯\_(ツ)_/¯'
    osx_add_text_replacement '&flip;' '(╯°□°)╯︵ ┻━┻'
    osx_add_text_replacement '&noflip;' '┬─┬ノ( º _ ºノ)'
    osx_add_text_replacement '&oreally;' "﴾͡๏̯͡๏﴿ O'RLY?"
    osx_add_text_replacement '&smirk;' "( ͡° ͜ʖ ͡°)"
    osx_add_text_replacement '&smirkmany;' "( ͡°( ͡° ͜ʖ( ͡° ͜ʖ ͡°)ʖ ͡°) ͡°)"
    osx_add_text_replacement '&wat;' "ಠ_ಠ"
    osx_add_text_replacement '&fuckyou;' '╭∩╮(´• ᴗ •`˵)╭∩╮'
    osx_add_text_replacement '&fuckoff;' '╭∩╮（︶_︶）╭∩╮'

    # persist changes
    defaults read -g &>/dev/null
    killall cfprefsd

    title_h2 "Install Nerd Fonts"

    # Copy all files from ./assets/fonts to ~/Library/Fonts
    for source_file in "$DOTFILES_ROOT/assets/fonts"/*; do
      copy_file "$source_file" "$HOME/Library/Fonts"
    done
  fi
}
