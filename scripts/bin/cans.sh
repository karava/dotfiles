#!/bin/zsh
MAC="40:72:18:2F:1F:4C"
NAME="WH-CH720N"

# Re-establish the Bluetooth link if needed
if ! blueutil --is-connected "$MAC" >/dev/null; then
  echo "🔄 reconnecting to $NAME ..."
  blueutil --connect "$MAC"
  sleep 2   # give the radio a moment
fi

# Route audio
switchaudiosource -s "$NAME"
echo "✅ audio routed to $NAME"
say hi
