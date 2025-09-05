#!/bin/bash
set -euo pipefail

# Script to set up a SQLite database and manage todo items
# Usage: ./todo.sh {add 'task description' | edit <id> 'new task description' | update <id> <status> | list}

DB_FILE="$HOME/.scripts/db/todo.db"

check_sqlite() {
	if ! command -v sqlite3 &> /dev/null; then
		echo "Error: SQLite3 is not installed. Please install it using 'brew install sqlite'."
		exit 1
	fi
}

init_db() {
	echo "Initializing database at $DB_FILE..."
	sqlite3 "$DB_FILE" <<EOF
CREATE TABLE IF NOT EXISTS todos (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	task TEXT NOT NULL,
	status TEXT DEFAULT 'pending',
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
EOF
	if [ $? -eq 0 ]; then
		echo "Database and table created successfully."
	else
		echo "Error creating database."
		exit 1
	fi
}

add_todo() {
    local task="$1"
    if [ -z "$task" ]; then
        echo "Error: No task provided. Usage: $0 add 'your task here'"
        exit 1
    fi
    sqlite3 "$DB_FILE" "INSERT INTO todos (task) VALUES ('$task');"
    if [ $? -eq 0 ]; then
        echo "Added todo: $task"
    else
        echo "Error adding todo."
        exit 1
    fi
}

edit_todo() {
    local id="$1"
    local new_task="$2"

    sqlite3 "$DB_FILE" "UPDATE todos SET task = '$new_task' WHERE id = $id;"
    if [ $? -eq 0 ]; then
        echo "Updated todo ID $id to: $new_task"
    else
        echo "Error updating todo."
        exit 1
    fi
}

update_status() {
	local id="$1"
	local status="$2"

	if ! [[ "$status" =~ ^(pending|completed)$ ]]; then
		echo "Error: Status must be 'pending' or 'completed'."
		exit 1
	fi

	sqlite3 "$DB_FILE" "UPDATE todos SET status = '$status' WHERE id = $id;"
	if [ $? -eq 0 ]; then
		echo "Updated todo ID $id to status: $status"
	else
		echo "Error updating todo status."
		exit 1
	fi
}

list_todos() {
	local show_all="${1}"
	local query="SELECT id, task FROM todos"

	if [[ "$show_all" != "-a" && -n "$show_all" ]]; then
		echo "Error: Invalid option '$show_all'. Use '-a' to show all todos."
		exit 1
	fi


	if [[ "$show_all" != "-a" ]]; then
		query="$query WHERE status = 'pending'"
	fi

	echo "Todo List:"
	sqlite3 "$DB_FILE" "$query;" | while IFS='|' read -r id task; do
		echo "ID: $id | $task"
	done
}

delete_todo() {
	local id="$1"
	if [ -z "$id" ]; then
		echo "Error: ID is required to delete a todo."
		exit 1
	fi
	sqlite3 "$DB_FILE" "DELETE FROM todos WHERE id = $id;"
	if [ $? -eq 0 ]; then
		echo "Deleted todo ID $id."
	else
		echo "Error deleting todo."
		exit 1
	fi
}

check_sqlite

if [ ! -f "$DB_FILE" ]; then
	init_db
fi

case "$1" in
	add)
		shift
		add_todo "$*"
		;;
	edit)
		shift
		if [ "$#" -lt 2 ]; then
			echo "Error: ID and new task description are required."
			exit 1
		fi

		if ! [[ "$1" =~ ^[0-9]+$ ]]; then
			echo "Error: ID must be a number."
			exit 1
		fi

		edit_todo "$1" "$2"
		;;
	update)
		shift
		if [ "$#" -lt 2 ]; then
			echo "Error: ID and status are required."
			exit 1
		fi

		if ! [[ "$1" =~ ^[0-9]+$ ]]; then
			echo "Error: ID must be a number."
			exit 1
		fi

		update_status "$1" "$2"
		;;
	done)
		shift
		if ! [[ "$1" =~ ^[0-9]+$ ]]; then
			echo "Error: ID must be a number."
			exit 1
		fi

		update_status "$1" "completed"
		;;
	list)
		shift
		list_todos "${1:-}"
		;;
	delete)
		shift

		if [ "$#" -lt 1 ]; then
			echo "Error: ID is required to delete a todo."
			exit 1
		fi

		if ! [[ "$1" =~ ^[0-9]+$ ]]; then
			echo "Error: ID must be a number."
			exit 1
		fi

		delete_todo "$1"
		;;
	*)
		echo "Usage: $0 {add 'task description' | edit <id> 'new task description' | update <id> <pending|completed> | delete <id> | list [-a]}"
		echo "Example: $0 add 'Buy groceries'"
		echo "Example: $0 list"
		exit 1
		;;
esac
