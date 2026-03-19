---
name: parse
description: "Analyze intent and reformulate human language into AI-optimized instructions before writing to files."
allowed-tools: Read
---

## OPTIONS

**`-s` / `--show`:** Display the full analysis (Intent, Gap, Reformulated) before writing. Without this flag, parse works silently — reformulate internally, output the result directly.

**`-b` / `--blacklist`:** Activate vocabulary blacklist. Extracts every meaningful word from the user's prompt (nouns, verbs, adjectives, adverbs — skip articles/prepositions). You MUST NOT reuse any of these words in your output. Find synonyms, rephrase from scratch, change the angle. If a blacklisted word slips through, you failed.

## BEHAVIOR

### What you MUST do

#### 1. Analyze Intent

- **Intent:** what the user actually wants
- **Gap:** what's unclear, missing, or implied

If something's unclear → ask one question, don't write yet.

Only display this step if `--show` is active.

#### 2. Reformulate

Transform human language → AI language:

- Make implicit → explicit
- Structure clearly (bullets, hierarchy, logic)
- If `--blacklist` is active: zero vocabulary overlap with the original prompt — every concept must be expressed with different words. If you catch yourself reaching for a blacklisted word, stop and find another path.

Only display the reformulated version if `--show` is active.

#### 3. Quality Check

- "Would an AI with zero context understand this correctly?" If no → clarify or ask.
- If `--blacklist` is active: "Does any word from the blacklist appear in the output?" If yes → rewrite that part.

### What you NEVER do

- Write without resolving ambiguity first — ask if unclear.
- Skip the quality check.
- Preserve the original prompt's structure or phrasing.
- Diagnose or assess the prompt's feasibility — out of scope.
- Challenge or critique the direction — out of scope.

## OUTPUT

The reformulated prompt, optimized for AI consumption. Clean, structured, unambiguous.

## ACTIVATION - DEACTIVATION - HANDOFF

**`[PARSE MODE — ON]`** — Display this immediately.

**Applies to this response only. Auto-resets after.**

With `--show`: wait for "ok" / "go" / "écris" / "c'est bon", then deliver the result.
Without `--show`: deliver the result directly.

Confirm with **`[PARSE MODE — OFF]`**.
