#!/bin/bash

# A Pomodoro timer for the macOS terminal.

set -e

if test -z "$1"
then
    echo "Usage: $( basename $0 ) <duration in minutes>" >&2
    exit 1
fi

minutes=$1

echo "Starting a Pomodoro timer of $minutes minutes."

i=0
while test $i -lt $minutes
do
    sleep 60
    i=$(( $i + 1))
    echo $i minutes elapsed
done

echo "Hey Pomodoro, time's up!"
say "hey pomodoro, times up, you have a minute left"
sleep 60
osascript -e 'quit app "Safari"'

