# patch — Spec

## Meta

| Field       | Value   |
| ----------- | ------- |
| Skill       | `patch` |
| Version     | `v1`    |
| Last tested | `—`     |
| Depends on  | `none`  |

## Scenarios

### S01 — Fault traced to a skill instruction

**Intent:** A mistake caused by a weak instruction in a skill gets a long-term fix.
**Context:** Earlier in the conversation, a skill was invoked and produced output violating the user's known preference. The skill's SKILL.md contains a vague instruction covering this case.
**Input:**

```
/patch
```

**Expected behavior:**

- [ ] Displays `[PATCH]`
- [ ] States the fault as expected vs actual
- [ ] Reads the responsible SKILL.md before accusing it
- [ ] Classifies the cause (WEAK) and quotes the guilty line with file:line
- [ ] Edits the SKILL.md with a testable rule, not vague prose
- [ ] Adds a regression scenario to the skill's SPEC.md
**Expected output:**
- CONTAINS: `[PATCH]`
- CONTAINS: `FAULT:` and `ROOT CAUSE:` and `PATCH:` and `REGRESSION:`
- STRUCTURE: root cause cites a file and quotes the instruction
**Anti-patterns (must NOT happen):**
- [ ] Apologizes without editing any file
- [ ] Patches the conversation output only
- [ ] Adds "be more careful" style guidance
- [ ] Accuses an artifact without quoting it

### S02 — No responsible artifact (model behavior)

**Intent:** A recurring mistake with no covering instruction produces a feedback memory.
**Context:** The user corrects a behavior for which no skill, agent, memory, or CLAUDE.md rule exists.
**Input:**

```
/patch tu remets encore des emojis partout alors que je t'ai dit cent fois de ne pas en mettre
```

**Expected behavior:**

- [ ] Enumerates candidate sources and verifies none covers the case
- [ ] Classifies the cause as MISSING
- [ ] Creates a `feedback` memory with **Why:** and **How to apply:**
- [ ] Adds the memory to MEMORY.md index
**Expected output:**
- CONTAINS: `MISSING`
- CONTAINS: `REGRESSION:` referencing the created memory
**Anti-patterns (must NOT happen):**
- [ ] Invents a guilty artifact to have something to patch
- [ ] Writes the fact into MEMORY.md directly instead of a memory file

### S03 — Dry run

**Intent:** Diagnose without touching any file.
**Context:** A fault traceable to an artifact exists in the conversation.
**Input:**

```
/patch --dry
```

**Expected behavior:**

- [ ] Full root-cause analysis with file:line citation
- [ ] Zero file edits
- [ ] `PROPOSED:` section instead of `PATCH:`
**Expected output:**
- CONTAINS: `PROPOSED:`
**Anti-patterns (must NOT happen):**
- [ ] Edits a file despite --dry
- [ ] Skips the investigation because no patch will be applied

## Edge Cases

### E01 — No identifiable fault

**Intent:** /patch invoked with a clean conversation and no description.
**Context:** Start of a conversation, nothing has gone wrong.
**Input:**

```
/patch
```

**Expected behavior:**

- [ ] Stops immediately after one line
- [ ] Does not hallucinate a fault
**Expected output:**
- CONTAINS: `[PATCH] No fault identified — describe the mistake.`
**Anti-patterns (must NOT happen):**
- [ ] Invents a mistake to justify a patch
- [ ] Audits artifacts preventively

## Regression Log

| Date | Runner | Scope | Result | Failures |
| ---- | ------ | ----- | ------ | -------- |
