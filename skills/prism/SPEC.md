# prism — Spec

## Meta

| Field       | Value                                      |
| ----------- | ------------------------------------------ |
| Skill       | `prism`                                    |
| Version     | `v2`                                       |
| Last tested | `—`                                        |
| Depends on  | `none`                                     |

## Scenarios

### S01 — Multi-angle exploration of a design decision

**Intent:** Validates that prism explores a problem from 4+ distinct angles.

**Context:** No special setup. User presents a technical architecture decision.

**Input:**

```
/prism should we use a monorepo or polyrepo for our microservices
```

**Expected behavior:**

- [ ] Extracts the decision context
- [ ] Explores from 4+ distinct angles (e.g., technical, UX, business, operational)
- [ ] Each angle is clearly labeled and distinct from the others
- [ ] Maps the space — does not recommend a single answer
- [ ] Each angle references concrete elements from the input

**Expected output:**

- COUNT: At least 4 distinct labeled angles
- STRUCTURE: Each angle is a separate labeled section
- No final recommendation — output maps the space only

**Anti-patterns (must NOT happen):**

- [ ] Produces fewer than 4 angles
- [ ] Two angles say the same thing differently
- [ ] Concludes with a recommendation instead of mapping

---

### S02 — Multi-angle exploration of a narrative choice

**Intent:** Validates that prism adapts its angles to fiction context.

**Context:** No special setup. User presents a narrative/fiction decision.

**Input:**

```
/prism should the antagonist die at the end of act 2 or survive to act 3
```

**Expected behavior:**

- [ ] Explores from narrative-relevant angles (thematic, character arc, plot structure, reader experience)
- [ ] Each angle addresses what changes about the story depending on the choice
- [ ] Does not default to technical/business angles on a fiction input

**Expected output:**

- STRUCTURE: Angles are narrative-specific (not technical/business defaults)
- Each angle explores consequences of each choice on the story

**Anti-patterns (must NOT happen):**

- [ ] Uses generic angles that ignore the narrative context
- [ ] Tells the author what to do instead of mapping consequences

---

### S03 — User-specified angles

**Intent:** Validates that prism uses user-provided angles instead of defaults.

**Context:** No special setup. User provides explicit angles via --angles flag.

**Input:**

```
/prism --angles "cost, team morale, technical debt" migrating from REST to GraphQL
```

**Expected behavior:**

- [ ] Uses exactly the 3 user-specified angles: cost, team morale, technical debt
- [ ] Does not add default angles unless the user asked for them
- [ ] Each angle is explored with the same depth as default angles

**Expected output:**

- COUNT: Exactly 3 angles matching the user-specified list
- CONTAINS: cost
- CONTAINS: team morale
- CONTAINS: technical debt

**Anti-patterns (must NOT happen):**

- [ ] Ignores user-specified angles and uses defaults
- [ ] Adds extra angles without being asked

---

## Edge Cases

### E01 — Trivial binary choice

**Intent:** Validates that prism still maps angles on a simple decision but flags potential overthinking.

**Context:** User presents a trivial decision that may not warrant deep analysis.

**Input:**

```
/prism should I use tabs or spaces
```

**Expected behavior:**

- [ ] Still explores from multiple angles
- [ ] Does not refuse to engage

**Expected output:**

- COUNT: At least 2 angles explored
- Flags that the decision may not warrant deep analysis

---

## Regression Log

| Date       | Runner  | Scope | Result | Failures         |
| ---------- | ------- | ----- | ------ | ---------------- |
