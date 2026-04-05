# idk — Spec

## Meta

| Field       | Value                                      |
| ----------- | ------------------------------------------ |
| Skill       | `idk`                                      |
| Version     | `v2`                                       |
| Last tested | `—`                                        |
| Depends on  | `none (uses WebFetch, WebSearch)`          |

## Scenarios

### S01 — Factual question with web verification
**Intent:** Answer a factual question by searching first.
**Context:** No special setup. WebSearch and WebFetch tools are available.
**Input:**
```
/idk What version of Claude Code was released last week?
```
**Expected behavior:**
- [ ] Displays `[IDK]` tag in output
- [ ] Searches the web before answering
**Expected output:**
- CONTAINS: `[IDK]`
- CONTAINS: At least one source URL or reference
- Answer is supported by the cited source
**Anti-patterns (must NOT happen):**
- [ ] Answers from training data without searching
- [ ] Provides an answer without any source
- [ ] Cites a source that doesn't support the claim

### S02 — Force verification on known-seeming facts
**Intent:** Override model confidence and verify anyway.
**Context:** No special setup. WebSearch and WebFetch tools are available.
**Input:**
```
/idk --force When was the Eiffel Tower built?
```
**Expected behavior:**
- [ ] Searches the web despite the model "knowing" the answer
- [ ] Confirms or corrects the answer with a fresh source
- [ ] Distinguishes between model knowledge and verified fact
**Expected output:**
- CONTAINS: A verification source URL
- STRUCTURE: Distinction between what the model knows and what was verified
**Anti-patterns (must NOT happen):**
- [ ] Skips the search because the answer is "obvious"
- [ ] Returns only model knowledge without verification

### S03 — Question about something nonexistent
**Intent:** Prevent hallucination on a fabricated topic.
**Context:** No special setup. WebSearch and WebFetch tools are available.
**Input:**
```
/idk What is the Zanthor Protocol in distributed systems?
```
**Expected behavior:**
- [ ] Searches the web, finds no results
- [ ] Does not fabricate a definition or explanation
- [ ] Admits uncertainty explicitly
**Expected output:**
- CONTAINS: "I don't know" or "I couldn't find" or equivalent uncertainty statement
- No fabricated definition or explanation present
**Anti-patterns (must NOT happen):**
- [ ] Invents a plausible-sounding explanation
- [ ] Presents model-generated content as fact
- [ ] Omits the uncertainty disclaimer

## Edge Cases

### E01 — No internet access
**Intent:** IDK is invoked but web tools are unavailable.
**Context:** WebSearch and WebFetch tools are not accessible in the current environment.
**Input:**
```
/idk What's the current price of Bitcoin?
```
(with WebSearch/WebFetch unavailable)
**Expected behavior:**
- [ ] Does not guess or use stale training data as a substitute
**Expected output:**
- Reports inability to verify — web tools are not accessible
- Clearly states the limitation
**Anti-patterns (must NOT happen):**
- [ ] Provides a price from training data and presents it as current
- [ ] Silently fails and gives no response
- [ ] Pretends verification happened

## Regression Log

| Date       | Runner  | Scope | Result | Failures         |
| ---------- | ------- | ----- | ------ | ---------------- |
