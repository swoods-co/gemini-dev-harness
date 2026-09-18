#!/usr/bin/env bash
# Git Worktree Helper Script (POSIX)
set -euo pipefail

ACTION="${1:-}"
BRANCH="${2:-}"

if [[ -z "$ACTION" ]]; then
  echo "Usage: $0 <create|remove|list|prune> [branch-name]"
  exit 1
fi

sanitize_name() {
  echo "$1" | sed -e 's/[^a-zA-Z0-9._-]/-/g'
}

case "$ACTION" in
  create)
    if [[ -z "$BRANCH" ]]; then
      echo "Error: Branch name required for create."
      exit 1
    fi
    DIR_NAME=$(sanitize_name "$BRANCH")
    TARGET_PATH=".worktrees/$DIR_NAME"

    echo "Creating worktree at $TARGET_PATH for branch $BRANCH..."
    mkdir -p .worktrees
    git worktree add "$TARGET_PATH" -b "$BRANCH"
    echo "Worktree created successfully."
    echo "To enter worktree: cd $TARGET_PATH"
    ;;

  remove)
    if [[ -z "$BRANCH" ]]; then
      echo "Error: Branch or directory name required for remove."
      exit 1
    fi
    DIR_NAME=$(sanitize_name "$BRANCH")
    TARGET_PATH=".worktrees/$DIR_NAME"

    if [[ -d "$TARGET_PATH" ]]; then
      echo "Removing worktree at $TARGET_PATH..."
      git worktree remove "$TARGET_PATH"
      echo "Worktree removed."
    else
      echo "Target path $TARGET_PATH does not exist."
    fi
    git worktree prune
    ;;

  list)
    git worktree list
    ;;

  prune)
    git worktree prune -v
    ;;

  *)
    echo "Unknown action: $ACTION"
    echo "Available actions: create, remove, list, prune"
    exit 1
    ;;
esac
