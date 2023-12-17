#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

################
# dockutil + App Path: does not work for the Default OSX apps, so bundle ID is needed
# find it with:
#   osascript -e 'id of app "Google Chrome"'
#     - or -
#   mdls -name kMDItemCFBundleIdentifier -r /Applications/Google\ Chrome.app

index=0

function remove-if-exists() {
  local identifier="$1"

  if dockutil --find "$identifier" >/dev/null 2>&1; then
    dockutil --no-restart --remove "$identifier"
  fi
}

function add-to-dock() {
  local app_path identifier

  app_path=$(readlink -f "$1" || echo "$1")
  identifier=${2:-$app_path}
  index=$((index + 1))

  debug "dock item ${identifier}"

  if dockutil --find "$identifier" >/dev/null 2>&1; then
    dockutil --no-restart --move "$identifier" --position $index
  else
    debug "   Adding ${app_path}"
    dockutil --no-restart --add "$app_path" --position $index
  fi
}

# remove bloat from dock
remove-if-exists "com.apple.launchpad.launcher"
remove-if-exists "com.apple.mail"
remove-if-exists "com.apple.Maps"
remove-if-exists "com.apple.Photos"
remove-if-exists "com.apple.FaceTime"
remove-if-exists "com.apple.AddressBook"
remove-if-exists "com.apple.freeform"
remove-if-exists "com.apple.TV"
remove-if-exists "com.apple.MobileSMS"

status "Removed unused apps from Dock" OK

# add the stuff I use often
add-to-dock "/Applications/Firefox.app"
add-to-dock "/Applications/Google Chrome.app"
add-to-dock "/Applications/Safari.app" "com.apple.Safari"
add-to-dock "/Applications/Visual Studio Code.app"
add-to-dock "/Applications/iTerm.app"
add-to-dock "/Applications/kitty.app"
add-to-dock "/Applications/Slack.app"
add-to-dock "/Applications/Calendar.app" "com.apple.iCal"
add-to-dock "/Applications/Notes.app" "com.apple.Notes"
add-to-dock "/Applications/Reminders.app" "com.apple.reminders"
add-to-dock "/Applications/WhatsApp.app"
add-to-dock "/Applications/Spotify.app"

status "Arranged apps in Dock" OK

# restart dock
killall Dock
