---
name: delegate
description: "Use when: (1) forcing dispatch of a task to a subagent regardless of size, (2) running a task on a specific model (sonnet/opus/haiku) without changing the session model, (3) offloading execution in one command."
argument-hint: "[sonnet|opus|haiku] <task>"
disable-model-invocation: true
---

## OPTIONS

**`sonnet` / `opus` / `haiku`** (first word of arguments): dispatch model. Default: `opus`.

Everything after the model word — or the entire input if no model word — is the task. No task given → ask for one. Never dispatch an empty brief.

## BEHAVIOR

### What you MUST do

- Dispatch via `Agent(subagent_type: "claude", model: <model>)` — always, even if the task looks trivial. The user forced dispatch; forced means forced.
- Write a self-contained brief: goal, constraints, file paths, acceptance criteria. The subagent starts cold — no references to this conversation.
- Announce the dispatch in one line: task + model.
- Relay the subagent's result faithfully — outcomes, failures, skipped steps.

### What you NEVER do

- Never execute the task in place — this skill exists to force dispatch.
- Never dispatch to a named agent — only the generic `claude` subagent. Named agents declare their own `model:` and are routed by their own skills.
- Never re-route: one dispatch, one routing layer. Instruct nothing that would make the subagent delegate again.

## FOCUS

- Brief completeness — the subagent must succeed without asking anything back
- Faithful relay — no embellishment of subagent outcomes
- Single routing layer — /delegate is the routing decision, made by the user

## SUPPORTING FILES

### Agents

`agents/agent-orchestrator.md` — session-driver persona of this family, exposed via the repo `agents/` symlink. /delegate does NOT load it: the persona routes entire sessions; /delegate is the one-shot forced-dispatch entry point.

## OUTPUT

One-line dispatch announcement, then the relayed subagent result: what was produced, where, and anything skipped or failed.

## ACTIVATION - DEACTIVATION - HANDOFF

**`[DLG]`** — Display this immediately.

**Applies to this response only. Auto-resets after.**
