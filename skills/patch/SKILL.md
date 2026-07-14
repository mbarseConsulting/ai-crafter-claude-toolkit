---
name: patch
description: "Use when: (1) user reports a mistake that must never happen again, (2) a recurring error needs a root-cause fix in the responsible artifact, (3) user is repeating the same correction — 'je te l'ai déjà dit', 'encore', 'combien de fois'."
argument-hint: "[description of the fault] [--dry]"
---

## OPTIONS

**`{description}`:** Optional. Describes the fault if it is not obvious from the conversation.

**`--dry`:** Diagnose only. Full root-cause report, zero file edits.

## BEHAVIOR

### What you MUST do

#### 1. Identify the fault

State precisely what went wrong: **expected vs actual**. Quote the user's complaint or the offending output. If several candidate faults exist, pick the one the user is reacting to.

If no fault is identifiable in the conversation and no description was given → say `[PATCH] No fault identified — describe the mistake.` and stop.

#### 2. Trace the root cause

The fault was produced under a set of active instructions. Enumerate every candidate source and **read the actual files** before accusing any of them:

- Skills invoked during the fault: `skills/*/SKILL.md` + their `references/`
- Agent persona in play: `agents/*.md`
- Memory: `MEMORY.md` index + individual memory files (wrong, stale, or missing memory)
- Instructions: project `.claude/CLAUDE.md`, global `~/.claude/CLAUDE.md` and included files
- Hooks and settings: `hooks.json`, `settings*.json`
- Output styles: `output-styles/*.md`

Classify the cause:

| Verdict      | Meaning                                                     |
| ------------ | ----------------------------------------------------------- |
| **WRONG**    | An instruction actively caused the fault                    |
| **WEAK**     | The instruction exists but is vague or ignorable            |
| **MISSING**  | No artifact covers this case                                |
| **CONFLICT** | Two artifacts contradict each other                         |
| **IGNORED**  | The instruction is clear but was not followed (model drift) |

Cite the guilty instruction with `file:line` and quote it. If evidence is split between two artifacts, say so — patch the most probable, flag the other.

#### 3. Patch long-term

Fix the **cause**, never just the symptom. Route the fix by location:

| Root cause in       | Fix                                                                    |
| ------------------- | ---------------------------------------------------------------------- |
| Skill               | Edit `SKILL.md` / `references/` + add a regression scenario to `SPEC.md` |
| Agent               | Edit the agent `.md`                                                    |
| Memory (wrong/stale)| Update or delete the memory file + its `MEMORY.md` line                 |
| Memory (missing)    | Create a `feedback` memory with **Why:** and **How to apply:**          |
| CLAUDE.md           | Edit the instruction where it lives                                     |
| Hook / settings     | Edit `hooks.json` / `settings*.json`                                    |
| Nothing (IGNORED / pure model behavior) | Create a `feedback` memory with an explicit counter to the rationalization used |

Patch rules:

- **WEAK** → strengthen with an explicit, testable rule and a counter to the exact rationalization observed. Never add "be careful" prose.
- **CONFLICT** → resolve in favor of the user's stated intent, patch **both** artifacts.
- Amend the existing rule when one exists — do not stack a new rule next to it.
- If the patched skill has a zip in `claudeai/`, rebuild it via `.claude/scripts/build-claudeai.sh {skill}`.

#### 4. Lock it in

If the patched artifact is a skill with a `SPEC.md`, add a regression scenario reproducing the fault so `/testskill` catches any recurrence.

### What you NEVER do

- Apologize instead of patching. The apology is the patch.
- Fix only the immediate output and stop.
- Write vague guidance ("pay more attention", "be rigorous") — every patch must be a rule that can be checked.
- Patch an artifact you have not read in this session.
- Invent a root cause without quoting evidence.
- Create a new artifact when editing an existing one suffices.

## OUTPUT

```
[PATCH]

FAULT: {expected vs actual, one line}
ROOT CAUSE: {WRONG|WEAK|MISSING|CONFLICT|IGNORED} — {file:line}
  > {quoted guilty instruction, or "no coverage" if MISSING}
PATCH:
- {file}: {what changed and why it prevents recurrence}
REGRESSION: {SPEC scenario added / feedback memory created / n/a}
```

With `--dry`: same output, `PATCH:` section replaced by `PROPOSED:`.

**Tone:** Forensic, accountable, zero excuses. Find the guilty line, fix it, prove it can't happen again.

## ACTIVATION - DEACTIVATION - HANDOFF

**`[PATCH]`** — Display this immediately.

**Applies to this response only. Auto-resets after.**
