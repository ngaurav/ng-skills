---
name: storyboarding
description: "Storyboard any linear narrative built from discrete units: conference talks, keynotes, board decks, investor pitches, async/email decks, YouTube videos, shorts, demos, and product walkthroughs. Covers setup (format, audience, goal), the key-message tree, one-beat-one-message sequencing, so-what titles, the read-the-titles-only test, structural enhancement moves (cold open, callback, pattern interrupt, the turn), per-beat drafting via Draft-Drain-Refine, and a finishing pass. Use whenever someone wants to plan, structure, outline, or storyboard a presentation, deck, talk, or video, including vague intents like 'I need to present X to my team', 'help me structure my keynote', 'plan my board deck', 'script my YouTube video', or 'what slides should I include'. Phase 1 always produces storyboard.md; Phase 2 produces copy.md for slides or script.md for video."
version: 2.0.0
build-system: Generated. Edit the source file, not this file.
repo: ngaurav/ng-skills
---

# Storyboarding

You are a communication coach helping someone build an audience-centric narrative. Work **conversationally and one step at a time**. Do not dump a finished deck or script in one shot; propose, ask, incorporate, move on.

## The unit is a beat

A **beat** is one unit of the narrative that carries exactly one message. A slide is a beat. A video shot is a beat. A beat has a headline that states its point, a body that supports that point and nothing else, and a position in a sequence that only works in that order.

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

<!-- @ ## Learnings

2026-08-28 — Skill created at 1.0.0. Derived from two prior art versions of a
`slide-outline` skill: v1 at skill-engineers/claude-plugins
(plugins/content-writing/skills/slide-outline) and v2 at
manojbajaj95/claude-gtm-plugin (skills/slide-outline). Diffed the two: v2 adds
exactly two things over v1 — the icebreaker concept (a talk-only opening beat,
asked in Step 1 and placed as Slide 0 in Step 3) and a plugin-specific
Workspace Context block. Everything else is byte-identical.

Named `storyboarding`, not `slide-outline` or `slide-storyboarding`. The skill
covers video as a first-class format; a name with "slide" in it suppresses
video triggering and re-anchors every future edit on decks. The generic name
was chosen for retrieval accuracy, not tidiness.

The unit is a "beat", not a "slide". Load-bearing decision. The originating
insight was that a video is a sequence of frames and a frame is a slide — so
the storyboarding logic is format-independent and only the *contents* of a
unit differ. If the trunk said "slide", video would be a permanent bolt-on and
every line would need "slide (or frame)". Rejected "unit" (too abstract),
"card" (collides with the card format used to present a beat), and "frame"
(reads as video-only, the mirror of the problem being solved).

Reference layout rejected: a 2 formats x 3 concerns matrix (format / enhancement
/ finishing touches per format = 6 files). Two defects. First, it has no home
for shared writing craft — DDR, the five language principles, so-what headlines
— which is format-independent and would have to be duplicated into a video file
or left mis-filed under slides. That is ~60% of the prior art's
drafting-polishing.md. Second, per-format enhancement files hide the thesis:
a talk's icebreaker and a video's cold open are the same move in two costumes.
One tagged catalog makes the correspondence visible and is how new moves get
found. Landed on craft / slides / video / enhancements = 4 files.

Finishing touches deliberately NOT a separate file per format. The prior art
bundled drafting and polishing into one reference for a good reason: the polish
checklist is mostly "did you actually apply the drafting principles". Shared
checks live in craft.md; format-specific checks ride along with the anatomy
they only make sense next to. If a format's checklist outgrows its file, split
it then — the SKILL.md link is one line, so deferring is cheap and doing it up
front is not.

The three slide subformats (talk / boardroom / async) are a table inside
slides.md, not three files. They share one anatomy and differ only in
tolerances: density, whether speaker notes exist, whether Detail beats are
allowed. Explicitly requested; also correct.

Enhancements moved to their own step (Step 4), after sequencing and before
drafting. v2 smeared the icebreaker across Step 1 (ask) and Step 3 (place),
which meant the user chose a structural move before there was any structure to
attach it to. A cold open changes the shape of the sequence, not the copy, so
it belongs after the sequence exists and before any copy is written.

Dropped v2's Workspace Context block. It hardcodes strategy/brand.md,
about/me.md, content/ideas.md, content/calendar.md — that is the gtm-plugin's
workspace layout, not this repo's. The technical-blog-writing skill in this
repo solves the same problem correctly (walk up to the repo root looking for a
profile directory, offer to generate one when absent). If this skill ever needs
per-user context, copy that pattern rather than v2's.

Also dropped v2's "Operating Contract" paragraph — generic
self-containment boilerplate that applies to every skill in any repo and so
tells the agent nothing at the point of use.

Filed under marketing/, not a new content/ category. Author's rationale: as the
field gets more technical, developers have to know marketing and marketers have
to know code — marketing is read here from a developer's perspective, so a
talk or a video storyboard sits inside it rather than beside it. Recorded
because the category looks arbitrary from the outside and this is the reason
not to "fix" it later.

2026-08-28 — 2.0.0. Phase 2 restructured into a dispatch. 1.0.0 sent every
format to a single `copy.md`, which flattened a real difference: a video's
Phase 2 product is a spoken script on a timecode, delivered close to verbatim,
while slide copy is headline/body/subtitle/footnote plus notes that are
deliberately NOT a script. Same phase, different artifact. Video now emits
`script.md`, slides emit `copy.md`, and Phase 2 is explicitly the wrapper where
the format reference is selected.

The clean statement of the split is: Phase 1 asks what the beats are and in
what order, which no format changes; Phase 2 asks what is in a beat, which is
entirely a format question. That is why the routing table moved from "read it
first" to "it is the Phase 2 entry point", and why the format reference is no
longer loaded during Phase 1.

Two things did not move, against the tidiness of the split. Video durations
stay in Phase 1 because a runtime target constrains the *sequence*, not the
wording — budgeting it after the script is written means rewriting the script.
Slide beat type (Normal/Detail) stays for the same reason: it governs how many
beats fit and whether the subformat tolerates them. Both are handled as "the
format adds one field to the beat card", one sentence, rather than forking
Step 3. Resisted pushing them into Phase 2 purely to make the boundary look
clean — the boundary is about what a beat contains, and both of these are
about how many beats there are.

Drafting loops and output templates moved out of SKILL.md into the format
references. SKILL.md now owns only the two rules that hold in both branches
(draft one beat at a time; do not restructure in Phase 2). The second rule is
new and falls directly out of the wrapper framing — once Phase 1 owns
structure outright, editing structure during drafting is a defect that
desynchronises storyboard.md from the output, and it needed saying.
-->
