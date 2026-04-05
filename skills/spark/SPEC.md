# spark — Spec

## Meta

| Field       | Value                                      |
| ----------- | ------------------------------------------ |
| Skill       | `spark`                                    |
| Version     | `v2`                                       |
| Last tested | `—`                                        |
| Depends on  | `none`                                     |

## Scenarios

### S01 — Unexpected angles on a feature idea

**Intent:** Validates that spark produces 3-5 unexpected angles that are not the obvious solution.

**Context:** No special setup. User provides a feature idea for a developer tool.

**Input:**

```
/spark onboarding flow for a developer tool
```

**Expected behavior:**

- [ ] Displays `[SPARK]` tag
- [ ] Generates 3-5 angles
- [ ] Each angle is genuinely unexpected — not the first thing anyone would suggest
- [ ] Anti-centroid: angles diverge from the obvious/safe center
- [ ] Each angle references the specific input (developer tool, onboarding)

**Expected output:**

- CONTAINS: `[SPARK]`
- COUNT: 3 to 5 angles
- Each angle references "developer tool" or "onboarding" from the input

**Anti-patterns (must NOT happen):**

- [ ] Produces standard advice ("add a tutorial", "use tooltips")
- [ ] Generates vague platitudes without concrete direction
- [ ] Two angles attack the same element

---

### S02 — Fire mode with comfort check

**Intent:** Validates that --fire pushes into uncomfortable territory and includes a comfort check.

**Context:** No special setup. User uses --fire flag on a business topic.

**Input:**

```
/spark --fire pricing strategy for a SaaS product
```

**Expected behavior:**

- [ ] Displays `[SPARK]` tag
- [ ] Pushes harder into uncomfortable, subversive territory
- [ ] Includes a comfort check (exclusive to --fire mode)
- [ ] Angles are provocative enough to cause hesitation

**Expected output:**

- CONTAINS: `[SPARK]`
- CONTAINS: Comfort check (question or gate asking if the user wants to proceed)
- Angles are noticeably more provocative than default mode

**Anti-patterns (must NOT happen):**

- [ ] Fire mode output is indistinguishable from default mode
- [ ] Comfort check appears in non-fire mode
- [ ] Angles stay within the safe/expected zone

---

### S03 — Breaking a stuck brainstorm

**Intent:** Validates that spark breaks a deadlock when the user is stuck.

**Context:** User has been going back and forth on a decision and signals frustration.

**Input:**

```
/spark we've been going back and forth on the notification system for a week and every option feels wrong
```

**Expected behavior:**

- [ ] Acknowledges the stuck state without dwelling on it
- [ ] Generates directions that reframe the problem, not just new options within the same frame
- [ ] At least one angle questions the premise itself

**Expected output:**

- CONTAINS: `[SPARK]`
- MATCH: At least one angle challenges whether the notification system is the right problem to solve
- Angles reframe rather than iterate within the existing frame

**Anti-patterns (must NOT happen):**

- [ ] Offers more of the same kind of options the user is already stuck on
- [ ] Spends time analyzing why the user is stuck instead of providing angles

---

## Edge Cases

### E01 — Input is already unconventional

**Intent:** Validates that spark pushes further rather than retreating to safe ground when the input is already edgy.

**Context:** User provides an already unconventional premise.

**Input:**

```
/spark what if our error messages were haikus that insulted the user
```

**Expected behavior:**

- [ ] Acknowledges the input is already unconventional
- [ ] Pushes even further rather than pulling back toward reasonable
- [ ] Does not water down the premise

**Expected output:**

- CONTAINS: `[SPARK]`
- Angles build on the unconventional premise, not retreat from it

---

## Regression Log

| Date       | Runner  | Scope | Result | Failures         |
| ---------- | ------- | ----- | ------ | ---------------- |
