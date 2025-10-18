#!/usr/bin/env zsh

# Weekly Pomodoro Deep Work Report
# Analyzes your deep work sessions from jrnl and pomo_log

# set -e  # Commented out to allow script to continue on errors

# Colors for better readability
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Function to format minutes to hours and minutes
format_time() {
    local mins=$1
    if [ "$mins" -ge 60 ]; then
        printf "%dh %dm" $((mins/60)) $((mins%60))
    else
        printf "%dm" "$mins"
    fi
}

# Function to get week dates
get_week_dates() {
    if [ "$1" = "last" ]; then
        start_date=$(date -v-monday -v-1w +'%Y-%m-%d')
        end_date=$(date -v-sunday -v-1w +'%Y-%m-%d')
        week_label="Last Week"
        week_dates="$(date -v-monday -v-1w +'%b %d') - $(date -v-sunday -v-1w +'%b %d, %Y')"
    else
        start_date=$(date -v-monday +'%Y-%m-%d')
        end_date=$(date +'%Y-%m-%d')
        week_label="This Week"
        week_dates="$(date -v-monday +'%b %d') - $(date +'%b %d, %Y')"
    fi
}

# Parse arguments
week_arg="${1:-this}"
get_week_dates "$week_arg"

clear
echo ""
echo -e "${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}           ${BOLD}📊 DEEP WORK WEEKLY REPORT${NC}                         ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}           ${week_dates}                           ${CYAN}║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Overall Statistics from pomo_log
echo -e "${GREEN}${BOLD}📈 OVERVIEW${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Calculate total minutes for the week
total_mins=0
session_count=0
typeset -A daily_mins
typeset -A daily_sessions

# Process each day
for i in {0..6}; do
    if [ "$week_arg" = "last" ]; then
        check_date=$(date -v-monday -v-1w -v+"$i"d +'%Y-%m-%d')
    else
        check_date=$(date -v-monday -v+"$i"d +'%Y-%m-%d')
    fi

    [[ "$check_date" > "$end_date" ]] && break

    day_data=$(grep "^$check_date" ~/.pomo_log 2>/dev/null || true)
    if [ -n "$day_data" ]; then
        mins=$(echo "$day_data" | sed -E 's/.*\(([0-9]+) min\).*/\1/' | awk '{sum+=$1} END {print sum+0}')
        sessions=$(echo "$day_data" | wc -l | tr -d ' ')

        daily_mins["$check_date"]=$mins
        daily_sessions["$check_date"]=$sessions
        total_mins=$((total_mins + mins))
        session_count=$((session_count + sessions))
    else
        daily_mins["$check_date"]=0
        daily_sessions["$check_date"]=0
    fi
done

# Display overview stats
printf "  Total Deep Work: ${YELLOW}%s${NC} across ${YELLOW}%d sessions${NC}\n" "$(format_time $total_mins)" "$session_count"

if [ $session_count -gt 0 ]; then
    avg_session=$((total_mins / session_count))
    printf "  Average Session: ${YELLOW}%s${NC}\n" "$(format_time $avg_session)"
fi

# Days with work
days_with_work=0
for key in ${(k)daily_mins}; do
    [ "${daily_mins[$key]}" -gt 0 ] && ((days_with_work++))
done
printf "  Active Days: ${YELLOW}%d/7${NC}\n" "$days_with_work"

if [ $days_with_work -gt 0 ]; then
    daily_avg=$((total_mins / days_with_work))
    printf "  Daily Average (active days): ${YELLOW}%s${NC}\n" "$(format_time $daily_avg)"
fi

echo ""

# Daily Breakdown with visual bar chart
echo -e "${BLUE}${BOLD}📅 DAILY BREAKDOWN${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Find max minutes for scaling
max_mins=0
for key in ${(k)daily_mins}; do
    [ "${daily_mins[$key]}" -gt "$max_mins" ] && max_mins="${daily_mins[$key]}"
done

# Display each day
for i in {0..6}; do
    if [ "$week_arg" = "last" ]; then
        check_date=$(date -v-monday -v-1w -v+"$i"d +'%Y-%m-%d')
    else
        check_date=$(date -v-monday -v+"$i"d +'%Y-%m-%d')
    fi

    [[ "$check_date" > "$end_date" ]] && break

    day_name=$(date -jf '%Y-%m-%d' "$check_date" +'%a')
    day_display=$(date -jf '%Y-%m-%d' "$check_date" +'%m/%d')
    mins=${daily_mins["$check_date"]}
    sessions=${daily_sessions["$check_date"]}

    # Create visual bar
    if [ "$max_mins" -gt 0 ] && [ "$mins" -gt 0 ]; then
        bar_length=$((mins * 30 / max_mins))
        [ "$bar_length" -eq 0 ] && bar_length=1
    else
        bar_length=0
    fi

    printf "  ${BOLD}%-4s${NC} %s  " "$day_name" "$day_display"

    # Print the bar
    if [ "$bar_length" -gt 0 ]; then
        printf "${GREEN}"
        for ((j=1; j<=bar_length; j++)); do printf "█"; done
        printf "${NC}"
    fi

    # Print stats
    if [ "$mins" -gt 0 ]; then
        printf " %s (%d sessions)\n" "$(format_time $mins)" "$sessions"
    else
        printf " ${RED}No work logged${NC}\n"
    fi
done

echo ""

# Project Breakdown from jrnl
echo -e "${PURPLE}${BOLD}🎯 PROJECT FOCUS${NC}"
echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Get all project tags and their times
typeset -A project_times
typeset -A project_counts

# Get entries from jrnl for the time period
if [ "$week_arg" = "last" ]; then
    entries=$(jrnl timesheet -from "$start_date" -to "$end_date" 2>/dev/null || echo "")
else
    entries=$(jrnl timesheet -from "$start_date" 2>/dev/null || echo "")
fi

if [ -n "$entries" ]; then
    # Extract projects and times
    while IFS= read -r line; do
        # Look for entries with brackets (projects)
        if [[ "$line" =~ \[([^\]]+)\].*\(([0-9]+)\ minutes\ spent\) ]]; then
            project="${BASH_REMATCH[1]}"
            minutes="${BASH_REMATCH[2]}"

            # Add to project totals
            if [ -n "${project_times[$project]}" ]; then
                project_times[$project]=$((project_times[$project] + minutes))
                project_counts[$project]=$((project_counts[$project] + 1))
            else
                project_times[$project]=$minutes
                project_counts[$project]=1
            fi
        fi
    done <<< "$entries"

    # Sort projects by time and display
    if [ ${#project_times[@]} -gt 0 ]; then
        for project in $(for p in "${!project_times[@]}"; do echo "${project_times[$p]}:$p"; done | sort -rn | head -5 | cut -d: -f2-); do
            mins=${project_times[$project]}
            count=${project_counts[$project]}
            percentage=$((mins * 100 / total_mins))

            printf "  ${BOLD}[%-10s]${NC} " "$project"
            printf "%s " "$(format_time $mins)"
            printf "(${CYAN}%d sessions, %d%%${NC})\n" "$count" "$percentage"
        done
    else
        echo "  No tagged projects found"
    fi
else
    echo "  No project data available"
fi

echo ""

# Top Tasks
echo -e "${YELLOW}${BOLD}💪 TOP DEEP WORK SESSIONS${NC}"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Get top 5 longest sessions
if [ -n "$entries" ]; then
    echo "$entries" | grep -E '\([0-9]+ minutes spent\)' | \
        grep -v '(0 minutes spent)' | \
        sort -t'(' -k2 -rn | head -5 | \
        while IFS= read -r line; do
            # Extract date, task, and time
            if [[ "$line" =~ ^([0-9]{4}-[0-9]{2}-[0-9]{2}\ [0-9]{2}:[0-9]{2})\ (.+)\ \(([0-9]+)\ minutes\ spent\) ]]; then
                date="${BASH_REMATCH[1]}"
                task="${BASH_REMATCH[2]}"
                mins="${BASH_REMATCH[3]}"

                # Format date for display
                display_date=$(date -jf '%Y-%m-%d %H:%M' "$date" +'%m/%d %I:%M%p' 2>/dev/null || echo "$date")

                printf "  • ${BOLD}%s${NC} - %s\n" "$(format_time $mins)" "$task"
                printf "    ${CYAN}%s${NC}\n" "$display_date"
            fi
        done
else
    echo "  No session data available"
fi

echo ""

# Insights and Goals
echo -e "${PURPLE}${BOLD}🎯 INSIGHTS & GOALS${NC}"
echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Weekly goal (8 hours = 480 minutes default)
goal_mins=480
if [ $total_mins -gt 0 ]; then
    progress=$((total_mins * 100 / goal_mins))

    printf "  Goal Progress: "
    if [ $progress -ge 100 ]; then
        printf "${GREEN}✓ %d%% of %s weekly goal${NC}\n" "$progress" "$(format_time $goal_mins)"
        echo -e "  ${GREEN}🎉 Great job! You met your weekly goal!${NC}"
    elif [ $progress -ge 75 ]; then
        printf "${YELLOW}%d%% of %s weekly goal${NC}\n" "$progress" "$(format_time $goal_mins)"
        echo -e "  ${YELLOW}📈 Almost there! Just $(format_time $((goal_mins - total_mins))) more to reach your goal${NC}"
    else
        printf "${RED}%d%% of %s weekly goal${NC}\n" "$progress" "$(format_time $goal_mins)"
        echo -e "  ${RED}💪 Keep pushing! $(format_time $((goal_mins - total_mins))) more to reach your goal${NC}"
    fi
fi

# Most productive day
most_productive_day=""
most_productive_mins=0
for date in ${(k)daily_mins}; do
    if [ "${daily_mins[$date]}" -gt "$most_productive_mins" ]; then
        most_productive_mins="${daily_mins[$date]}"
        most_productive_day="$date"
    fi
done

if [ -n "$most_productive_day" ] && [ "$most_productive_mins" -gt 0 ]; then
    day_name=$(date -jf '%Y-%m-%d' "$most_productive_day" +'%A')
    echo ""
    printf "  Most Productive: ${BOLD}%s${NC} with %s\n" "$day_name" "$(format_time $most_productive_mins)"
fi

# Streak analysis
current_streak=0
max_streak=0
temp_streak=0
for i in {6..0}; do
    if [ "$week_arg" = "last" ]; then
        check_date=$(date -v-monday -v-1w -v+"$i"d +'%Y-%m-%d')
    else
        check_date=$(date -v-monday -v+"$i"d +'%Y-%m-%d')
    fi

    [[ "$check_date" > "$end_date" ]] && break

    if [ "${daily_mins[$check_date]}" -gt 0 ]; then
        ((temp_streak++))
        [ "$check_date" = "$end_date" ] && current_streak=$temp_streak
    else
        [ "$temp_streak" -gt "$max_streak" ] && max_streak=$temp_streak
        temp_streak=0
    fi
done
[ "$temp_streak" -gt "$max_streak" ] && max_streak=$temp_streak

if [ "$max_streak" -gt 0 ]; then
    printf "  Longest Streak: ${BOLD}%d consecutive days${NC}\n" "$max_streak"
fi

echo ""
echo -e "${CYAN}────────────────────────────────────────────────────────────────${NC}"
echo ""

# Quick commands reminder
echo -e "${BOLD}📝 Quick Commands:${NC}"
echo "  View today's entries:   jrnl timesheet -today"
echo "  View all week entries:  jrnl timesheet -from '$start_date'"
echo "  Start work session:     pomo.sh work"
echo "  Start break:           pomo.sh break"
echo ""