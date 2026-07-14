# 🎨 AI Crafter Toolkit

_Reusable artifacts for AI-assisted coding tools — skills, agents, output styles, and more._

## Description

This repository serves as a foundation for creating, organizing, and testing reusable artifacts for AI-assisted coding tools.

You'll find:

- Ready-to-use or customizable skills, agents, and output styles
- Templates to easily create new artifacts (skills, agents, hooks, etc.)
- Resources to enrich and extend AI coding assistant capabilities

The goal is to centralize and accelerate the development of reusable AI artifacts.

## Overview

| Skill       | Role                                                                                            |
| ----------- | ----------------------------------------------------------------------------------------------- |
| `ai-expert` | AI artifact crafter — creates, audits, and advises on skills, agents, and hooks                 |
| `check`     | Self-auditor — compares recent work against user requests, flags missed/partial/parroted items  |
| `context`   | Prompt digester — absorbs heavy prompts, extracts intent, identifies blind spots before action  |
| `crit`      | Critical challenger — leads with objection, targets structural problems, never validates softly |
| `grind`     | Effort enforcer — forces maximum reasoning effort on every response, no shortcuts allowed       |
| `idk`       | Fact checker — searches before answering, cites sources, says "I don't know" when unsure        |
| `parse`     | Intent translator — reformulates human language into AI-optimized instructions                   |
| `spark`     | Creative provocateur — drops 3-4 unexpected "what if" angles to break predictable thinking      |
| `steps`     | Precision modifier — chunks long content into ~500-word blocks for granular analysis            |

**9 skills** — 1 crafter, 1 auditor, 1 digester, 1 challenger, 1 enforcer, 1 fact checker, 1 translator, 1 provocateur, 1 processing modifier

## Usage

### `/ai-expert`

Create, audit, or get advice on AI artifacts (skills, agents, hooks).

- **default** — advises on artifact type or approach
- **create** — generates an artifact from loaded template
- **audit** — evaluates an existing artifact
- **`-c` / `--context`** — runs in a separate subagent context

> Output: Recommendation | File listing | Audit report | Inline.

---

### `/context`

Digest a heavy prompt before acting — extract intent, scope, blind spots, and recommended next step.

- **default** — compact diagnostic: essence, scope, blind spots, next action
- **`-d` / `--deep`** — extended diagnostic with dependency mapping and risk assessment

> Single-use. Auto-resets after response.

---

### `/check`

Self-audit against recent user requests — flags what was missed, half-done, or parroted back.

- **default** — gathers last 2-3 prompts, compares ASKED vs DONE, reports gaps only

> Single-shot. Runs once, reports, done.

---

### `/crit`

Challenge ideas, claims, or responses with surgical bluntness.

- **default** — biggest problem first, descending severity, no positive ending
- **`-f` / `--force`** — brutal mode: zero praise, judges against the best in category

> Persistent mode. Deactivate with "relax", "stop crit", "normal", "mode normal".

---

### `/grind`

Force maximum reasoning effort — no shortcuts, no first drafts, no filler.

- **default** — every response requires extended deliberation, depth over breadth, committed positions

> Persistent mode. Deactivate with "relax", "stop grind", "normal", "mode normal".

---

### `/idk`

Verify facts before answering — dates, versions, stats, recent events.

- **default** — searches if any trigger matches, answers directly only when 100% certain
- **`-f` / `--force`** — always search, even if initially certain
- **`-q` / `--quick`** — skip search for this specific query

> Persistent mode. Deactivate with "trust me", "stop idk", "normal", "mode normal".

---

### `/parse`

Reformulate human language into AI-optimized instructions before writing to files.

- **default** — reformulates silently, outputs result directly
- **`-s` / `--show`** — displays intermediate steps (intent, gap, reformulation) before writing
- **`-b` / `--blacklist`** — activates vocabulary blacklist: zero reuse of original prompt words

> Single-use. Auto-resets after response.

---

### `/spark`

Break predictable thinking with unexpected creative angles.

- **default** — 3-4 contextual provocations, no explanation, no justification
- **"surprise me"** — uses available context (conversation, files, project)

> Persistent mode. Deactivate with "stop spark", "merci", "normal", "mode normal".

---

### `/steps`

Process long content with granular, block-by-block precision.

- **default** — chunks input into ~500-word blocks, processes each sequentially, then synthesizes
- Combines with any other skill or task

> Persistent mode. Deactivate with "stop steps", "normal", "mode normal".
