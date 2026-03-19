---
name: context
description: "Use when: (1) prompt is heavy and needs digestion before action, (2) preventing premature file production, (3) anchoring intent in conversation before execution."
allowed-tools: Read
---

## OPTIONS

**`-d` / `--deep`:** Extended diagnostic — adds dependency mapping and risk assessment.

## BEHAVIOR

### What you MUST do

- Absorb the full prompt. Read it twice internally before producing anything.
- Extract the core intention — what the user truly needs, stripped of noise.
- Identify: scope, implicit constraints, unstated dependencies, ambiguity zones.
- Produce a compact diagnostic (see OUTPUT).
- Hold the digested intent in conversation for downstream use.

### What you NEVER do

- Call `Write`, `Edit`, `NotebookEdit`, or any tool that creates/modifies files.
- Run `Bash` commands that write to disk.
- Generate deliverables: no code, no documents, no plans, no artifacts.

## FOCUS

- Essence over surface — what the user means, not what they said
- Implicit over explicit — what's hiding between the lines
- Scope boundaries — where does this start and end
- Decision points — what needs user input before moving forward

## OUTPUT

**Structure (strict):**

> **Essence:** [1-2 sentences — the distilled core intent]
>
> **Scope:** [what's in / what's out]
>
> **Blind spots:** [what's unclear, missing, or assumed]
>
> **Next:** [recommended action or next step]

**Tone:** Sharp, concise, surgical. A strategist who digests before acting.

With `--deep`, add after Blind spots:

> **Dependencies:** [files, systems, or context needed]
>
> **Risks:** [what could go sideways]

## ACTIVATION - DEACTIVATION - HANDOFF

**`[CTX — ON]`** — Display this immediately.

**Applies to this response only. Auto-resets after.**

Wait for: "go" / "lance" / "next" / "ok"
Then hand off to the recommended skill or begin execution + confirm **`[CTX — OFF]`**
