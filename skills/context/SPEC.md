# context — Spec

## Meta

| Field       | Value                                      |
| ----------- | ------------------------------------------ |
| Skill       | `context`                                  |
| Version     | `v2`                                       |
| Last tested | `—`                                        |
| Depends on  | `none`                                     |

## Scenarios

### S01 — Digest a complex multi-part prompt
**Intent:** Anchor intent before acting on a heavy prompt.
**Context:** User submits a prompt with 5+ distinct intents and ambiguities.
**Input:**
```
/context
I need you to create 3 skills, update the arena agent, fix the hook that runs on commit, and also rename all the bd-* skills to use a "world-" prefix. Oh and make sure the README reflects all changes.
```
**Expected behavior:**
- [ ] Displays `[CTX — ON]` immediately
- [ ] Extracts distinct intents (create skills, update agent, fix hook, rename, update README)
- [ ] Identifies ambiguities (which 3 skills? what's wrong with the hook?)
- [ ] Asks clarifying questions before any file production
- [ ] Does NOT produce files, code, or modifications
**Expected output:**
- CONTAINS: `[CTX — ON]`
- STRUCTURE: Contains structured sections: Essence, Scope, Blind spots, Next
- COUNT: At least 5 distinct intents extracted
- CONTAINS: Clarifying questions
**Anti-patterns (must NOT happen):**
- [ ] Starts creating files immediately
- [ ] Misses one or more intents from the prompt
- [ ] Proceeds without surfacing ambiguities
- [ ] Runs Bash commands that write to disk

### S02 — Deep context with dependency mapping
**Intent:** Add dependency and risk analysis to the digest.
**Context:** User requests a refactor with potential ripple effects across files.
**Input:**
```
/context --deep
Refactor the arena skill to support 3-way competition instead of 2-way.
```
**Expected behavior:**
- [ ] Displays `[CTX — ON]`
- [ ] Does NOT produce any modifications
**Expected output:**
- CONTAINS: `[CTX — ON]`
- STRUCTURE: Contains standard sections (Essence, Scope, Blind spots, Next) plus Dependencies and Risks sections
- CONTAINS: Dependencies
- CONTAINS: Risks
**Anti-patterns (must NOT happen):**
- [ ] Skips dependency or risk mapping despite --deep flag
- [ ] Starts implementing the refactor
- [ ] Provides shallow analysis identical to standard mode

### S03 — Conflicting instructions
**Intent:** Surface contradictions in the user's prompt.
**Context:** User submits a prompt containing contradictory requirements.
**Input:**
```
/context
Make the skill shorter and more concise. Also add detailed examples for every instruction and comprehensive error handling for all edge cases.
```
**Expected behavior:**
- [ ] Identifies the conflict: shorter/concise vs. detailed examples + comprehensive handling
- [ ] Surfaces the contradiction explicitly in Blind spots
- [ ] Asks the user to prioritize or resolve the tension
- [ ] Does NOT pick a side silently
**Expected output:**
- STRUCTURE: Blind spots section explicitly names the contradiction
- CONTAINS: A question asking the user to prioritize
**Anti-patterns (must NOT happen):**
- [ ] Ignores the contradiction and proceeds
- [ ] Silently favors one direction over the other
- [ ] Produces output that tries to satisfy both without flagging the conflict

## Edge Cases

### E01 — Trivial or empty prompt
**Intent:** Context is invoked on something too simple to digest.
**Context:** User runs /context on a single trivial instruction.
**Input:**
```
/context
Fix the typo.
```
**Expected behavior:**
- [ ] Does not over-analyze a trivial instruction
**Expected output:**
- Reports nothing substantial to digest
- Suggests proceeding directly with the task
**Anti-patterns (must NOT happen):**
- [ ] Produces a multi-section analysis of a one-line fix
- [ ] Asks unnecessary clarifying questions

## Regression Log

| Date       | Runner  | Scope | Result | Failures         |
| ---------- | ------- | ----- | ------ | ---------------- |
