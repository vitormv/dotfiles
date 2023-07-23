#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

function check_mouse_battery() {
  local battery_level

  # current battery level
  battery_level=$(ioreg -c AppleDeviceManagementHIDEventService -r -l | grep -i mouse -A 20 | grep BatteryPercent | cut -d= -f2 | cut -d' ' -f2)

  # defaults to warn at 20%; accepts other number as 1st argument (useful for testing)
  local alert_threshold=${1:-20}

  if [ -z "$battery_level" ]; then
    echo 'No mouse found.'
    exit 0
  fi

  if ((battery_level < alert_threshold)); then
    osascript -e "display notification \"Mouse battery is at ${battery_level}%.\" with title \"Mouse Battery Low\""
  fi
}

check_mouse_battery "$@"
