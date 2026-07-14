# steps — Spec

## Meta

| Field       | Value                                      |
| ----------- | ------------------------------------------ |
| Skill       | `steps`                                    |
| Version     | `v2`                                       |
| Last tested | `—`                                        |
| Depends on  | `none`                                     |

## Scenarios

### S01 — Combined with a QA skill on long content

**Intent:** Validates that steps forces granular, paragraph-by-paragraph processing when combined with another skill.

**Context:** User provides a 2000-word essay for critique. /crit is the companion skill.

**Input:**

```
/steps /crit
```

**Expected behavior:**

- [ ] Activates step-by-step processing mode
- [ ] QA examines every paragraph instead of sampling or summarizing
- [ ] Each section is addressed individually with explicit markers
- [ ] Nothing is skipped — every paragraph gets attention
- [ ] Final output synthesizes findings across all sections

**Expected output:**

- STRUCTURE: Each paragraph or section has its own labeled block (e.g., markers or headings)
- CONTAINS: A synthesis section after the per-section analysis
- COUNT: Number of analyzed sections matches number of paragraphs in the input

**Anti-patterns (must NOT happen):**

- [ ] Skips paragraphs or sections
- [ ] Processes the text as a single blob
- [ ] Reduces depth on later sections (fatigue pattern)

---

### S02 — Long document sequential processing

**Intent:** Validates that steps processes a long document in explicit sequential chunks with nothing skipped.

**Context:** User provides a 3000-word technical document for analysis.

**Input:**

```
/steps
```

**Expected behavior:**

- [ ] Splits the document into sequential chunks
- [ ] Processes each chunk explicitly, announcing progress (e.g., "Section 1/N")
- [ ] Maintains consistent depth across all chunks
- [ ] No chunk is merged with another or summarized instead of analyzed

**Expected output:**

- MATCH: Progress markers like "Section 1/N", "Section 2/N" etc.
- STRUCTURE: Each chunk is processed as a separate block
- Consistent depth from first chunk to last

**Anti-patterns (must NOT happen):**

- [ ] Skips or glosses over middle sections
- [ ] Front-loads detail on early sections and summarizes later ones
- [ ] Processes out of order

---

### S03 — Code review with granular attention

**Intent:** Validates that steps examines each function/block individually in a code review context.

**Context:** User provides a 200-line code file for review.

**Input:**

```
/steps
```

**Expected behavior:**

- [ ] Examines each function or logical block individually
- [ ] Flags issues per-block, not just globally
- [ ] Does not skip small utility functions or boilerplate

**Expected output:**

- STRUCTURE: Each function or logical block has its own review section
- Findings are attributed to specific functions, not listed globally

**Anti-patterns (must NOT happen):**

- [ ] Reviews only the "interesting" parts
- [ ] Provides a single summary without per-block analysis

---

## Edge Cases

### E01 — Very short input (< 5 lines)

**Intent:** Validates that steps still applies granular processing on minimal input rather than skipping.

**Context:** User provides a 3-line code snippet.

**Input:**

```
/steps
```

**Expected behavior:**

- [ ] Still applies line-by-line or element-by-element processing
- [ ] Does not skip granular mode because input is short

**Expected output:**

- STRUCTURE: Each line or element is processed individually
- May note the input is short but still processes thoroughly

---

## Regression Log

| Date       | Runner  | Scope | Result | Failures         |
| ---------- | ------- | ----- | ------ | ---------------- |
