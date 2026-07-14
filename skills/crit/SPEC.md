# crit — Spec

## Meta

| Field       | Value                                      |
| ----------- | ------------------------------------------ |
| Skill       | `crit`                                     |
| Version     | `v2`                                       |
| Last tested | `—`                                        |
| Depends on  | `none`                                     |

## Scenarios

### S01 — Critical analysis on prose

**Intent:** Validates that crit identifies weakest elements, ranks by severity, and delivers zero praise by default.

**Context:** Previous assistant response contains a piece of mediocre prose with structural and surface issues.

**Input:**

```
/crit
```

**Expected behavior:**

- [ ] Displays `[CRIT]` tag
- [ ] Identifies the weakest elements in the text
- [ ] Ranks findings by severity (foundational before surface)
- [ ] No praise, no padding, no encouragement
- [ ] Every claim cites evidence (quotes passage, names element)

**Expected output:**

- CONTAINS: `[CRIT]`
- STRUCTURE: Findings ranked by severity, foundational issues first
- Each finding cites a specific passage or element as evidence

**Anti-patterns (must NOT happen):**

- [ ] Opens with compliments, hedges, or softeners
- [ ] Addresses surface issues before structural ones
- [ ] Makes claims without evidence

---

### S02 — Force mode zero praise

**Intent:** Validates that --force eliminates all praise, attacks the foundational idea, and finds the exact moment it loses its audience.

**Context:** Previous response contains a well-crafted but flawed technical proposal.

**Input:**

```
/crit --force
```

**Expected behavior:**

- [ ] Displays `[CRIT]` tag
- [ ] Zero praise — not reduced, zero
- [ ] Attacks the foundational idea, not just execution
- [ ] Finds the exact moment the piece loses its audience
- [ ] Judges against the best work in the category

**Expected output:**

- CONTAINS: `[CRIT]`
- No positive language anywhere in the output
- Identifies a specific moment where the piece fails

**Anti-patterns (must NOT happen):**

- [ ] Any form of positive feedback appears
- [ ] Critique is softened with "however" or "that said"

---

### S03 — Critical analysis on technical design

**Intent:** Validates that crit challenges assumptions and finds failure modes on technical content.

**Context:** Previous response contains a system architecture design with implicit assumptions.

**Input:**

```
/crit
```

**Expected behavior:**

- [ ] Displays `[CRIT]` tag
- [ ] Challenges core assumptions (scalability, failure modes, edge cases)
- [ ] Identifies what breaks first under stress
- [ ] Ranks problems by impact, not by ease of fix

**Expected output:**

- CONTAINS: `[CRIT]`
- STRUCTURE: Problems ranked by impact
- At least one challenged assumption explicitly named

**Anti-patterns (must NOT happen):**

- [ ] Accepts stated assumptions without questioning them
- [ ] Focuses only on code-level issues while ignoring design-level flaws

---

## Edge Cases

### E01 — Input is genuinely excellent

**Intent:** Validates that crit still finds something to challenge on strong input, rather than giving an empty pass.

**Context:** Previous response is a genuinely strong, well-argued piece.

**Input:**

```
/crit
```

**Expected behavior:**

- [ ] Still identifies at least one challenge or vulnerability
- [ ] Does not hand out a free pass ("nothing to critique here")
- [ ] May shift to higher-order concerns (audience, longevity, unstated assumptions)

**Expected output:**

- COUNT: At least 1 challenge or vulnerability identified
- No empty pass or "nothing to critique" message

---

## Regression Log

| Date       | Runner  | Scope | Result | Failures         |
| ---------- | ------- | ----- | ------ | ---------------- |
