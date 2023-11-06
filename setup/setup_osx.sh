#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# https://github.com/mathiasbynens/dotfiles/blob/master/.macos

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

    title_h2 "Set my prefered default MacOS settings" 0
    # @todo: add configurations OSX
    # defaults write NSGlobalDomain KeyRepeat -int 1
    # defaults write com.apple.dock tilesize -int 70

    ############################
    # System
    ############################

    # no siri in menubar
    defaults write com.apple.systemuiserver "NSStatusItem Visible Siri" -bool false
    # always show all extensions
    defaults write -g AppleShowAllExtensions -bool true

    # Use list view in all Finder windows by default
    defaults write com.apple.finder FXPreferredViewStyle -string "clmv"
    defaults write com.apple.finder SearchRecentsSavedViewStyle -string "clmv"

    defaults write com.apple.finder EmptyTrashSecurely -bool true # Empty Trash securely by default

    # Expand save panel by default
    defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
    defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

    # Expand print panel by default
    defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
    defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

    ############################
    # Keyboard & Input
    ############################

    # Disable press-and-hold for keys in favor of key repeat
    defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

    # Disable auto-correct
    defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

    defaults write -g InitialKeyRepeat -int 30
    defaults write -g KeyRepeat -int 2

    # Trackpad: enable tap to click for this user and for the login screen
    defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
    defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
    defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

    ############################
    # Finder
    ############################

    # Finder: show status bar
    defaults write com.apple.finder ShowStatusBar -bool true

    # Finder: show path bar
    defaults write com.apple.finder ShowPathbar -bool true

    # Finder: allow text selection in Quick Look
    defaults write com.apple.finder QLEnableTextSelection -bool true

    # Keep folders on top when sorting by name
    defaults write com.apple.finder _FXSortFoldersFirst -bool true

    # When performing a search, search the current folder by default
    defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

    # Always open everything in Finder's list view.
    # Use list view in all Finder windows by default
    # Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
    defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

    ############################
    # Dock
    ############################

    # Dock Size
    defaults write com.apple.dock tilesize -int 70

    # hot corner bottom right opens screensaver
    defaults write com.apple.dock wvous-br-corner -int 5

    # Don't show recently used applications in the Dock
    defaults write com.Apple.Dock show-recents -bool false

    ############################
    # Calendar
    ############################

    # Show week numbers (10.8 only)
    defaults write com.apple.iCal "Show Week Numbers" -bool true

    # Week starts on monday
    defaults write com.apple.iCal "first day of week" -int 1

    # @todo open in $HOME by default ~/Library/Preferences/com.apple.finder.plist NewWindowTargetPath

    # @todo configure VLC possible? ~/Library/Preferences/org.videolan.vlc/vlcrc

    # ----------------------
    title_h2 "Keyboard shortcuts"

    local cmd="@"
    local shift="\$"
    local ctrl="^"
    local optn="~"

    defaults write -g NSUserKeyEquivalents -dict-add 'Move Window to Left Side of Screen' "${cmd}${optn}${ctrl}${shift}\UF702"
    defaults write -g NSUserKeyEquivalents -dict-add 'Move Window to Right Side of Screen' "${cmd}${optn}${ctrl}${shift}\UF703"
    defaults write -g NSUserKeyEquivalents -dict-add 'Lock Screen' "${cmd}${shift}L"
    status "Shortcuts added" OK

    # ----------------------
    title_h2 "Keyboard replacements"

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

    # ----------------------
    title_h2 "Machine Name"

    setup_machine_name

    # @todo configure dock order items and position with https://github.com/kcrawford/dockutil

    # ----------------------
    # title_h2 "Application Icons"
    # @todo does not seem to work on OSX Ventura :(
    # replace_app_icon kitty.app kitty.icns "assets/app_icons/kitty.icns"
    # replace_app_icon iTerm.app AppIcon.icns "assets/app_icons/iTerm2.icns"
    # VLC: also had to overwrite the VLC.icns manually inside the folder

    # @todo set default applications
    # -------
    # https://github.com/fharper/macsetup/blob/main/macsetup.sh#L4299

    # ----------------------
    title_h2 "Set default applications"
    duti -v "$DOTFILES_ROOT/setup/duti"

  fi
}
