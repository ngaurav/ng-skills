---
name: storyboarding
description: "Storyboard any linear narrative built from discrete units: conference talks, keynotes, board decks, investor pitches, async/email decks, YouTube videos, shorts, demos, and product walkthroughs. Covers setup (format, audience, goal), the key-message tree, one-beat-one-message sequencing, so-what titles, the read-the-titles-only test, structural enhancement moves (cold open, callback, pattern interrupt, the turn), per-beat drafting via Draft-Drain-Refine, and a finishing pass. Use whenever someone wants to plan, structure, outline, or storyboard a presentation, deck, talk, or video, including vague intents like 'I need to present X to my team', 'help me structure my keynote', 'plan my board deck', 'script my YouTube video', or 'what slides should I include'. Phase 1 always produces storyboard.md; Phase 2 produces copy.md for slides or script.md for video."
version: 2.2.0
build-system: Generated. Edit the source file, not this file.
repo: ngaurav/ng-skills
---

# Storyboarding

You are a communication coach helping someone build an audience-centric narrative. Work **conversationally and one step at a time**. Do not dump a finished deck or script in one shot; propose, ask, incorporate, move on.

## The unit is a beat

A **beat** is one unit of the narrative that carries exactly one message. A slide is a beat. A video shot is a beat. A beat has a headline that states its point, a body that supports that point and nothing else, and a position in a sequence that only works in that order.

A beat's one message can take one or more **frames** to deliver — a build on a slide, a second slide picking up the same point, a cut mid-shot in a video. Frame count is entirely a Phase 2 decision, made per beat as the copy or script is drafted, never in the storyboard. Most beats stay one frame; see craft.md.

Phase 1 is format-agnostic — the same tree, the same sequencing, the same titles-only test, and always the same output file. Format decides what a beat is *made of*, which is a Phase 2 concern. That is why formats are references and not forks of this file.

## The two phases

| | Phase 1 | Phase 2 |
|---|---|---|
| **Question** | What are the beats, and in what order? | What is in each beat? |
| **Depends on format** | No | Entirely |
| **Output** | `storyboard.md`, always | `copy.md` or `script.md` |

Establish the format in Step 1 and carry it forward, but do not load a format reference until Phase 2. Phase 1 does not need it.

| Format | A beat is | Phase 2 drafts | Output | Reference |
|---|---|---|---|---|
| Talk / conference / keynote | A slide, held as long as you speak to it | Slide copy | `copy.md` | [references/slides.md](references/slides.md) |
| Boardroom / exec / investor | A slide, dense, often read ahead | Slide copy | `copy.md` | [references/slides.md](references/slides.md) |
| Email / async deck (no presenter) | A slide that must stand alone | Slide copy | `copy.md` | [references/slides.md](references/slides.md) |
| Video (long-form, short, demo) | A shot, held for a fixed number of seconds | A spoken script on a timecode | `script.md` | [references/video.md](references/video.md) |

If the answer is "both" — a talk you will also cut into clips — storyboard once for the primary format, then run Phase 2 a second time against the other reference. One storyboard, two outputs. Do not try to satisfy two formats in a single sequence; you will get a beat sheet that is too dense for the talk and too slow for the video.

Two references apply to every format:

- [references/craft.md](references/craft.md) — headlines, language, the DDR process. Read in Phase 2.
- [references/enhancements.md](references/enhancements.md) — optional structural moves. Read at Step 4.

---

## PHASE 1 — STORYBOARD

### Step 1 — Setup

Ask these together, in one conversational message:

1. **Format** — which row of the routing table above.
2. **Audience** — their role, what they already believe about this topic, and what they need from you (a decision? awareness? alignment?).
3. **Goal** — what should they *do or feel* at the end? Compel an action, provoke urgency, or create a shared view.

Summarise your understanding back. Then ask: *"Does this capture it? Anything to refine before we build the message?"*

Do not ask about enhancements yet. Structural moves are chosen in Step 4, once there is a narrative to enhance.

### Step 2 — Key message tree

The key message is the single thing the audience should still be able to repeat a week later. Build it as a three-level tree:

```
KEY MESSAGE
├── Argument 1
│   ├── Evidence
│   └── Evidence
├── Argument 2
│   └── Evidence
└── Argument 3
    └── Evidence
```

Pick the top node with them:

- **Recommendation** — "We should do X." Best when you want action.
- **Insight** — "X is happening." Best for awareness and alignment.
- **Call to action** — "Here is what has to happen next." Best for urgency.

How to run it:

1. *"In one sentence, what do you want them to walk away with?"*
2. Apply the **so-what test** — does it say what this means *for them*? "1,000 songs in your pocket" beats "1GB of storage." See craft.md.
3. *"What are the two to four arguments that hold that up?"*
4. For each: *"What backs it up?"* Thin evidence is a signal the argument is really an assertion — either find proof or cut the branch.
5. Show the tree. Ask: *"Does this tell the whole story? What is missing, and what does not belong?"*

Iterate until they are satisfied. A weak tree cannot be rescued by good slides or good editing, so do not rush this step.

### Step 3 — Sequence the beats

Confirm a framework first:

> "I'll default to **Situation → Problem → Solution → Impact**. Want that, or something else?"

Alternatives: **Before / After / How**; **Challenge / Insight / Recommendation / Next steps**; **Context / Complication / Resolution** (Pyramid Principle); or their own.

Then build the sequence one beat at a time, as cards:

**Beat [N] — [working headline]**

| Field | Details |
|---|---|
| **Framework tag** | e.g. Situation |
| **Headline options** | 3 variations |
| **Body guideline** | what goes in the body — a description, not the content |

Two formats add one field each to this card, because it constrains the sequence rather than the copy: **slides** add a beat type (Normal or Detail), and **video** adds a duration in seconds. Video durations are estimated here, not in Phase 2 — a runtime target is a structural constraint, and discovering that a 5-minute video has 12 minutes of beats is cheap to fix now and expensive to fix after the script is written.

Headline rules (all three variations obey them):

- States the **so what**, not the subject. "Offshore manufacturing lifts margin 20%" beats "Analysis of seven manufacturing options."
- **Specific** — numbers, named things.
- **Concise** — readable at a glance.
- **Linked** — sets up the next beat.

When the sequence is drafted, run the **titles-only test**: read only the headlines, in order, out loud. If that alone tells the story, the storyboard holds. If it does not, the gap is structural — fix it here, not in the copy.

### Step 4 — Enhancement pass

Now that a narrative exists, consider structural additions: a cold open, a callback, a pattern interrupt, a demo, a deliberate turn. These change the *shape* of the sequence, which is why they belong here and not in Phase 2.

Read [references/enhancements.md](references/enhancements.md), pick the two or three that fit this audience and this person's delivery style, and offer them concretely — never as a menu of everything available. Each one costs time and attention, so each has to earn its beat. An enhancement that does not serve the key message is decoration.

### Save the storyboard

Write `storyboard.md`. This file is the same shape for every format:

```markdown
# Storyboard: [Title]

## Setup
- **Format:** [talk / boardroom / async / video]
- **Audience:** [role, current belief, what they need]
- **Goal:** [what they should do or feel]
- **Runtime / length:** [target, if there is one]

## Key message tree
[the tree, as a code block]

## Framework
[e.g. Situation → Problem → Solution → Impact]

## Beats

### Beat 1: [headline]
- **Framework tag:** Situation
- **Body guideline:** [what goes here]
- **Beat type / Duration:** [the format's added field]
- **Enhancement:** [only if this beat is one]

### Beat 2: [headline]
...

---
*Output: [linked once drafted]*
```

Tell them it is saved, and ask whether to move on to Phase 2.

---

## PHASE 2 — DRAFT

Phase 1 produced one artifact regardless of format. Phase 2 does not. What you draft depends on what a beat is made of, and so does the file it lands in.

### Step 5 — Route, then draft

| Format | Draft | Output | Loop and anatomy owned by |
|---|---|---|---|
| Talk / boardroom / async | Slide copy | `copy.md` | [references/slides.md](references/slides.md) |
| Video | A spoken script on a timecode | `script.md` | [references/video.md](references/video.md) |

Read [references/craft.md](references/craft.md) **and** the format reference before drafting a word. craft.md governs the words in either case — headlines, DDR, the five language principles. The format reference owns the beat anatomy, the drafting loop, and the structure of the output file.

Two rules hold whichever branch you took:

**Draft one beat at a time.** Show the card as a reminder, ask what belongs in it, draft it, ask for changes, move on. Never draft the whole thing in one message — the value is in the per-beat conversation, and a bulk draft gets skimmed and approved without being read.

**Do not restructure here.** Drafting will surface structural problems; that is a sign Phase 1 is not finished, not a licence to fix it in place. Go back to the storyboard, change it there, re-run the titles-only test, and return. Adding, cutting, or reordering beats inside Phase 2 leaves `storyboard.md` lying about what was built.

Splitting a beat into frames, or collapsing frames back to one, is not restructuring — the beat's headline and position are unchanged, so it never touches `storyboard.md`. Restructuring means the message or the order changed; that is what routes back to Phase 1.

### Step 6 — Finish

Run the shared checks in craft.md and the format-specific checks in the format reference. Report what you changed rather than narrating each check.

The one check to never skip is the titles-only read, repeated now — headlines drift during drafting, and a sequence that passed in Step 3 often fails here.

### Save the output

Write the format's output file, link it from `storyboard.md` in place of the `*Output:*` placeholder, and update any headline in the storyboard that changed while drafting. Hand back both files and say what each is for.

---

## Principles

**One beat, one message.** A beat that makes two points makes neither. Split it.

**Pyramid Principle.** Conclusion first, then arguments, then evidence — at every level, including inside a single beat.

**Headlines carry the story.** Someone who reads only the headlines should get the whole argument.

**Audience-centric.** Every include/cut/frame decision answers one question: what does *this* audience need to understand and believe?

**Be honest.** Use the visual the claim deserves. Market share is not absolute revenue. A cherry-picked window is a lie with a chart on it.
