#!/bin/bash

# A Pomodoro timer for the macOS terminal.
# Usage: ./pomo.sh <duration|preset> [--music [type]] [--task "task description"] [--sound "custom message"]
# Presets: work (25 min), break (5 min), long (15 min)

set -e

if test -z "$1"
then
    echo "Usage: $( basename $0 ) <minutes|preset> [--music [type]] [--task \"description\"] [--sound \"message\"]" >&2
    echo "Presets: work (25 min), break (5 min), long (15 min)" >&2
    exit 1
fi

# Handle presets or custom duration
case "$1" in
    work) minutes=25 ;;
    break) minutes=5 ;;
    long) minutes=15 ;;
    *)
        # Validate that input is a positive integer
        if ! [[ "$1" =~ ^[0-9]+$ ]] || [ "$1" -eq 0 ]; then
            echo "Error: Duration must be a positive integer (minutes)" >&2
            exit 1
        fi
        minutes=$1
        ;;
esac
shift

# Initialize variables
play_music=false
music_type=""
task_str=""
alert_sound=""

# Parse arguments flexibly
while [[ $# -gt 0 ]]; do
    case $1 in
        --music)
            # Try to run cans.sh if it exists
            if [ -f ~/bin/cans.sh ]; then
                ~/bin/cans.sh
            else
                echo "Warning: ~/bin/cans.sh not found, skipping headphone setup" >&2
            fi
            play_music=true
            shift
            if [[ -n "$1" && ! "$1" =~ ^-- ]]; then
                music_type="$1"
                shift
            fi
            ;;
        --task)
            shift
            if [[ -z "$1" ]]; then
                echo "Error: --task requires a task description." >&2
                exit 1
            fi
            task_str="$1"
            shift
            ;;
        --sound)
            shift
            if [[ -z "$1" ]]; then
                echo "Error: --sound requires a message." >&2
                exit 1
            fi
            alert_sound="$1"
            shift
            ;;
        *)
            echo "Unknown option: $1" >&2
            shift
            ;;
    esac
done

# Define the stop_music function
stop_music() {
    echo "Stopping music..."
    osascript -e 'tell application "Music" to pause'
}

# Define the notify function for macOS notifications
notify() {
    local message="$1"
    local title="${2:-Pomodoro Timer}"
    osascript -e "display notification \"$message\" with title \"$title\" sound name \"Glass\""
}

# Define the progress_bar function
progress_bar() {
    local current_seconds=$1
    local total_seconds=$2
    local width=30

    # Avoid division by zero
    if [ "$total_seconds" -eq 0 ]; then
        return
    fi

    local percent=$((current_seconds * 100 / total_seconds))
    local filled=$((current_seconds * width / total_seconds))
    local remaining_seconds=$((total_seconds - current_seconds))

    # Format time as MM:SS
    local current_mm=$((current_seconds / 60))
    local current_ss=$((current_seconds % 60))
    local total_mm=$((total_seconds / 60))
    local total_ss=$((total_seconds % 60))
    local remaining_mm=$((remaining_seconds / 60))
    local remaining_ss=$((remaining_seconds % 60))

    printf "\r⏱️  ["
    printf "%${filled}s" | tr ' ' '█'
    printf "%$((width - filled))s" | tr ' ' '░'
    printf "] %3d%% " $percent
    printf "%02d:%02d / %02d:%02d " $current_mm $current_ss $total_mm $total_ss
    printf "(-%02d:%02d)" $remaining_mm $remaining_ss
}

echo "Starting a Pomodoro timer of $minutes minutes."
notify "Starting $minutes minute timer" "🍅 Pomodoro"

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
total_seconds=$((minutes * 60))
elapsed_seconds=0

while test $elapsed_seconds -lt $total_seconds
do
    progress_bar $elapsed_seconds $total_seconds
    read -t 1 -n 1 -p " Press 'c' to complete, 'q' to quit: " input || true
    if [ "$input" == "c" ]; then
        early_completion=true
        remaining_minutes=$(((total_seconds - elapsed_seconds) / 60))
        echo ""  # newline after progress bar
        echo "Task completed $remaining_minutes minutes early!"
        notify "Task completed $remaining_minutes minutes early! 🎉" "Pomodoro Complete"
        break
    elif [ "$input" == "q" ]; then
        echo ""  # newline after progress bar
        echo "Exiting..."
        stop_music
        exit 0
    fi
    elapsed_seconds=$(( elapsed_seconds + 1))
done

# Show final progress
progress_bar $elapsed_seconds $total_seconds
echo ""  # newline after final progress bar

elapsed_minutes=$((elapsed_seconds / 60))

# If music flag is set, stop the music at the end.
if $play_music; then
    stop_music
fi

if [ -n "$task_str" ]; then
    echo "Recording task: $task_str ($elapsed_minutes minutes spent)"
    jrnl timesheet "$task_str ($elapsed_minutes minutes spent)"
fi

# Log session to statistics file
log_file="$HOME/.pomo_log"
timestamp="$(date '+%Y-%m-%d %H:%M')"
if [ -n "$task_str" ]; then
    echo "$timestamp: $task_str ($elapsed_minutes min)" >> "$log_file"
else
    echo "$timestamp: Pomodoro session ($elapsed_minutes min)" >> "$log_file"
fi

# Show daily statistics
today_count=$(grep "^$(date '+%Y-%m-%d')" "$log_file" 2>/dev/null | wc -l | tr -d ' ')
today_minutes=$(grep "^$(date '+%Y-%m-%d')" "$log_file" 2>/dev/null | sed -E 's/.*\(([0-9]+) min\).*/\1/' | awk '{sum+=$1} END {print sum+0}')
echo ""
echo "📊 Today's Stats: $today_count sessions, $today_minutes minutes total"

# Only run closing flow if the timer wasn't stopped early.
if [ "$early_completion" == false ]; then
    echo "Hey Kish, time's up!"
    notify "Timer complete! Take a break 🍅" "Pomodoro Finished"
    say "${alert_sound:-hey Kish, times up, take a break}"
    echo ""
    echo "🍅 Remember to take a break and stretch!"
fi
