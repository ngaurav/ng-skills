# Video

A beat is a shot: one visual state, held for a fixed number of seconds, doing
one job. Read this with [craft.md](craft.md) in Phase 2.

The difference that changes everything: **a beat has a duration**. A slide
waits for you; a shot does not. Every beat spends a budget you cannot get
back, and the audience can leave at any moment.

That has one consequence per phase. **Phase 1** adds a duration field to the
beat card — estimated in the storyboard, not here, because a runtime target
constrains the sequence and budgeting it after the script exists means
rewriting the script. **Phase 2** outputs `script.md`, not `copy.md`: a
video's Phase 2 product is a spoken script on a timecode, delivered close to
verbatim.

## Anatomy

**Duration** — seconds. Estimate it during storyboarding, not after. A beat
without a duration is a slide in disguise.

**Visual** — what is on screen: talking head, screen recording, b-roll, motion
graphic, or a full-frame text card.

**On-screen text** — the headline, when there is one. Same four qualities as a
slide headline (craft.md), but shorter — it has to be readable in the time the
shot is up. Roughly: one line for under 3 seconds, two lines for under 6.

**Voiceover / spoken line** — the actual words, written to be *said*. Unlike
slide speaker notes, this is a script and it is delivered close to verbatim.
Write it out in full.

**Audio note** *(optional)* — music change, a beat drop, a sound effect, or a
deliberate silence. Silence is a tool; mark it where you want it.

The spoken line and the on-screen text should not be the same words. Text that
duplicates the voiceover makes the viewer read something they are already
hearing, which is slower than either alone. Use text for the number, the name,
or the term — the things that are hard to catch by ear.

## Pacing

**The first three seconds decide the rest.** Retention charts fall off a cliff
before most creators have finished saying hello. The first beat is a hook, not
an introduction — no logo, no "hey guys", no agenda. Open on the most
interesting thing you have.

**No beat runs longer than about 8 seconds without a visual change.** A cut, a
zoom, a graphic appearing, b-roll over the same voiceover — something. The
change resets attention; its absence is what makes a video feel long
regardless of its actual length.

**Cut the dead air.** Breaths, restarts, "um", the pause before a sentence
starts. Tight audio is most of what separates amateur from professional.

**Vary beat length deliberately.** A run of same-length beats becomes a
metronome and the viewer stops hearing it. Follow three quick beats with one
that breathes.

## Subformats

| | **Long-form (~16:9)** | **Short (vertical, <60s)** | **Demo / walkthrough** |
|---|---|---|---|
| **Hook budget** | First 15 seconds | First 1–2 seconds | First 5 seconds |
| **Beat length** | 5–15s typical | 1–3s typical | 10–30s, driven by the action |
| **Chapters** | Yes, with markers | No | Yes |
| **On-screen text** | Supporting | Often carries the whole message | Labels and callouts |
| **Captions** | Recommended | Mandatory — assume muted | Recommended |
| **Structure** | Full framework | One point, one payoff | Task order, not argument order |

**Long-form.** The full storyboard framework applies. Chapter markers are
section dividers; name them with so-what headlines, not "Part 2".

**Short.** One beat of the key-message tree, not the whole tree. Pick the
single strongest argument and give it a payoff. Assume it plays muted in a
feed, so on-screen text has to carry the message alone. Everything is
compressed but nothing is skipped — there is still a hook, a point, and a
landing.

**Demo.** Sequence follows what the user actually does, in order, which may
not match the argument order. Never narrate the interface ("now I click the
blue button"); narrate the intent ("now I connect the data source") and let
the screen show the click. Cut every load and wait.

## Phase 1 — what video adds to the storyboard

The storyboard is the edit plan. Keep durations and visuals machine-readable
in `storyboard.md` so the beat sheet can be handed straight to an editor —
human or agentic — without a translation step:

```markdown
### Beat 4: Latency drops to 40ms
- **Framework tag:** Solution
- **Duration:** 6s
- **Visual:** screen recording, dashboard, latency panel
- **Body guideline:** the before/after number, held long enough to read
```

Duration and visual live here because both constrain the sequence. The
voiceover, the on-screen text, and any audio note are Phase 2 and belong in
`script.md` — writing them into the storyboard is how the two files start
disagreeing about what the video says.

Estimate total runtime by summing durations, and check it against the target
before drafting a single line of voiceover. Discovering a 12-minute script
was meant to be 5 minutes is a storyboard failure, and it is cheap to catch
here and expensive to catch in the edit.

## Phase 2 — drafting the script

One beat at a time, in order, because a script's rhythm depends on what came
immediately before it.

For each beat, write the **voiceover first** and the on-screen text second.
The spoken line is the load-bearing part; text supports it. Doing it the other
way produces voiceover that reads a slide aloud.

Then read the voiceover out loud against the beat's duration. This is the
whole quality bar for a script and it is not optional:

- **Over the duration?** Cut words, not the point. Roughly 2.5 words per
  second at a natural pace, slower for anything the viewer has to absorb.
- **Stumbled on it?** Rewrite the sentence. If you cannot say it cleanly,
  neither can the person recording it.
- **Reads like prose?** It will sound like prose. Sentences are shorter than
  they would be on a page, and fragments are fine.

Apply Draft → Drain → Refine (craft.md) to the spoken line as you would to any
other copy. Drain matters more here than anywhere else in this skill, because
every surviving word costs runtime.

### Output: `script.md`

Carry running timecodes so the script doubles as an edit plan.

```markdown
# Script: [Title]

> Storyboard: [storyboard.md](./storyboard.md)
> Format: [long-form / short / demo] · Runtime: [sum of durations]

---

## Beat 1: [headline] · 0:00–0:06 · 6s

**Visual:** [talking head / screen recording / b-roll / motion graphic]
**On-screen text:** [if any]

**Voiceover:**
> [the words, verbatim, as they will be said]

**Audio note:** [music, silence, effect — if any]

---

## Beat 2: [headline] · 0:06–0:11 · 5s
...
```

Recompute the running timecodes whenever a duration changes, and check the
total against the target before handing the script over.


## Video-specific finishing checks

Run these after the shared checks in craft.md.

- **The first beat is a hook**, and it works with no prior context.
- **Total runtime matches the target.** Sum the durations.
- **No beat exceeds ~8 seconds without a visual change.**
- **It works muted.** Read only the on-screen text — for a short, that alone
  must carry the message.
- **On-screen text does not duplicate the voiceover.**
- **Voiceover is written to be spoken.** Read it aloud; anything you stumble
  on gets rewritten. Sentences are shorter than they would be on a page.
- **Every beat earns its seconds.** The honest question for each: if this were
  cut, would the argument survive? Cut the ones where it would.
- **Beat lengths vary** rather than settling into a metronome.
- **Captions exist** where the subformat requires them.
