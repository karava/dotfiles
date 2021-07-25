#!/usr/bin/env bash
## See documentation and reference here:
## https://blog.sapegin.me/all/show-gui-dialog-from-shell/

# error "Message"
function error() {
  osascript <<EOT
    tell app "System Events"
      display dialog "$1" buttons {"OK"} default button 1 with icon caution with title "$(basename $0)"
      return  -- Suppress result
    end tell
EOT
}

# error "Not enough cheese!"
error "$1"
