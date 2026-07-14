#!/usr/bin/env bash
# release-info.sh — read-only release facts detector.
# Detects base/head branches, current version, scheme, delta, and proposes next version.
# No writes, no network. Output: KEY=value lines + commit/file sections.
set -euo pipefail

git rev-parse --git-dir >/dev/null 2>&1 || { echo "ERROR=not a git repository"; exit 1; }

# --- Branches ---
if git show-ref --verify --quiet refs/heads/main; then BASE=main
elif git show-ref --verify --quiet refs/heads/master; then BASE=master
else echo "ERROR=no main/master branch"; exit 1; fi

if git show-ref --verify --quiet refs/heads/develop; then HEAD_BRANCH=develop
else HEAD_BRANCH=$(git rev-parse --abbrev-ref HEAD); fi

if [ "$HEAD_BRANCH" = "$BASE" ]; then
  echo "ERROR=head branch equals base ($BASE); nothing to release"; exit 1
fi

# --- Current version detection (cascade: tag > base subjects > version files > v0) ---
CURRENT=""; SOURCE=""
TAG=$(git tag -l 'v[0-9]*' --sort=-v:refname | head -1 || true)
if [ -n "$TAG" ]; then CURRENT="$TAG"; SOURCE="tag"; fi

if [ -z "$CURRENT" ]; then
  V=$(git log "$BASE" --pretty=%s | grep -oE 'v[0-9]+(\.[0-9]+){0,2}' | head -1 || true)
  if [ -n "$V" ]; then CURRENT="$V"; SOURCE="base-commit-subject"; fi
fi

if [ -z "$CURRENT" ] && [ -f package.json ]; then
  V=$(sed -n 's/.*"version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' package.json | head -1)
  if [ -n "$V" ]; then CURRENT="v$V"; SOURCE="package.json"; fi
fi

if [ -z "$CURRENT" ] && [ -f pyproject.toml ]; then
  V=$(sed -n 's/^version[[:space:]]*=[[:space:]]*"\([^"]*\)".*/\1/p' pyproject.toml | head -1)
  if [ -n "$V" ]; then CURRENT="v$V"; SOURCE="pyproject.toml"; fi
fi

if [ -z "$CURRENT" ] && [ -f pom.xml ]; then
  V=$(sed -n 's/[[:space:]]*<version>\([0-9][^<]*\)<\/version>.*/\1/p' pom.xml | head -1)
  if [ -n "$V" ]; then CURRENT="v$V"; SOURCE="pom.xml"; fi
fi

if [ -z "$CURRENT" ] && [ -f VERSION ]; then
  V=$(head -1 VERSION | tr -d '[:space:]')
  if [ -n "$V" ]; then CURRENT="v${V#v}"; SOURCE="VERSION"; fi
fi

if [ -z "$CURRENT" ]; then CURRENT="v0"; SOURCE="none"; fi

# --- Scheme + next version proposal ---
NUM=${CURRENT#v}
SUBJECTS=$(git log "$BASE".."$HEAD_BRANCH" --pretty=%s)
if [[ "$NUM" == *.* ]]; then
  SCHEME=semver
  IFS=. read -r MA MI PA <<<"$NUM"
  MI=${MI:-0}; PA=${PA:-0}
  if echo "$SUBJECTS" | grep -qiE '(BREAKING CHANGE|!:)'; then
    NEXT="v$((MA+1)).0.0"; BUMP=major
  elif echo "$SUBJECTS" | grep -qiE '(^|[ -])feat'; then
    NEXT="v${MA}.$((MI+1)).0"; BUMP=minor
  else
    NEXT="v${MA}.${MI}.$((PA+1))"; BUMP=patch
  fi
else
  SCHEME=integer
  NEXT="v$((NUM+1))"; BUMP=increment
fi

# --- Tree delta guard (squash merges break commit ancestry) ---
if git diff --quiet "$BASE".."$HEAD_BRANCH"; then TREE_DELTA=empty; else TREE_DELTA=present; fi

# --- Facts ---
echo "BASE=$BASE"
echo "HEAD=$HEAD_BRANCH"
echo "CURRENT_VERSION=$CURRENT"
echo "VERSION_SOURCE=$SOURCE"
echo "SCHEME=$SCHEME"
echo "PROPOSED_VERSION=$NEXT"
echo "BUMP=$BUMP"
echo "LAST_RELEASE_SUBJECT=$(git log "$BASE" --pretty=%s -1)"
echo "COMMIT_COUNT=$(git rev-list --count "$BASE".."$HEAD_BRANCH")"
echo "TREE_DELTA=$TREE_DELTA"
if [ "$TREE_DELTA" = empty ]; then
  echo "WARNING=tree delta is empty; commits above were likely already squash-merged into $BASE — nothing to release"
fi
[ -f CHANGELOG.md ] && echo "CHANGELOG=present" || echo "CHANGELOG=absent"
[ -f CONTRIBUTING.md ] && echo "CONTRIBUTING=present" || echo "CONTRIBUTING=absent"
echo ""
echo "--- COMMITS ($BASE..$HEAD_BRANCH) ---"
git log "$BASE".."$HEAD_BRANCH" --pretty='%h %s'
echo ""
echo "--- FILES CHANGED ---"
git diff --name-status "$BASE".."$HEAD_BRANCH" | head -60
echo ""
echo "--- DIFFSTAT ---"
git diff --stat "$BASE".."$HEAD_BRANCH" | tail -1
