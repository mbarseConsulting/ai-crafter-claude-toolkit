#!/usr/bin/env bash
# release-pr.sh — deterministic release PR creation.
# Optionally updates CHANGELOG.md on the head branch, pushes it, creates (or updates) the PR.
# GUARDRAILS: never merges, never pushes to base, never force-pushes, never tags.
set -euo pipefail

usage() {
  cat <<'EOF'
usage: release-pr.sh --version vX --title "..." --body-file FILE
                     [--base BRANCH] [--head BRANCH]
                     [--changelog-file FILE] [--commit-msg "..."]
                     [--dry-run]
EOF
  exit 1
}

DRY=0; BASE=""; HEAD_BRANCH=""; VERSION=""; TITLE=""; BODY_FILE=""; CL_FILE=""; COMMIT_MSG=""
while [ $# -gt 0 ]; do
  case "$1" in
    --version)        VERSION=$2; shift 2;;
    --title)          TITLE=$2; shift 2;;
    --body-file)      BODY_FILE=$2; shift 2;;
    --base)           BASE=$2; shift 2;;
    --head)           HEAD_BRANCH=$2; shift 2;;
    --changelog-file) CL_FILE=$2; shift 2;;
    --commit-msg)     COMMIT_MSG=$2; shift 2;;
    --dry-run)        DRY=1; shift;;
    *) usage;;
  esac
done

[ -n "$VERSION" ] && [ -n "$TITLE" ] && [ -n "$BODY_FILE" ] && [ -f "$BODY_FILE" ] || usage
git rev-parse --git-dir >/dev/null 2>&1 || { echo "ERROR: not a git repository"; exit 1; }
[ "$DRY" = 1 ] || command -v gh >/dev/null 2>&1 || { echo "ERROR: gh CLI required (brew install gh)"; exit 1; }

# Defaults mirror release-info.sh
if [ -z "$BASE" ]; then
  git show-ref --verify --quiet refs/heads/main && BASE=main || BASE=master
fi
if [ -z "$HEAD_BRANCH" ]; then
  if git show-ref --verify --quiet refs/heads/develop; then HEAD_BRANCH=develop
  else HEAD_BRANCH=$(git rev-parse --abbrev-ref HEAD); fi
fi
[ "$HEAD_BRANCH" = "$BASE" ] && { echo "ERROR: head == base ($BASE)"; exit 1; }

if [ "$DRY" = 1 ]; then
  echo "[dry-run] would checkout $HEAD_BRANCH"
  [ -n "$CL_FILE" ] && echo "[dry-run] would prepend $CL_FILE into CHANGELOG.md and commit: ${COMMIT_MSG:-chore: changelog $VERSION}"
  echo "[dry-run] would push origin $HEAD_BRANCH"
  echo "[dry-run] would create PR $HEAD_BRANCH -> $BASE titled: $TITLE"
  exit 0
fi

git checkout "$HEAD_BRANCH" >/dev/null 2>&1

# --- Changelog: prepend the new section under the title ---
if [ -n "$CL_FILE" ]; then
  [ -f "$CL_FILE" ] || { echo "ERROR: changelog section file not found: $CL_FILE"; exit 1; }
  tmp=$(mktemp)
  if [ -f CHANGELOG.md ] && head -1 CHANGELOG.md | grep -q '^# '; then
    { head -1 CHANGELOG.md; echo; cat "$CL_FILE"; echo; tail -n +2 CHANGELOG.md; } > "$tmp"
  elif [ -f CHANGELOG.md ]; then
    { cat "$CL_FILE"; echo; cat CHANGELOG.md; } > "$tmp"
  else
    { echo "# Changelog"; echo; cat "$CL_FILE"; } > "$tmp"
  fi
  mv "$tmp" CHANGELOG.md
  git add CHANGELOG.md
  git commit -m "${COMMIT_MSG:-chore: changelog $VERSION}" >/dev/null
  echo "CHANGELOG=committed"
fi

git push -u origin "$HEAD_BRANCH"

# --- Create or update the PR (idempotent) ---
EXISTING=$(gh pr list --head "$HEAD_BRANCH" --base "$BASE" --state open --json url --jq '.[0].url' 2>/dev/null || true)
if [ -n "$EXISTING" ] && [ "$EXISTING" != "null" ]; then
  gh pr edit "$EXISTING" --title "$TITLE" --body-file "$BODY_FILE" >/dev/null
  echo "PR_ACTION=updated"
  echo "PR_URL=$EXISTING"
else
  URL=$(gh pr create --base "$BASE" --head "$HEAD_BRANCH" --title "$TITLE" --body-file "$BODY_FILE")
  echo "PR_ACTION=created"
  echo "PR_URL=$URL"
fi
