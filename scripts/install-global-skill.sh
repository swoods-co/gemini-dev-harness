#!/usr/bin/env bash
# One-Line Installer for Antigravity Global Bootstrap Skill (POSIX / macOS / Linux)
# Installs the 'init-frontend-harness' skill globally into ~/.gemini/config/skills/
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/swoods-co/gemini-dev-harness/main/scripts/install-global-skill.sh | bash

set -euo pipefail

echo "Installing Antigravity Global Bootstrap Skill..."

TARGET_DIR="$HOME/.gemini/config/skills/init-frontend-harness"
mkdir -p "$TARGET_DIR"

SKILL_URL="https://raw.githubusercontent.com/swoods-co/gemini-dev-harness/main/skills/init-frontend-harness/SKILL.md"
TARGET_FILE="$TARGET_DIR/SKILL.md"

if command -v curl >/dev/null 2>&1; then
  curl -fsSL "$SKILL_URL" -o "$TARGET_FILE"
elif command -v wget >/dev/null 2>&1; then
  wget -qO "$TARGET_FILE" "$SKILL_URL"
else
  echo "Error: curl or wget is required to download the skill."
  exit 1
fi

echo "Success! 'init-frontend-harness' skill installed globally at:"
echo "  $TARGET_FILE"
echo ""
echo "You can now open ANY empty folder in Antigravity and simply prompt:"
echo "  'Set up this project with my frontend harness'"
