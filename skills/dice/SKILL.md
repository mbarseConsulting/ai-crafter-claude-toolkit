---
name: dice
description: "Use when: (1) ideas are stuck in the centroid, (2) need to force genuinely subversive angles, (3) user wants randomized creative provocation with anti-pattern filtering"
allowed-tools: Read
---

## CONTEXT EXTRACTION

Before generating anything, extract from the input:

1. **Domain** -- the field, discipline, or subject area
2. **Object** -- the specific thing being worked on (feature, scene, module, concept)
3. **Constraint** -- what limits the space (budget, tone, architecture, genre, audience)
4. **Stuck point** -- what feels safe, blocked, or predictable (explicit or inferred)

## THE ENGINE

Two passes, both visible. Stackable — if the user asks for another round ("encore", "another", "next"), EVERYTHING from previous rounds (reflexes + sparks) becomes radioactive. The forbidden territory grows with each iteration, pushing the model further from the centroid.

### Pass 1 — First reflexes

Generate 3 sparks normally. These are your first instincts -- the statistical centroid of your training data. Display them under the label `REFLEXES:` with strikethrough (~~text~~). Visible but dead.

Extract keywords, themes, and angles from these 3 reflexes. This territory joins the **radioactive zone** -- no spark from pass 2 can touch it.

**Next rounds:** the radioactive zone includes everything from all previous rounds (reflexes + sparks). Generate 3 NEW reflexes despite the zone — the centroid has multiple layers. Display them struck through, add to radioactive zone, then pass 2.

### Pass 2 — 3 dice + radioactive zone

Roll 3 dice separately. Each die gives a different constraint for ONE spark. 3 rolls, 3 constraints, 3 independent sparks. Each spark also gets a random **register** — never repeat a register within the same round.

**Registers:** funny, dark, tender, absurd, brutal, quiet, grotesque, clinical. Pick 3 different ones at random per round.

**Comfort check:** Could this spark be said in a brainstorming session without anyone frowning? If yes, it's too safe. A real spark provokes a "wait... no... actually maybe?" If it's pretty, poetic, or cute without being unsettling, it's dead. Replace it.

| Die | Constraint |
|---|---|
| 1 | **Imposed domain** -- a random domain far from the input (beekeeping, liturgy, plumbing, haute couture, forensics, cartography...). The spark must pass through this domain. |
| 2 | **Physical object** -- a random concrete object (a candle, a screwdriver, a shoe, an hourglass...). The spark must contain this object. |
| 3 | **Era** -- an imposed era (Antiquity, 2400, the 80s, Renaissance...). The spark is reframed in this temporality. |
| 4 | **Absurd constraint** -- an arbitrary rule (no verbs, max 7 words, forbidden to name the main subject...). |
| 5 | **Person** -- an imposed point of view (a 6-year-old, an accountant, a monk, a pirate...). The spark goes through this gaze. |
| 6 | **Forbidden** -- the most central concept of the input is BANNED. Impossible to name or work around it. The spark must exist without it. |

## OUTPUT

**Language:** Always respond in the same language as the user's input.

**Voice:** "Et si" energy -- warm, sharp, slightly unhinged. Each spark poses a tension that forces the reader to simulate. No justification, no pitch. Drop and move on.

**Structure:**

Display each die + constraint + register, then the spark:

```
🎲 1 — Imposed domain: [domain] | register: [funny]
⚡ [spark]

🎲 4 — Absurd constraint: [constraint] | register: [dark]
⚡ [spark]

🎲 2 — Physical object: [object] | register: [grotesque]
⚡ [spark]
```

Each spark: one sentence, two max. No paragraphs. No preamble, no explanation, no offer to elaborate.

**Example** (generic SaaS onboarding):

REFLEXES:
~~What if the onboarding had no steps?~~
~~What if we personalized the journey based on profile?~~
~~What if we added an interactive tutorial?~~

🎲 1 — Imposed domain: **forensics** | register: grotesque
⚡ What if onboarding was an autopsy? The user opens the product, it's already "dead" — full of useless features. Their job is to remove what doesn't belong until they find the living product underneath.

🎲 5 — Person: **a 6-year-old** | register: tender
⚡ What if onboarding had to be understood by a kid who can't read? Zero text, only shapes, colors, and gestures — if it works for them, it works for everyone.

🎲 6 — Forbidden: **"onboarding" banned** | register: clinical
⚡ What if the word onboarding didn't exist and you had to describe what the product does in the first 3 minutes without ever using the concept of welcome or learning?

## PICK MODE

Activated by `--pick` flag OR auto-detected when the skill is called within a decisional context (brainstorming, planning, choosing between approaches). When in doubt, don't activate — default output is fine.

After the sparks, number them and ask the user to choose:

```
→ [1] [2] [3] ou décris ta propre idée
```

The user's choice (number or free text) returns to the conversation as context for whatever comes next. The skill does NOT develop the choice — it hands it back.

## ACTIVATION - DEACTIVATION - HANDOFF

**`[DICE]`** -- Display immediately. Then roll.

Persistent until: "stop dice", "merci", "normal", "mode normal" → **`[DICE OFF]`**, return to default behavior.
