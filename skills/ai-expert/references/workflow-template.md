# Workflow Template

Multi-agent workflow (bench) pattern. Produces 3+ files: one skill (orchestration) and N agents (personas).

**Naming convention:** `agent-{role}-{workflow}` (e.g., `agent-judge-refine`, `agent-crafter-refine`, `agent-spark-arena`)

---

## File Structure

```
skills/{workflow-name}/
├── skill.md                              # Workflow (phases, gates, formats)
└── agents/
    ├── agent-judge-{workflow}.md          # AP — judge/orchestrator (Read by main agent)
    └── agent-crafter-{workflow}.md        # AC — crafter subagent (spawned via Agent tool)

agents/                                    # Symlinks at project root
├── agent-judge-{workflow}.md     → ../skills/{workflow-name}/agents/...
└── agent-crafter-{workflow}.md   → ../skills/{workflow-name}/agents/...

.claude/agents → ../agents                 # Symlink for Claude Code discovery
```

Multiple crafters supported (e.g., `agent-straight-arena` + `agent-spark-arena`).

---

## 1. Skill File (`skill.md`)

The skill carries the **workflow only** — no persona, no behavior.

```markdown
---
name: {workflow-name}
description: "Use when: (1) [trigger], (2) [trigger], (3) [trigger]"
---

**`[TAG]`** — Display immediately.

## OPTIONS

| Flag | Effect |
|------|--------|
| `--dry` | [Cadrage/diagnostic only — no execution] |

## AGENTS

- **Judge AP:** Read `agents/agent-judge-{workflow}.md` — you ARE this persona.
- **Crafter AC:** `agents/agent-crafter-{workflow}.md` — [role description], launched in Phase [N].

## OUTPUT

### Structure

[Define output formats for each phase — tables, reports, verdicts.]

### Tone

[Adjectives describing voice.]

## PROCESS

### Phase 0 — Cadrage

**Once per session. Mandatory.**

[Contract template — what user validates before launch.]

Before GATE 0, run `/check` to verify the contract captures all user intentions. Fix gaps before proceeding.

**GATE 0:** User confirms -> launch. User cancels -> **`[TAG — OFF]`**.

---

### Phase N — [Craft / Optimization / Generation]

Use the `Agent` tool with `subagent_type: "agent-crafter-{workflow}"`.
**prompt**: [What to include — contract, diagnostic, target, output path.]

**GATE N:** AC delivers -> AP resumes.

---

### Phase N+1 — [Evaluation / Test]

[AP evaluates AC's output. If FAIL -> resume AC via `SendMessage`.]

**GATE N+1:** [Pass condition] -> next phase.

---

### Phase N+2 — Verdict

[AP presents results, user decides.]

## ACTIVATION - DEACTIVATION - HANDOFF

**Persistent mode. Stays active through all phases.**

User says "stop", "done", "kill {workflow}" -> [cleanup], **`[TAG — OFF]`**.
```

---

## 2. Judge Agent (`agent-judge-{workflow}.md`)

The judge is the **main agent** — loaded via Read, not spawned. Never produces the deliverable.

```markdown
---
name: agent-judge-{workflow}
description: "[Role]. Does NOT produce [deliverable] — only [evaluates/diagnoses/judges]."
---

**`[TAG]`** — Display at the start of your first response.

## LOAD SKILLS

Invoke `/crit` [and `/steps`, `/other`].

## ROLE

[Persona in 2-3 sentences. What they care about, how they operate.]

**Style:** [Register.]

## BEHAVIOR

### What you MUST do

1. **[Core judge directive.]**
2. **[Core judge directive.]**

### What you NEVER do

1. **Never produce the deliverable.** You [diagnose/judge/evaluate]. AC [crafts/optimizes].
2. **[Guardrail.]**

## FOCUS

- [Key methodology principle]
- [Key methodology principle]
- Roles are walls — you judge, AC produces, no crossing.
```

---

## 3. Crafter Agent (`agent-crafter-{workflow}.md`)

The crafter is a **subagent** — spawned via Agent tool. Produces the deliverable.

```markdown
---
name: agent-crafter-{workflow}
description: "[What it produces]. Does NOT [judge/evaluate] — only executes."
model: sonnet
---

**`[TAG]`** — Display at the start of your first response.

## LOAD SKILLS

Invoke `/crit` [and `/other`].

## ROLE

[Persona in 2-3 sentences. Execution-focused.]

**Style:** [Register.]

## BEHAVIOR

### What you MUST do

- [Core craft directive.]
- [Core craft directive.]
- Write output to the path specified in the dispatch.

### What you NEVER do

- Judge quality or render verdicts — AP does that.
- [Scope guardrail.]
- Spawn sub-agents.

## OUTPUT

[What the crafter delivers and where.]
```

---

## Dispatch Patterns

### First spawn (Agent tool)

See Phase N in the skill template above.

For multiple crafters in parallel, use separate `Agent` tool calls in a single message.

### Resume existing agent (SendMessage)

```
Resume AC via `SendMessage` (using agent name). Message includes [new instructions, feedback, context].
```

**Never re-spawn an agent that is still alive.** Use `SendMessage` to resume — preserves context, saves tokens.

---

## Symlink Setup

After creating agents, symlink them for Claude Code discovery:

```bash
# From project root
ln -s ../skills/{workflow}/agents/agent-judge-{workflow}.md agents/agent-judge-{workflow}.md
ln -s ../skills/{workflow}/agents/agent-crafter-{workflow}.md agents/agent-crafter-{workflow}.md
# .claude/agents should already symlink to ../agents
```

---

## Checklist

Before delivery, verify:

- [ ] `skill.md` has AGENTS section with Read of judge persona and listing of all crafter agents
- [ ] `skill.md` has no BEHAVIOR/FOCUS (moved to judge agent)
- [ ] Judge agent has LOAD SKILLS with required skills
- [ ] Each crafter agent has LOAD SKILLS with `/crit` + domain skills
- [ ] Dispatch uses `Agent` tool with correct `subagent_type` and formulation
- [ ] Resume uses `SendMessage`, not re-spawn
- [ ] Symlinks created in `agents/` and `.claude/agents`
- [ ] Naming follows `agent-{role}-{workflow}` convention
- [ ] Separation respected: skill = workflow, agents = personas
