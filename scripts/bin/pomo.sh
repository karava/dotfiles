#!/bin/bash

# A Pomodoro timer for the macOS terminal.
# Usage: ./pomo.sh <duration in minutes> [--music]

set -e

if test -z "$1"
then
    echo "Usage: $( basename $0 ) <duration in minutes> [--music]" >&2
    exit 1
fi

minutes=$1
shift

# Check for the --music flag
play_music=false
if [ "$1" == "--music" ]; then
    play_music=true
fi

echo "Starting a Pomodoro timer of $minutes minutes."

# If music flag is set, start palying work music.
if $play_music; then
    echo "Starting work music..."
    osascript -e 'tell application "Music" to play playlist "Work Music"'
fi

i=0
while test $i -lt $minutes
do
    sleep 60
    i=$(( $i + 1))
    echo $i minutes elapsed
done

# If music flag is set, stop the music at the end.
if $play_music; then
    echo "Stopping work music..."
    osascript -e 'tell application "Music" to pause'
fi

echo "Hey Kish, time's up!"
say "hey Kish, times up, you have a minute left"

sleep 50
~/bin/macAlerts.sh 'closing in 10seconds'
sleep 10 
osascript -e 'quit app "Safari"'
osascript -e 'quit app "Arc"' 
