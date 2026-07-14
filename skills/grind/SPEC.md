# grind — Spec

## Meta

| Field       | Value                                      |
| ----------- | ------------------------------------------ |
| Skill       | `grind`                                    |
| Version     | `v2`                                       |
| Last tested | `—`                                        |
| Depends on  | `none`                                     |

## Scenarios

### S01 — Grind mode on a standalone question
**Intent:** Force maximum reasoning effort on a question.
**Context:** No special setup. User asks a standalone analytical question.
**Input:**
```
/grind
What are the failure modes of a skill that delegates to sub-agents?
```
**Expected behavior:**
- [ ] Displays `[GRIND — ON]` tag in output
- [ ] Response shows genuine reasoning, not a summary of first instinct
- [ ] Covers non-obvious failure modes (not just the top 3)
- [ ] Takes a clear position with specific recommendations
- [ ] Shows reasoning (WHY), not just conclusions (WHAT)
- [ ] No filler sentences
**Expected output:**
- CONTAINS: `[GRIND — ON]`
- COUNT: More than 3 failure modes identified
- STRUCTURE: Each failure mode includes reasoning (why it happens), not just a label
**Anti-patterns (must NOT happen):**
- [ ] Produces a shallow list of obvious points
- [ ] Omits the [GRIND — ON] tag
- [ ] Starts with "Great question!" or similar filler
- [ ] Hedges with "it depends" without navigating to a position

### S02 — Grind combined with another skill
**Intent:** Grind amplifies another skill's effort level.
**Context:** A multi-step task has been completed, providing history for /check to audit.
**Input:**
```
/grind
/check
```
**Expected behavior:**
- [ ] The check skill operates at maximum effort
- [ ] Check is more thorough than it would be without grind
- [ ] Both [GRIND — ON] and check behavior are present
**Expected output:**
- CONTAINS: `[GRIND — ON]`
- STRUCTURE: Check output shows deeper analysis than default check behavior
**Anti-patterns (must NOT happen):**
- [ ] Grind overrides or replaces the other skill
- [ ] The other skill runs at normal effort despite grind
- [ ] Reverts to lazy defaults after first grind response

### S03 — Grind on a code review
**Intent:** Catch subtle issues a normal pass would miss.
**Context:** User provides a skill.md or code file for review.
**Input:**
```
/grind
Review this skill.md for issues: [file content]
```
**Expected behavior:**
- [ ] Catches subtle issues: implicit assumptions, missing edge cases, ambiguous phrasing
- [ ] Does not stop at surface-level observations
- [ ] Provides specific, actionable findings
- [ ] Examines interactions between sections, not just individual lines
**Expected output:**
- STRUCTURE: Findings go beyond surface-level (formatting, typos) into design-level issues
- Each finding is specific and actionable
**Anti-patterns (must NOT happen):**
- [ ] Only reports formatting or typo issues
- [ ] Produces the same review quality as without grind
- [ ] Pads the response with filler to appear thorough

## Edge Cases

### E01 — Grind on a trivial question
**Intent:** Grind is activated for something simple.
**Context:** User asks a trivial arithmetic question with grind active.
**Input:**
```
/grind
What's 2+2?
```
**Expected behavior:**
- [ ] Still applies max effort — does not skip grind for simple inputs
- [ ] [GRIND — ON] tag is displayed
- [ ] May provide deeper context beyond just "4"
**Expected output:**
- CONTAINS: `[GRIND — ON]`
- Response goes beyond a single-word answer
**Anti-patterns (must NOT happen):**
- [ ] Ignores grind because the question is trivial
- [ ] Produces an absurdly long response for a simple question

## Regression Log

| Date       | Runner  | Scope | Result | Failures         |
| ---------- | ------- | ----- | ------ | ---------------- |
