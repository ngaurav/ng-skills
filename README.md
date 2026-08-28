# ng-skills

Agent skills, grouped by category. Each category has two trees: a private source
tree you edit, and a published tree that gets installed.

```
<category>-src/<skill-name>/SKILL.src.md   <- edit this, never installed
<category>/<skill-name>/SKILL.md           <- generated, committed, installed
```

Sources carry internal notes and learnings that must not reach an installation.
[litprompt](https://github.com/tgvashworth/litprompt) strips them on the way out.

## engineering

| Skill | Version | What it does |
|---|---|---|
| [agent-native-cli](engineering/agent-native-cli/SKILL.md) | 1.0.0 | Design and audit CLIs that agents drive through shell execution: non-interactive execution, uniform `--json` with a stdout/stderr channel contract, enumerating errors, token-efficient schemas, `agent-context` introspection, async job ledgers, profiles. Carries a blocker/friction/optimization rubric for reviewing an existing CLI. |
| [wysiwyg-html-editor](engineering/wysiwyg-html-editor/SKILL.md) | 1.0.0 | Serve a folder of HTML over a local server that lets the user highlight text or click an element and leave an inline comment; the agent edits the page and it reloads with a walkthrough of the changes. Ships `lib/` and `scripts/`. Includes print-fidelity guidance for resumes and reports. |

## marketing

| Skill | Version | What it does |
|---|---|---|
| [landing-page-copywriter](marketing/landing-page-copywriter/SKILL.md) | 1.0.0 | Interactive 3-phase process for landing page copy: key message and CTAs, section outline, per-section drafting. |
| [technical-blog-writing](marketing/technical-blog-writing/SKILL.md) | 1.0.0 | B2B/technical SEO blog posts that read human and rank: de-AI voice, post-type structures, E-E-A-T, sourcing, pre-publish checklist. Site-specific rules live in a per-repo profile generated from [site-profile-template.md](marketing/technical-blog-writing/references/site-profile-template.md). |

## Install

```bash
npx skills add ngaurav/ng-skills              # pick interactively
npx skills add ngaurav/ng-skills --all        # both skills, all agents
npx skills add ngaurav/ng-skills -s technical-blog-writing
```

Or symlink one directly:

```bash
ln -s "$PWD/marketing/technical-blog-writing" ~/.claude/skills/technical-blog-writing
```

Only the published tree is ever installed. `npx skills add` copies whole skill
directories, so anything sitting next to a `SKILL.md` ships with it — which is
why sources live in a separate tree rather than beside their output.

## Build

```bash
make install-tool   # go install github.com/tgvashworth/litprompt@latest
make build          # marketing-src/**/*.src.md -> marketing/**/*.md
make check          # frontmatter contract + imports resolve, no cycles, nothing written
make versions       # every skill declares a semver version:
make verify         # rebuild and fail if the published tree is stale or orphaned
make clean          # delete the published trees (they are fully machine-owned)
```

The published trees **are committed**, so `npx skills add` and plain symlinks
both work without a toolchain.

**Building locally is optional.** CI runs the build on every pull request and
commits the regenerated published tree back to the branch, so a source-only
commit is enough — edit the `*.src.md`, push, and let CI publish. Install the
toolchain when you want to see the output before pushing.

On a push to `main` and on pull requests from forks, CI cannot commit, so it
fails instead with a message to run `make build` yourself.

## Authoring

### Frontmatter

Every `SKILL.src.md` carries:

| Field | Required | What it is |
|---|---|---|
| `name` | yes | Skill directory name. Must match the folder. |
| `description` | yes | When to trigger the skill. Read by the agent at load time. |
| `version` | yes | Semver, `MAJOR.MINOR.PATCH`. Bumped by hand. |
| `build-system` | yes | Marks the published copy as generated. |
| `repo` | no | Source repo, for an installed copy to trace back. |

`make check` fails if any skill is missing `version` or has one that is not
`MAJOR.MINOR.PATCH`.

### Versioning a skill

Versions are per skill, not per repo — each one moves on its own, and nothing
is tagged or released. The number exists so an installed copy can be compared
against this repo and so a changed instruction is visible in a diff.

Bump it in the source, then `make build` to carry it into the published copy:

- **Patch** — wording, typos, a clarified example. Same behaviour.
- **Minor** — a new rule, section, or reference file. Existing behaviour holds.
- **Major** — an instruction that reverses or removes previous guidance, or a
  restructure that changes what the agent does with the same input.

Author-only notes do not move the version: they never reach an installation,
so the published file is byte-identical. Bump when the *published* file changes
in a way that changes behaviour, and update the table above in the same commit.

New skills start at `1.0.0`.

### Author-only notes

Wrap anything that should not ship in an `<!-- @ ... -->` block. litprompt
deletes it at build time, so it costs zero context tokens and never lands in
anyone's install:

```markdown
## Voice

Lead with the benefit, not the feature.

<!-- @
TRIED: "list three benefits per feature" — the model padded every bullet to
three and the copy got repetitive. One benefit, stated concretely, beat it.
-->
```

This is where the accumulated learnings go: anti-practices, approaches that
were tried and rejected, why a rule is worded the way it is, links to the
conversation that produced it. Recording the failure is the point. Without it,
the next pass over the skill re-proposes the thing that already lost.

Each skill keeps a dated **Learnings log** inside an author-only block at the
bottom of its `SKILL.src.md`. Append to it whenever a correction lands.

Standard `<!-- ... -->` comments (no `@`) survive the build, so use those for
anything the agent *should* read.

Two gotchas, both verified:

- **Put the comment on its own line.** A trailing author-only comment at the end
  of a content line swallows the newline and joins that line to the next one.
  Mid-line and own-line are both safe.
- **Never write the closing `-` `-` `>` sequence inside a note**, not even quoted
  as an example. It closes the block early and leaks the rest into the output.

Author-only comments are stripped **inside fenced code blocks too**, which is
what makes them usable in template files: you can annotate a block the agent is
meant to copy verbatim, and the copy comes out clean.

### Why sources use the `.src.md` suffix

`npx skills add` discovers skills by matching the literal filename `SKILL.md`,
walking the whole repo. It does not respect hidden directories, and there is no
ignore file. A source tree containing `SKILL.md` would therefore be discovered
as a second copy of every skill.

The `.src.md` suffix is what makes sources invisible to it. Keep it. CI asserts
that no file named `SKILL.md` exists inside any `-src` tree.

### Shared fragments

Text reused across skills goes in `shared/` and is pulled in with an import.
The imported file's frontmatter is stripped; only the root file's is kept:

```markdown
@[tone](../../shared/tone.md)
```

### Reference files

References mirror the same way, so a skill's whole directory has one source:

```
marketing-src/technical-blog-writing/
  SKILL.src.md
  references/site-profile-template.src.md

marketing/technical-blog-writing/          <- generated
  SKILL.md
  references/site-profile-template.md
```

`SKILL.md` links to the `references/` path, since that is what the agent reads.

### Non-markdown assets

A skill that ships code — `lib/`, `scripts/`, a `LICENSE` — keeps those files in
its source tree too. `make build` copies anything that is not a `*.src.md`
straight across, preserving the path:

```
engineering-src/wysiwyg-html-editor/lib/server.py
  -> engineering/wysiwyg-html-editor/lib/server.py
```

Do not drop assets into the published tree by hand. `make clean` is `rm -rf`
over it on the grounds that it is entirely machine-owned, and a hand-placed
file there would be destroyed with nothing to regenerate it from.

### Adding a skill

1. `mkdir -p marketing-src/<skill-name>`
2. Write `marketing-src/<skill-name>/SKILL.src.md` with frontmatter (`name`, `description`, `version: 1.0.0`, `build-system`; `repo` optional).
3. `make build` — every `*.src.md` under a `-src` tree is picked up automatically,
   and any other file in it is copied across verbatim.
4. Commit the source and the generated output, and add a row (with its version) to the table above.

A new category works the same way: create `<category>-src/`, and `make build`
discovers it from the `*-src` glob with no config change.
