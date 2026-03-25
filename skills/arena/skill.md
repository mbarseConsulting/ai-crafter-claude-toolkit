---
name: arena
description: "Use when: (1) optimizing a skill, prompt, or process through competitive collaboration, (2) comparing multiple approaches to find the best, (3) user says 'arena' or wants agents to compete on a deliverable"
allowed-tools: Read
---

**`[ARENA]`** — Display immediately.

## PREREQUISITES

**`--full` mode (default)** requires agent teams. Before launching, verify that `settings.local.json` contains:

```json
{
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  }
}
```

If missing, inform the user and offer to add it via the `update-config` skill. Do NOT proceed without this setting — team features will silently fail.

## WHAT THIS SKILL DOES

Launches a competitive-collaborative optimization process. Multiple agents each produce their version of a deliverable, critique each other, integrate the best ideas, then test. The winner is the version that best answers ALL acceptance criteria.

## PROCESS

### Phase 0 — Cadrage

**MANDATORY. Do not launch agents before completing this phase.**

Ask and confirm each point with the user:

```
1. TARGET: what are we optimizing? [skill / prompt / process / other]
2. OUTPUT: what does the final deliverable look like?
3. TEST CHAIN: how do we validate? [step 1 → step 2 → ... → final output]
4. WITNESS: what stays IDENTICAL across all agents? (the control variable — without this, no comparison is possible)
5. CRITERIA: measurable acceptance criteria, defined NOW, not after
6. AGENTS: how many? (default: 3)
```

**The WITNESS is critical.** In a test chain A → B → C, if agents modify both A and B, you can't tell which change caused the result. Only ONE variable changes. Everything else is the witness.

Do NOT proceed until the user confirms all 6 points.

### Phase 1 — Production

Create a team. Launch N agents in parallel. Each receives:
- The current version of the target (if it exists)
- The full test chain context (witness artifacts, dependencies)
- The acceptance criteria
- Instructions to write their version to a shared location (e.g. `local/arena/[agent-name].md`)

Each agent produces their version independently. They notify the team lead when done.

**GATE: Wait for ALL agents to complete Phase 1 before proceeding.** Do not start Phase 2 until every agent has delivered its file. Announce to the user: "Phase 1 complete — N versions delivered. Launching critique."

### Phase 2 — Critique (MANDATORY)

**This phase is NOT optional unless `--skip-critique` is set. Do NOT skip it to save time or tokens.**

The team lead orchestrates the critique by sending each agent a message via `SendMessage` with these explicit instructions:

```
Read the other agents' versions at [file paths].
Produce a critique with exactly 3 sections:

1. TAKE — ideas you steal, from whom, why they're better than yours
2. GIVE — ideas you have that the others don't
3. BREAK — what won't work in their versions, and why

Send your critique to the team lead AND to the other agents directly.
You may respond to critiques you receive — concede, defend, or counter.
```

**Each agent MUST read the other versions and send critiques via SendMessage.** The team lead must verify that:
- Every agent has read all other versions
- Every agent has sent a critique containing TAKE/GIVE/BREAK
- Agents have had the opportunity to respond to critiques received

**GATE: Wait for all critiques AND responses before proceeding.** Announce to the user: "Phase 2 complete — critiques exchanged. Launching integration."

### Phase 3 — Integration

The team lead sends each agent a message via `SendMessage`:

```
You've received critiques. Now produce your FINAL version:
- Integrate what you chose to TAKE
- Keep what you GIVE
- Fix what was BROKEn
- CUT what doesn't earn its place — your own ideas included

Write your final version to [same file, overwrite].
Include a BILAN section at the end:
- TOOK: what you took (from whom, and why it's better than what you had)
- GAVE: what ideas of yours others adopted
- CUT: what you removed from your own v1 (and why it was noise)
- DEFENDED: what you kept despite critique (and why it earns its place)
```

**GATE: Wait for ALL agents to deliver their final version before proceeding.**

### Phase 4 — Test

Run the full test chain with each final version. The WITNESS stays identical across all runs.

If the chain requires a consumer agent (e.g., a writer consuming a brief), that consumer:
- Receives ONLY the output of the tested version
- Operates under the WITNESS conditions (same skill, same constraints)
- Produces the final output

### Phase 5 — Verdict

**Present the outputs FIRST, scores SECOND.** The user judges — the arena assists.

#### 1. Output index

List every agent's output with file paths so the user can read and compare:

```
## Outputs

| Agent | File |
|-------|------|
| [name] | `local/arena/[file]` |
| [name] | `local/arena/[file]` |
| [name] | `local/arena/[file]` |
```

If the outputs are short enough (< 50 lines each), display them inline side by side. If longer, give the paths and let the user read.

#### 2. Arena score

**The winner is NOT the agent with the best raw output. The winner is the agent who improved the most AND improved the others.**

The arena scores on two axes:

**TRADING SCORE — did this agent make the arena better?**
- **TAKE quality** (+) — took ideas that genuinely improved their version. Knowing what to steal is a skill.
- **GIVE impact** (+) — gave ideas that other agents actually adopted. Your idea survived someone else's filter.
- **CUT precision** (+) — identified and removed noise, bloat, or weak ideas (their own or others'). Trimming fat is as valuable as adding muscle.
- **Hoarding** (−) — refused to take good ideas out of stubbornness. Defended weak points instead of conceding.
- **Stuffing** (−) — took everything without filtering. The goal is the cream, not the pile.

**OUTPUT SCORE — does the final version work?**
- Acceptance criteria pass/fail + score (as defined in Phase 0)

```
| Agent | TAKE | GIVE | CUT | Hoarding | Stuffing | Trading | Output | TOTAL |
|-------|------|------|-----|----------|----------|---------|--------|-------|
| [A]   | +N   | +N   | +N  | -N       | -N       | = X     | Y/Z    | X+Y   |
| [B]   | ...  | ...  | ... | ...      | ...      | ...     | ...    | ...   |
```

**The arena rewards agents who make everyone better, not just themselves.** An agent who produces a great v1 but refuses to engage in critique scores lower than one whose v1 was weaker but who traded brilliantly and delivered a sharp final version.

#### 3. Recommendation (not decision)

Present a recommendation with:
- The key trades that shaped the final versions (who gave what to whom)
- The best CUTs (what got removed that made things better)
- What the top version still lacks

**The user decides.** Do not synthesize or install without explicit user approval. The scores inform — the user's judgment prevails.

## OPTIONS

**`-n <number>`:** Number of agents. Default: 3. Minimum: 2.

**`--dry`:** Run Phase 0 only. Define the cadrage, show the plan, don't launch agents.

**`--skip-critique`:** Skip Phase 2. Agents produce, test directly. Faster, less refined.

## WHAT THIS SKILL NEVER DOES

- **Launches without cadrage.** Phase 0 is mandatory. No exceptions.
- **Skips critique.** Phase 2 is mandatory unless `--skip-critique` is explicitly set. The team lead MUST send SendMessage to each agent with critique instructions. Launching evaluator agents instead of making the producers critique each other is NOT Phase 2 — it's a different process. The producers themselves must read, critique, and respond.
- **Skips integration.** Phase 3 is mandatory. Each agent must produce a revised version that incorporates critique. The team lead synthesizing on their own is NOT Phase 3.
- **Jumps phases.** Each phase has a GATE. Do not proceed to Phase N+1 until all agents have completed Phase N and the gate condition is met.
- **Lets agents modify the witness.** If an agent touches the control variable, their run is invalid.
- **Declares a winner without testing.** Critique quality is not output quality. The test decides.
- **Installs without user approval.** The verdict is a recommendation. The user decides.

## COST WARNING

This skill is expensive. 3 agents × 4 rounds = significant token usage. The skill should warn the user at Phase 0:

> "Arena with [N] agents will run [estimated rounds]. This is token-intensive. Confirm?"

## ACTIVATION — DEACTIVATION

**Persistent mode.** Stays active through all phases.

User says "stop", "abort", "kill arena" → shut down all agents, clean up, return to default.

Confirm with **`[ARENA — OFF]`**.
