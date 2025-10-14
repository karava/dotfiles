#!/bin/bash

# A Pomodoro timer for the macOS terminal.
# Usage: ./pomo.sh <duration in minutes> [--music] [--task "task description"]

set -e

if test -z "$1"
then
    echo "Usage: $( basename $0 ) <duration in minutes> [--music] [--task \"task description\"]" >&2
    exit 1
fi

minutes=$1
shift

# Check for the --music flag
play_music=false
task_str=""

if [ "$1" == "--music" ]; then
    ~/bin/cans.sh
    play_music=true
    shift
    if [ -n "$1" ] && [[ ! "$1" =~ ^-- ]]; then
        music_type="$1"
        shift
    fi
fi

if [ "$1" == "--task" ]; then
    shift
    if [ -z "$1" ]; then
        echo "Error: --task flag requires a string argument." >&2
        exit 1
    fi
    task_str="$1"
fi

# Define the stop_music function
stop_music() {
    echo "Stopping music..."
    osascript -e 'tell application "Music" to pause'
}

echo "Starting a Pomodoro timer of $minutes minutes."

# If music flag is set, start playing work music.
if $play_music; then
    if [ "$music_type" = "reading" ]; then
        echo "Starting reading music..."
        osascript -e 'tell application "Music" to play playlist "Reading"'
    else
        echo "Starting work music..."
        osascript -e 'tell application "Music" to play playlist "Work Music"'
    fi
fi

early_completion=false
i=0
while test $i -lt $minutes
do
    read -t 60 -n 1 -p "Press 'c' to mark task completed early, or 'q' to quit: " input || true
    echo # newline after the prompt
    if [ "$input" == "c" ]; then
        early_completion=true
        remaining=$((minutes - i))
        echo "Task completed $remaining minutes early!"
        break
    elif [ "$input" == "q" ]; then
        echo "Exiting..."
        stop_music
        exit 0
    fi
    i=$(( $i + 1))
    echo $i minutes elapsed
done

elapsed_minutes=$i

# If music flag is set, stop the music at the end.
if $play_music; then
    stop_music
fi

if [ -n "$task_str" ]; then
    echo "Recording task: $task_str ($elapsed_minutes minutes spent)"
    jrnl timesheet "$task_str ($elapsed_minutes minutes spent)"
fi

# Only run closing flow if the timer wasn't stopped early.
if [ "$early_completion" == false ]; then
    echo "Hey Kish, time's up!"
    say "hey Kish, times up, you have a minute left"
    sleep 50
    ~/bin/macAlerts.sh 'closing in 10seconds'
    sleep 10 
    osascript -e 'quit app "Safari"'
    osascript -e 'quit app "Arc"'
    osascript -e 'quit app "Notion"'
fi
