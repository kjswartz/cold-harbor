#!/bin/bash

copy_issue() {
  local issue_number="$1"
  local repo="$2"
  local new_repo="$3"
  shift 3
  local labels=("$@")  # Capture all remaining arguments as labels
  
  local title=$(gh issue view "$issue_number" -R "$repo" --json title | jq -r '.title')
  local body=$(gh issue view "$issue_number" -R "$repo" --json body | jq -r '.body' | sed 's/@//g')

  local label_args=()
  for label in "${labels[@]}"; do
    label_args+=(--label "$label")
  done

  gh issue create --title "$title" --body "$body" -R "$new_repo" "${label_args[@]}"
}

getRepoId() {
  local owner="$1"
  local name="$2"
  
  gh api graphql -f query='
    query($owner: String!, $name: String!) {
      repository(owner: $owner, name: $name) {
      	databaseId
      }
    }
  ' -f owner="$owner" -f name="$name" --jq '.data.repository.databaseId'
}

case "$1" in
  copy)
    if [ "$#" -lt 3 ]; then
      echo "Usage: $0 copy <issue_number> <source_repo> <target_repo> [labels...]"
      exit 1
    fi
    shift
    copy_issue "$1" "$2" "$3" "${@:4}"
    ;;
  getRepoId)
    if [ "$#" -ne 3 ]; then
      echo "Usage: $0 getRepoId <owner> <repo_name>"
      exit 1
    fi
    shift
    getRepoId "$1" "$2"
    ;;
  *)
    echo "Usage: $0 {copy <issue_number> <source_repo> <target_repo> [labels...] | getRepoId <owner> <repo_name>}"
    exit 1
    ;;
esac
