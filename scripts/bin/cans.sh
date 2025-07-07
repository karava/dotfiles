#!/bin/zsh
MAC="40:72:18:2F:1F:4C"
NAME="WH-CH720N"

# Re-establish the Bluetooth link if needed
if [[ $(blueutil --is-connected "$MAC") == 0 ]]; then
  echo "🔄 reconnecting to $NAME ..."
  blueutil --connect "$MAC"
  sleep 2   # give the radio a moment
fi

# Route audio
switchaudiosource -s "$NAME"
echo "✅ audio routed to $NAME"
sleep 2
say "Audio routed to Sony cans"
