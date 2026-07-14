# check — Spec

## Meta

| Field       | Value                                      |
| ----------- | ------------------------------------------ |
| Skill       | `check`                                    |
| Version     | `v2`                                       |
| Last tested | `—`                                        |
| Depends on  | `none`                                     |

## Scenarios

### S01 — Standard post-task check
**Intent:** After completing a task, verify nothing was missed.
**Context:** A multi-step task has just been completed in the conversation.
**Input:**
```
/check
```
(after completing a multi-step task)
**Expected behavior:**
- [ ] Displays `[CHECK — ON]`
- [ ] Re-reads the last 2-3 user prompts
- [ ] Lists what was requested vs what was delivered
- [ ] Flags any omissions or partial completions with specific references
- [ ] Single-shot — runs once and stops
**Expected output:**
- CONTAINS: `[CHECK — ON]`
- CONTAINS: `MISSED` or `PARTIAL` or `PARROTED` or `All covered`
- STRUCTURE: Uses structured output format with `MISSED (N):`, `PARTIAL (N):`, `PARROTED (N):` sections when gaps exist
**Anti-patterns (must NOT happen):**
- [ ] Only checks the last prompt, ignoring earlier related ones
- [ ] Reports vague gaps without specifics
- [ ] Modifies or fixes anything — check only reports
- [ ] Makes excuses ("I interpreted it as...")

### S02 — Extended depth check
**Intent:** Audit a longer conversation history.
**Context:** A conversation with at least 5 user prompts has taken place.
**Input:**
```
/check --depth 5
```
**Expected behavior:**
- [ ] Re-reads the last 5 user prompts instead of default 2-3
- [ ] Covers all requests within that range
- [ ] Identifies gaps across the extended window
- [ ] Groups findings by prompt for clarity
**Expected output:**
- COUNT: Findings grouped across exactly 5 prompts
- STRUCTURE: Each prompt's findings are grouped separately
**Anti-patterns (must NOT happen):**
- [ ] Ignores the depth parameter and checks default range
- [ ] Checks more than 5 prompts

### S03 — Everything was done correctly
**Intent:** Check when all work is complete and accurate.
**Context:** A task has just been delivered with everything done correctly.
**Input:**
```
/check
```
(after a task where everything was delivered correctly)
**Expected behavior:**
- [ ] Displays `[CHECK — ON]`
- [ ] No additional text or padding beyond the confirmation
**Expected output:**
- CONTAINS: `[CHECK — ON]`
- CONTAINS: `[CHECK] All covered.`
- COUNT: Exactly 2 output lines (tag + confirmation)
**Anti-patterns (must NOT happen):**
- [ ] Fabricates issues to appear useful
- [ ] Lists COVERED items individually
- [ ] Reports cosmetic suggestions as gaps
- [ ] Adds encouragement or summary

## Edge Cases

### E01 — No prior user prompts
**Intent:** Check is invoked at the start of a conversation.
**Context:** First message in a brand new conversation, no prior history.
**Input:**
```
/check
```
(first message in conversation)
**Expected behavior:**
- [ ] Stops immediately
- [ ] Does not hallucinate a history
**Expected output:**
- CONTAINS: `[CHECK] Nothing to audit.`
**Anti-patterns (must NOT happen):**
- [ ] Invents previous prompts to audit
- [ ] Crashes or produces an error

## Regression Log

| Date       | Runner  | Scope | Result | Failures         |
| ---------- | ------- | ----- | ------ | ---------------- |
