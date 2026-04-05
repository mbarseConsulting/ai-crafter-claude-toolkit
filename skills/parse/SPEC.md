# parse — Spec

## Meta

| Field       | Value                                      |
| ----------- | ------------------------------------------ |
| Skill       | `parse`                                    |
| Version     | `v2`                                       |
| Last tested | `—`                                        |
| Depends on  | `none`                                     |

## Scenarios

### S01 — Reformulate a vague request

**Intent:** Validates that parse extracts intent, surfaces ambiguities, and produces an optimized instruction from vague input.

**Context:** No special setup. User provides a vague, multi-part request.

**Input:**

```
/parse make the homepage better and more modern looking, also fix the thing with the buttons
```

**Expected behavior:**

- [ ] Analyzes the intent behind the vague language
- [ ] Identifies gaps ("better" is undefined, "the thing with the buttons" is ambiguous)
- [ ] Surfaces the ambiguities explicitly
- [ ] Produces a clean, optimized instruction that an AI could execute without guessing

**Expected output:**

- STRUCTURE: Ambiguities listed before the reformulated instruction
- Final instruction is specific enough to execute without guessing
- MATCH: Output is shorter or equal in length to input (no bloat)

**Anti-patterns (must NOT happen):**

- [ ] Passes through the vague request unchanged
- [ ] Invents specific requirements the user did not imply
- [ ] Outputs a longer, more verbose version of the same vagueness

---

### S02 — Show mode displays full analysis

**Intent:** Validates that --show displays the full analysis pipeline before the output.

**Context:** No special setup. User provides a clear but analyzable request with --show flag.

**Input:**

```
/parse --show add dark mode to the app
```

**Expected behavior:**

- [ ] Displays full analysis with labeled sections
- [ ] All three sections are visible before the final output

**Expected output:**

- STRUCTURE: Three labeled sections present: Intent, Gap, Reformulated
- CONTAINS: Intent section
- CONTAINS: Gap section
- CONTAINS: Reformulated section

**Anti-patterns (must NOT happen):**

- [ ] Skips any of the three analysis sections
- [ ] Shows analysis in non-show mode (default should be clean output only)

---

### S03 — Well-formed request gets minor tightening

**Intent:** Validates that parse does not over-engineer a request that is already clear.

**Context:** No special setup. User provides a precise, well-formed technical instruction.

**Input:**

```
/parse create a REST endpoint POST /api/users that validates email format, hashes the password with bcrypt, and returns 201 with the user object minus the password field
```

**Expected behavior:**

- [ ] Recognizes the request is already well-formed
- [ ] Applies minor tightening at most (e.g., standardize format, clarify edge cases)
- [ ] Does not bloat the instruction with unnecessary additions

**Expected output:**

- MATCH: Output is close to the original in length and specificity
- No invented requirements added beyond the original

**Anti-patterns (must NOT happen):**

- [ ] Rewrites a clear instruction into something longer and less clear
- [ ] Adds requirements the user did not mention
- [ ] Forces reformulation when none is needed

---

## Edge Cases

### E01 — Input is already a perfect instruction

**Intent:** Validates that parse returns a perfect instruction unchanged rather than forcing a reformulation.

**Context:** User provides an instruction that is already precise and unambiguous.

**Input:**

```
/parse read the file at /src/config.ts, find the DATABASE_URL constant, and change its value to "postgres://localhost:5432/mydb"
```

**Expected behavior:**

- [ ] Does not add analysis overhead to a perfect input

**Expected output:**

- Returns the instruction essentially unchanged
- May confirm it is already optimized

---

## Regression Log

| Date       | Runner  | Scope | Result | Failures         |
| ---------- | ------- | ----- | ------ | ---------------- |
