#!/usr/bin/env bash
# Start the GitHub Actions self-hosted runner inside a detached tmux session.
# Runs from a GUI login session (Login Items), so the runner and everything it
# spawns (claude, fastlane, xcodebuild) keeps login-keychain access — which a
# LaunchAgent-spawned runner does not get.
#
# Idempotent: if the session already exists, do nothing.

SESSION="gh-runner"
RUNNER_DIR="$HOME/actions-runner-10ace"

if /opt/homebrew/bin/tmux has-session -t "$SESSION" 2>/dev/null; then
  exit 0
fi

/opt/homebrew/bin/tmux new-session -d -s "$SESSION" "cd '$RUNNER_DIR' && ./run.sh"
