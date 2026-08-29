# Slides

A beat is a slide. Read this with [craft.md](craft.md) in Phase 2.

Phase 1 adds one field to the beat card: **beat type**, Normal or Detail
(below). It belongs in the storyboard because it governs how many beats
fit and whether the subformat tolerates them.

Phase 2 output for every slide subformat is **`copy.md`**.

## Anatomy

**Headline** — the slide's stated point. States the so-what. Carries all four
qualities in craft.md. It is always written down, in `copy.md` and in the
titles-only test — but it is not always printed on the slide. For a talk, a
cold open or another image-only beat can deliver the headline verbally while
the slide shows nothing but the visual; mark that beat's headline "spoken
only" rather than adding on-screen text competing with the image.

**Body** — the evidence: data, chart, diagram, bullets, image. Every element
supports the headline and only the headline. If something on the slide argues
for a different point, it belongs on a different slide.

**Subtitle** *(Detail beats only)* — a short orienting label that tells the
reader how to read the body. It clarifies structure or scope; it never
restates the headline. "By region, indexed to 2024" is a subtitle. "Revenue
grew" is a second headline and does not belong.

**Footnote** *(optional)* — source, method, or caveat that would clutter the
body. Required on any slide carrying data, a quote, or third-party analysis.

**Speaker notes** *(presented formats only)* — key phrases, transitions, the
one number to emphasise. Not a script. Omit entirely for async decks; the
slide has to do that work itself.

## Frames

Default is one frame: the Body above, whole, on one slide. Reach for more
when the body needs to build — an animation within one slide (a chart
entering, then a second series joining it), or a second slide picking up the
same point where the first left off. Read craft.md's Frames section first;
this is the slide-specific shape of it.

A multi-frame slide keeps one Headline, Subtitle, Footnote, and Speaker notes
for the whole beat — those describe the beat, not any one frame — and splits
only the Body into numbered frames, each with its own content and, only when
it says something new, its own short **frame text**: a qualifier or caveat
shorter than a headline, landing as the frame does. State how a frame
arrives only when it is not a plain cut — "fades in once the first chart
settles," "squeezes left as the second chart enters." A hard cut to the next
slide needs no note at all.

## Beat types

**Normal** — one clear message, minimal body. Works everywhere.

**Detail** — heavier supporting content: a full table, a breakdown, a
multi-series chart. Costs the audience reading time, so it buys silence while
they read.

Default to Normal. Reach for Detail only when the argument genuinely needs the
density, and check afterwards whether it can be reduced back to Normal with
the detail moved to an appendix.

## The three subformats

Same anatomy, different tolerances.

| | **Talk / conference** | **Boardroom / exec** | **Email / async** |
|---|---|---|---|
| **Presenter** | Yes, you own the room | Yes, but they interrupt | No — it reads alone |
| **Detail beats** | Avoid. One at most | Sparingly, with a walkthrough | Fine, this is their format |
| **Body density** | Very low — one idea, often one image | Medium | High, it is the only channel |
| **Words per slide** | Under ~15 | Under ~40 | Whatever the argument needs |
| **Speaker notes** | Yes | Yes | Omit |
| **Reading order** | You control it | They skip ahead | Fully self-serve |
| **Appendix** | Rarely | Expected, often large | Expected |
| **Beat count** | ~1 per minute, fewer is better | Fewer, denser | Unconstrained |

**Talk.** The audience cannot read and listen at once. Every word on the slide
is a word they are not hearing from you. Images and single numbers beat
bullets. If a slide would work as a handout, it is too dense for a stage.
Not every beat needs printed on-screen text at all — a cold open is often a
single image (a photo, a meme, a screenshot) with the headline delivered as
the first thing you say, not as a caption. Default to a printed headline;
drop it only when the image alone lands the point and text would just be
noise on top of it.

**Boardroom.** Assume they read ahead, skip forward, and interrupt at the
number they care about. The headline sequence has to survive being read out of
order. Put the recommendation early — Pyramid Principle, not a reveal. Anticipate
the two objections you would raise in their seat and answer them on the slide.

**Async.** No presenter, so the deck is the argument. Anything you would have
said out loud goes on the slide or in a footnote. Ambiguity gets resolved
against you when you are not in the room to correct it.

## Body design

Match the visual to the claim:

| Claim | Form |
|---|---|
| Comparison between categories | Bar chart |
| Change over time | Line chart |
| Composition of a whole | Stacked bar, or a table if precision matters |
| Correlation | Scatter — only if you can defend the implied causation |
| Process or flow | Diagram with directional arrows |
| A single decisive number | The number, large, with its unit and comparison |
| Qualitative evidence | A quote, attributed, verbatim |

Two rules that catch most problems:

- **A chart with one takeaway should say it.** Annotate the point on the
  chart. Do not make the audience find it.
- **A slide with more than about six body elements is a Detail beat** whether
  you intended it or not. Either commit to that and give it reading time, or
  cut it down.

## Phase 2 — drafting slide copy

One slide at a time. Show the beat card from `storyboard.md` as a reminder,
ask what content, data, or argument belongs in the body, then shape it with
Draft → Drain → Refine (craft.md).

Present each drafted slide with its full anatomy, omitting the parts the
subformat does not use:

**Slide [N]**

- **Headline** — carries all four qualities from craft.md. Note "(spoken
  only)" when a talk beat's headline is delivered verbally rather than
  printed on the slide — the image-only cold-open case above.
- **Body** — the supporting content.
- **Subtitle** — Detail beats only.
- **Footnote** — wherever data, a quote, or outside analysis appears.
- **Speaker notes** — presented formats only. Key phrases and transitions,
  never a script.

Ask for changes, incorporate them, move to the next slide. When a beat needs
more than one frame, draft all of them together in this same turn — see
Frames above — rather than treating each frame as its own beat.

### Output: `copy.md`

```markdown
# Slide Copy: [Title]

> Storyboard: [storyboard.md](./storyboard.md)
> Format: [talk / boardroom / async]

---

## Slide 1: [headline]

**Body:**
[the body content]

**Subtitle:** [Detail beats only]

**Footnote:** [if any]

**Speaker notes:** [presented formats only]

---

## Slide 2: [headline]
...
```

A multi-frame slide replaces `**Body:**` with numbered frames; everything
else stays once per beat:

```markdown
## Slide 3: [headline]

**Frame 1:**
[body content]

**Frame 2** (fades in after ~2s):
[body content]
**Frame text:** [only if this frame says something new on screen]

**Subtitle:** [Detail beats only]

**Footnote:** [if any]

**Speaker notes:** [presented formats only]
```

## Slide-specific finishing checks

Run these after the shared checks in craft.md.

- **Detail beats are appropriate to the subformat.** No Detail slides in a
  talk. Any Detail slide that could be Normal, is.
- **Subtitles guide, not restate.** Every subtitle tells the reader how to
  read the body. Delete the ones that just say the headline again.
- **Footnotes exist wherever data, quotes, or outside analysis appear.**
- **Speaker notes match the format.** Present for talks and boardroom, absent
  for async, never a verbatim script.
- **Word count fits the subformat's row** in the table above.
- **Visuals are honest.** Axis, window, and chart type per craft.md.
- **The appendix holds what was cut,** rather than the cut material creeping
  back into the main sequence.
- **Frame count matches the beat's need.** A single-frame beat carries no
  "Frame 1" label or transition note; a multi-frame beat only names a
  transition where it isn't a plain cut.
