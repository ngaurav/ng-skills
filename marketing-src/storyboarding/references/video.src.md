# Video

A beat is a shot: one visual state, held for a fixed number of seconds, doing
one job. Read this with [craft.md](craft.md) at Step 5.

The difference that changes everything: **a beat has a duration**. A slide
waits for you; a shot does not. Every beat spends a budget you cannot get
back, and the audience can leave at any moment.

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

## Working with the beat sheet

The storyboard is the edit plan. Keep durations and visuals machine-readable
in `storyboard.md` so the beat sheet can be handed straight to an editor —
human or agentic — without a translation step:

```markdown
### Beat 4: Latency drops to 40ms
- **Framework tag:** Solution
- **Duration:** 6s
- **Visual:** screen recording, dashboard, latency panel
- **On-screen text:** 40ms
- **Voiceover:** "Same query, same data — forty milliseconds."
- **Audio note:** music drops out on the number
```

Estimate total runtime by summing durations, and check it against the target
before drafting a single line of voiceover. Discovering a 12-minute script
was meant to be 5 minutes is a storyboard failure, and it is cheap to catch
here and expensive to catch in the edit.

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
