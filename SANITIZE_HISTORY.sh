#!/bin/bash
# Script to remove sensitive information from git history
#
# This script removes the old versions of sanitized files from git history
# Run this AFTER committing the sanitized versions
#
# WARNING: This rewrites git history. Only run if you haven't pushed to a shared remote,
# or if you're comfortable force-pushing.

set -e

echo "This will rewrite git history to remove sensitive information."
echo "Press Ctrl+C to cancel, or Enter to continue..."
read

# Create backup branch
git branch backup-before-sanitize 2>/dev/null || echo "Backup branch already exists"

# Files that contain sensitive info in old commits
SENSITIVE_FILES=(
    "Twitch_downloader/SCP_code.txt"
    "Twitch_downloader/Lamda_junk1.py"
    "Riot/Riot_Demo1.ipynb"
)

# Remove files from history (they'll be re-added from the sanitized working directory)
export FILTER_BRANCH_SQUELCH_WARNING=1

# Build the index-filter command to remove all files in one pass
FILTER_CMD="git rm --cached --ignore-unmatch"
for file in "${SENSITIVE_FILES[@]}"; do
    FILTER_CMD="$FILTER_CMD '$file'"
done
FILTER_CMD="$FILTER_CMD || true"

echo "Removing sensitive files from git history..."
echo "Files: ${SENSITIVE_FILES[@]}"
git filter-branch --force --index-filter "$FILTER_CMD" \
    --prune-empty --tag-name-filter cat -- --all

# Clean up
rm -rf .git/refs/original/
git reflog expire --expire=now --all
git gc --prune=now --aggressive

echo ""
echo "Git history sanitized!"
echo "To restore from backup if needed: git reset --hard backup-before-sanitize"
echo ""
echo "If this repo is already pushed to remote, you'll need to force push:"
echo "  git push --force --all"
