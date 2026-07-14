---
name: release
description: "Use when: (1) creating a release PR from the delta between base and work branch, (2) bumping a version with changelog, (3) user says 'release', 'version', or 'PR de version'"
argument-hint: "[version|patch|minor|major] [--dry-run]"
---

## LOAD AGENT

Read `agents/agent-releaser.md` — you ARE this persona.

**Recommended — parallel, cheap:** Use the `Agent` tool with `subagent_type: "agent-releaser"`, `model: "haiku"` (explicit — frontmatter is not honored on named spawns), `run_in_background: true`. The agent needs no conversation context: pass only the project root, `SCRIPTS_DIR` (this skill's `scripts/` directory), and any version override or `--dry-run` flag.

## OPTIONS

**`--dry-run`:** Report what would happen; create and push nothing.

**`[version|patch|minor|major]`:** Override the computed version or force a bump level.

## SUPPORTING FILES

### Scripts

- `scripts/release-info.sh` — read-only facts: branches, current version, scheme, proposed next version, delta commits, files changed.
- `scripts/release-pr.sh` — the only write path: changelog commit on the head branch, push, PR create/update. Never merges, never touches base, never tags.

## OUTPUT

**Structure:**

- `version / title / PR URL / derivation` — one line each.

**Tone:** Terse, factual.

## ACTIVATION - DEACTIVATION - HANDOFF

**`[REL]`** — Display this immediately.

**Applies to this response only. Auto-resets after.**
