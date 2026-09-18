#!/usr/bin/env bash
# Universal Frontend Development Harness — Project Installer (POSIX)
# Usage: ./install-harness.sh [options]
#   Options:
#     --submodule-url <url>   Remote Git URL for this harness repository
#     --path <dir>            Submodule target directory (default: .agents/plugins/frontend-harness)

set -euo pipefail

SUBMODULE_URL="${1:-}"
TARGET_PATH=".agents/plugins/frontend-harness"

echo "============================================================"
echo " Universal Frontend Development Harness Installer"
echo "============================================================"

# Ensure we are inside a git repository
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Error: Must be run from within the root of a Git repository."
  exit 1
fi

REPO_ROOT=$(git rev-parse --show-toplevel)
cd "$REPO_ROOT"

# Check if submodule URL is provided or if harness is already linked
if [[ -n "$SUBMODULE_URL" ]]; then
  echo "Adding harness as git submodule at $TARGET_PATH..."
  mkdir -p .agents/plugins
  if [[ ! -d "$TARGET_PATH" ]]; then
    git submodule add "$SUBMODULE_URL" "$TARGET_PATH"
    git submodule update --init --recursive
  else
    echo "Submodule directory $TARGET_PATH already exists. Updating..."
    git submodule update --remote "$TARGET_PATH"
  fi
fi

# Scaffold .project/ directory if not present
echo "Checking project specification directory (.project/)..."
if [[ ! -d ".project" ]]; then
  echo "Creating .project/ directory..."
  mkdir -p .project

  if [[ -d "$TARGET_PATH/templates/project-spec" ]]; then
    cp "$TARGET_PATH/templates/project-spec/"*.md .project/
    echo "Scaffolded default templates into .project/ from harness."
  elif [[ -d "templates/project-spec" ]]; then
    cp templates/project-spec/*.md .project/
    echo "Scaffolded default templates into .project/ from local templates."
  fi
else
  echo ".project/ directory already exists."
fi

# Verify .gitignore contains .worktrees/
if ! grep -q ".worktrees/" .gitignore 2>/dev/null; then
  echo "Adding .worktrees/ to .gitignore..."
  echo -e "\n# Isolated Git Worktrees\n.worktrees/" >> .gitignore
fi

echo "============================================================"
echo " Harness installation and project contract setup complete!"
echo " Next steps:"
echo " 1. Open Antigravity in this project."
echo " 2. Run agent with 'project-scoping' to finalize .project/SCOPE.md"
echo "============================================================"
