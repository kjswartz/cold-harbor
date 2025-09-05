#!/bin/bash
set -euo pipefail

# Path to Chrome's WebData file
HISTORY_PATH="$HOME/Library/Application Support/Google/Chrome/Default/History"
# Temporary copy of the History file
TEMP_HISTORY=$(mktemp)
# Copy the History file to avoid the locked error
cp "$HISTORY_PATH" "$TEMP_HISTORY"
# Temporary file to hold the extracted URLs
TEMP_FILE=$(mktemp)

sqlite3 "$TEMP_HISTORY" "SELECT title, url FROM urls ORDER BY last_visit_time DESC LIMIT 1000;" > "$TEMP_FILE"

# Use fzf to select a URL
# selected_url=$(echo "$urls" | fzf --preview 'echo {}' --preview-window=right:50%)
SELECTED_ENTRY=$(cat "$TEMP_FILE" | fzf --height 40% --reverse --ansi --exit-0)

if [ -n "$SELECTED_ENTRY" ]; then
    SELECTED_URL=$(echo "$SELECTED_ENTRY" | awk -F '\|' '{print $2}')
    # Open the selected URL in Chrome
    open -a "Google Chrome" "$SELECTED_URL"
else
    echo "No URL selected."
fi

# Clean up
rm "$TEMP_HISTORY" "$TEMP_FILE"
