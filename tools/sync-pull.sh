#!/bin/bash
# sync-pull.sh — Safe pull script for syncing shiva-forme on another machine
# Run from the shiva-forme directory: bash tools/sync-pull.sh

set -e

echo "=== Shiva Sync Pull ==="
echo ""

# Check we're in a git repo
if ! git rev-parse --is-inside-work-tree &>/dev/null; then
  echo "ERROR: Not in a git repo. cd to your shiva-forme directory first."
  exit 1
fi

# Show current state
echo "Current branch: $(git branch --show-current)"
echo "Last local commit: $(git log -1 --oneline)"
echo ""

# Check for uncommitted changes
if git diff --quiet && git diff --cached --quiet; then
  echo "No local changes detected. Safe to pull."
  echo ""
  git pull origin main
  echo ""
  echo "Done! You're up to date."
  echo "See docs/session-sync-2026-02-25.md for pending work."
  exit 0
fi

# There are local changes — show them
echo "!! Local changes detected:"
echo ""
git diff --stat
git diff --cached --stat
echo ""

# Check for untracked files too
UNTRACKED=$(git ls-files --others --exclude-standard)
if [ -n "$UNTRACKED" ]; then
  echo "Untracked files:"
  echo "$UNTRACKED"
  echo ""
fi

echo "Options:"
echo "  1) Stash local changes, pull, then re-apply (safest)"
echo "  2) Discard local changes and pull (loses local work)"
echo "  3) Abort — I want to review manually first"
echo ""
read -p "Choose [1/2/3]: " choice

case $choice in
  1)
    echo ""
    echo "Stashing local changes..."
    git stash push -m "pre-sync-$(date +%Y%m%d-%H%M%S)"
    echo "Pulling..."
    git pull origin main
    echo ""
    echo "Re-applying stashed changes..."
    if git stash pop; then
      echo "Stash applied cleanly."
    else
      echo "!! MERGE CONFLICTS detected. Resolve them manually, then:"
      echo "   git add <resolved files>"
      echo "   git stash drop"
    fi
    ;;
  2)
    echo ""
    read -p "Are you sure? This discards ALL local changes. [y/N]: " confirm
    if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
      git checkout -- .
      git clean -fd
      git pull origin main
      echo "Done. Local is now identical to remote."
    else
      echo "Aborted."
      exit 0
    fi
    ;;
  3)
    echo "Aborted. Run these to review:"
    echo "  git diff              # see changed content"
    echo "  git diff --stat       # see changed files"
    echo "  git stash             # save changes aside"
    echo "  git pull origin main  # pull when ready"
    exit 0
    ;;
  *)
    echo "Invalid choice. Aborted."
    exit 1
    ;;
esac

echo ""
echo "See docs/session-sync-2026-02-25.md for pending work."
