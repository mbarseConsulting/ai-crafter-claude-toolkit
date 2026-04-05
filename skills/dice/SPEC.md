# dice — Spec

## Meta

| Field       | Value                                      |
| ----------- | ------------------------------------------ |
| Skill       | `dice`                                     |
| Version     | `v2`                                       |
| Last tested | `—`                                        |
| Depends on  | `none`                                     |

## Scenarios

### S01 — Random constraints on story premise

**Intent:** Validates that dice extracts context, rolls random constraints, filters cliches, and produces genuinely subversive angles.

**Context:** No special setup. User provides a story premise as input.

**Input:**

```
/dice a detective story set in a space station
```

**Expected behavior:**

- [ ] Extracts context from the input
- [ ] Rolls random constraints (visible in output)
- [ ] Filters results against known cliches and predictable angles
- [ ] Produces genuinely unexpected angles — not the first thing anyone would think of
- [ ] Each angle references specific elements from the input

**Expected output:**

- STRUCTURE: Rolled constraints are displayed before the angles
- Each angle references "detective" and/or "space station" from the input
- No angle matches common genre tropes

**Anti-patterns (must NOT happen):**

- [ ] Produces obvious genre tropes (hard-boiled detective, noir in space)
- [ ] Ignores the rolled constraints in the output
- [ ] Generates generic ideas that could apply to any input

---

### S02 — Reroll produces different results

**Intent:** Validates that --reroll generates a different set of results from the same input.

**Context:** Previous turn used `/dice a detective story set in a space station` and produced a set of angles.

**Input:**

```
/dice --reroll
```

**Expected behavior:**

- [ ] Produces a new set of results distinct from the first round
- [ ] Rolls fresh constraints (different from round 1)
- [ ] No angle or theme is recycled from the previous round

**Expected output:**

- STRUCTURE: New constraints visibly different from round 1
- COUNT: 0 repeated angles from the previous round

**Anti-patterns (must NOT happen):**

- [ ] Repeats any angle from the first round
- [ ] Reuses the same constraint types

---

### S03 — Dice on a technical problem

**Intent:** Validates that dice works on non-fiction/technical input and generates unconventional approaches.

**Context:** No special setup. User provides a technical problem as input.

**Input:**

```
/dice how to reduce API latency
```

**Expected behavior:**

- [ ] Extracts the technical context
- [ ] Rolls constraints and applies them to the technical domain
- [ ] Produces approaches that are not standard best-practice advice
- [ ] Each suggestion is concrete enough to evaluate

**Expected output:**

- STRUCTURE: Rolled constraints visible, applied to technical domain
- Each suggestion is actionable, not abstract
- No suggestion is standard textbook advice alone

**Anti-patterns (must NOT happen):**

- [ ] Produces textbook optimization advice (caching, CDN, indexing) without a twist
- [ ] Generates vague platitudes ("think differently about latency")

---

## Edge Cases

### E01 — Very narrow input (single word)

**Intent:** Validates that dice generates meaningful provocations even from minimal input.

**Context:** User provides a single word with no additional context.

**Input:**

```
/dice chair
```

**Expected behavior:**

- [ ] Treats "chair" as the seed
- [ ] Rolls constraints and produces concrete angles
- [ ] Results are surprising, not just "different types of chairs"

**Expected output:**

- STRUCTURE: Constraints rolled and applied to the single-word seed
- Angles go beyond surface-level variations of the input word

---

## Regression Log

| Date       | Runner  | Scope | Result | Failures         |
| ---------- | ------- | ----- | ------ | ---------------- |
