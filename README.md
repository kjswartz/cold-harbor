# cold-harbor

Utility scripts and small experiments (shell + JavaScript) collected for day‑to‑day workflow on macOS.

## Contents

```
shell/
	chrome_history.sh      # Fuzzy search & open recent Chrome history entries
	countdown.sh           # Simple terminal countdown timer with alert
	current_time.sh        # Show US time zones (EST..PST) + date
	gh-helpful-scripts.sh  # Helpers for working with GitHub issues via gh CLI
	simple-encrypt.sh      # Minimal AES-256-CBC file encrypt/decrypt helper
	todo.sh                # SQLite-backed personal TODO list CLI
js/
	regex_testing.js       # Mini test harness + sample regex experiments
```

## Prerequisites

Most scripts assume macOS.

Common tools you may need (install with Homebrew if missing):

* `brew install sqlite fzf jq gh node`
* Logged into GitHub CLI: `gh auth login`

## shell Scripts

### `chrome_history.sh`
Fuzzy-find a recent Chrome history entry and open it.

Dependencies: Chrome, `sqlite3`, `fzf`.

Usage:
```bash
./shell/chrome_history.sh
```
Notes: Copies the locked History DB to a temp file first, shows a fuzzy list (title | url). Press Enter to open in Chrome.

### `countdown.sh`
Terminal countdown (default 20 minutes) with sound + dialog when finished.

Usage:
```bash
./shell/countdown.sh            # 20 minutes
./shell/countdown.sh 5          # 5 minutes
```
Relies on AppleScript (`osascript`) for beep + dialog.

### `current_time.sh`
Quick multi‑timezone (US) time snapshot + date.

Usage:
```bash
./shell/current_time.sh
```

### `gh-helpful-scripts.sh`
Helpers around GitHub issues using the GitHub CLI + GraphQL.

Dependencies: `gh`, `jq`.

Subcommands:
```bash
./shell/gh-helpful-scripts.sh copy <issue_number> <source_owner/repo> <target_owner/repo> [labels...]
./shell/gh-helpful-scripts.sh getRepoId <owner> <repo_name>
```
Examples:
```bash
./shell/gh-helpful-scripts.sh copy 123 myorg/old-repo myorg/new-repo bug backlog
./shell/gh-helpful-scripts.sh getRepoId myorg cool-repo
```
The copy command strips `@` mentions from the body to avoid accidental notifications.

### `simple-encrypt.sh`
Lightweight wrapper for OpenSSL AES‑256‑CBC with PBKDF2 (100k iterations). Destroys original file on successful encrypt/decrypt to minimize leftovers.

Usage:
```bash
./shell/simple-encrypt.sh lock secret.txt      # Produces secret.txt.enc and deletes secret.txt
./shell/simple-encrypt.sh open secret.txt.enc  # Restores secret.txt and deletes secret.txt.enc
```
Security notes:
* Interactive password prompt (no echo)
* No password confirmation (double‑check typing)
* Consider using more robust tools (age, gpg) for stronger workflows

### `todo.sh`
Tiny SQLite TODO manager.

DB path: `~/.scripts/db/todo.db` (auto‑created).

Commands:
```bash
add "Task description"           # Insert new pending task
edit <id> "New description"      # Update task text
update <id> <pending|completed>  # Explicitly change status
done <id>                        # Shortcut: mark completed
delete <id>                      # Remove task
list [-a]                        # List pending (default) or all with -a
```
Examples:
```bash
./shell/todo.sh add "Buy groceries"
./shell/todo.sh list
./shell/todo.sh done 3
./shell/todo.sh list -a
```
Limitations: No concurrency protection; single‑user local use assumed.

## JavaScript

### `regex_testing.js`
Simple harness for iterating over regex test cases + replacement validations.

Run (Node 18+ recommended):
```bash
node js/regex_testing.js
```
Structure:
* `testRegexFunction(regex, cases)` – boolean match tests
* `testFunction(name, cases)` – generic try/catch wrapper
Currently focuses on a regex that captures lines with a book emoji + Docs marker for potential replacement.

## Suggested Aliases (optional)
Add to `~/.zshrc` for convenience:
```bash
alias td="$PWD/shell/todo.sh"
alias cdt="$PWD/shell/countdown.sh"
alias cht="$PWD/shell/current_time.sh"
```

## Safety & Disclaimer
These scripts are intentionally lightweight and opinionated for personal use. Review code before running, especially anything that deletes or rewrites files (e.g., `simple-encrypt.sh`).

## Future Ideas
* Add tests for shell scripts (bats or shellspec)
* Extend `todo.sh` with search or tags
* Package JS regex harness as a tiny npm script

## License
Unlicensed / personal toolbox. Add a formal license if redistribution becomes relevant.
