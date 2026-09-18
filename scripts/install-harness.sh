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

# Determine templates root
HARNESS_ROOT=""
if [[ -d "$TARGET_PATH/templates" ]]; then
  HARNESS_ROOT="$TARGET_PATH/templates"
elif [[ -d "templates" ]]; then
  HARNESS_ROOT="templates"
fi

# 1. Scaffold .project/ directory & feature templates
echo "Checking project specification directory (.project/)..."
mkdir -p .project/features
if [[ -n "$HARNESS_ROOT" && -d "$HARNESS_ROOT/project-spec" ]]; then
  cp -n "$HARNESS_ROOT/project-spec/"*.md .project/ 2>/dev/null || true
  cp -n "$HARNESS_ROOT/project-spec/features/"*.md .project/features/ 2>/dev/null || true
  echo "Scaffolded default templates into .project/ from harness."
fi

# 2. Scaffold host repository AGENTS.md (living rules for future agent runs)
if [[ ! -f "AGENTS.md" && -n "$HARNESS_ROOT" && -f "$HARNESS_ROOT/project-root/AGENTS.md" ]]; then
  echo "Scaffolding host repository AGENTS.md..."
  cp "$HARNESS_ROOT/project-root/AGENTS.md" AGENTS.md
fi

# 3. Scaffold GitHub PR template and CI/CD workflows
mkdir -p .github/workflows
if [[ -n "$HARNESS_ROOT" ]]; then
  if [[ -f "$HARNESS_ROOT/github/pull_request_template.md" && ! -f ".github/pull_request_template.md" ]]; then
    echo "Scaffolding .github/pull_request_template.md..."
    cp "$HARNESS_ROOT/github/pull_request_template.md" .github/pull_request_template.md
  fi
  if [[ -d "$HARNESS_ROOT/github-actions" && ! -f ".github/workflows/ci.yml" ]]; then
    echo "Scaffolding GitHub Actions CI pipelines..."
    cp "$HARNESS_ROOT/github-actions/"*.yml .github/workflows/
  fi
fi

# 4. Verify .gitignore contains .worktrees/
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
