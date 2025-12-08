#!/usr/bin/env bash

# Usage: ./scan_unpushed.sh /path/to/folder
# Default: current directory

root="${1:-.}"

echo "Scanning for git repos with unpushed commits in: $root"
echo

find "$root" -type d -name ".git" | while read gitdir; do
    repo_dir="$(dirname "$gitdir")"
    cd "$repo_dir" || continue

    # Skip repos with no remotes
    if ! git remote >/dev/null 2>&1; then
        continue
    fi

    # Get list of unpushed commits
    unpushed=$(git log --branches --not --remotes --oneline)

    if [ -n "$unpushed" ]; then
        echo "====== $repo_dir ======"
        echo "$unpushed"
        echo
    fi
done

echo "Scan complete."
