---
name: skill-build-system
description: Organize and update agent skills that use the litprompt source/published split. Use when adding a skill, editing a SKILL.md, seeing a *-src tree, capturing a learning, or deciding what belongs in a published skill versus an author-only note.
version: 1.3.1
build-system: Generated. Edit the source file, not this file.
repo: ngaurav/ng-skills
---

# Skill build system

Skills in this layout have two trees. Edit the source. Install the published
copy. Never the other way around.

## Structure

```
<category>-src/<skill-name>/SKILL.src.md   <- edit, never installed
<category>/<skill-name>/SKILL.md           <- generated, committed, installed
```

- Discover categories from `*-src`. No extra config.
- Sources are never named `SKILL.md`. `npx skills add` matches that filename
  and would ship author notes if a source used it. Keep the `.src.md` suffix.
- References live next to the skill and use the same suffix:
  `references/foo.src.md` builds to `references/foo.md`. Link to the
  published path; that is what the installed agent reads.
- A skill may ship non-markdown files: `lib/`, `scripts/`, a `LICENSE`.
  They live in the source tree like everything else, and `make build` copies
  every file that is not a `*.src.md` across unchanged, same relative path.
  Never place one in the published tree by hand -- `make clean` is `rm -rf`
  over that tree, so a hand-placed file is destroyed with nothing to
  regenerate it from. Check the repo's Makefile actually copies assets before
  relying on it; one that only knows `*.src.md` will drop them silently.
- The published tree is committed so installs work without a toolchain.
- Every generated `SKILL.md` carries a `build-system` frontmatter field:
  this file is generated; edit the source, not this file.
- Every skill carries a `version` frontmatter field, semver, `MAJOR.MINOR.PATCH`.
  See Versioning below.
- Optional: a `repo` frontmatter field (`owner/name`) naming the GitHub
  repo that holds the source. Skip it when the skill is local-only.

## What ships

Published `SKILL.md` is what an installed agent reads. Put only what that
agent needs to do the job.

- A context skill is a reference pack: a short index plus files under
  `references/`. Not a playbook. Not repo-local update steps.
- Author-only notes are HTML comments whose first token is `@`. The builder
  strips them. Put rejected approaches and wording rationale there.
- Each source keeps a dated Learnings log in an author-only block at the
  bottom of `SKILL.src.md`.
- Plain HTML comments (no `@`) survive and are visible to the installed agent.
- Do not write a complete author-only comment in published prose, even inside
  inline code or fences. The builder strips it and leaves holes. Describe the
  form; do not paste one.
- Keep an author-only comment on its own line. A trailing one eats the
  newline. Never put the HTML comment closer inside the note.

## Versioning

Every skill carries a semver `version` in frontmatter, bumped by hand.
Versions are per skill, not per repo: nothing is tagged or released. The
number is what lets an installed copy be compared against its source.

- Patch: wording, typos, a clarified example. Same behaviour.
- Minor: a new rule, section, or reference file. Existing behaviour holds.
- Major: guidance that reverses or removes what came before, or a restructure
  that changes what the agent does with the same input.

New skills start at `1.0.0`. Bump the source, then `make build` carries the
number into the published copy.

A change confined to author-only notes does not bump anything. It never
reaches an installation, so the published file comes out byte-identical.
Bump when the *published* file changes, and say so in the same commit.

## Updating a skill

Only when this repo has `*-src/` trees and a Makefile. An installed copy from
`npx skills add` has neither — do not invent a build there.

1. Edit `*-src/<skill>/...*.src.md`. Never the generated file.
2. Fold the rule into the relevant section. Append a dated line to that
   skill's Learnings log: what was tried and why it failed, not just what won.
3. Bump `version` per Versioning. Author-only edits alone do not bump.
4. `make build`, then commit source and generated output together.

```bash
make install-tool   # once
make build
make check
make verify         # published tree matches a fresh build
```

If the repo's CI builds and commits the published tree back to a pull request,
the local build is optional: commit the source edit, push, and let CI publish.
Check the workflow before relying on it. Two consequences:

- Pull before your next commit. CI may have pushed a rebuild onto the branch,
  and your next push is rejected as non-fast-forward otherwise.
- The rebuild commit needs a skip-ci marker, or the run it triggers waits for
  manual approval and the pull request reports no check.

Either way the source edit is the one that matters, and the generated file is
never edited by hand.

Adding a skill: `mkdir -p <category>-src/<name>`, write `SKILL.src.md` with
`name`, `description`, `version: 1.0.0`, and `build-system` frontmatter
(`repo` optional), `make build`, commit both trees.

<!-- @
## Learnings log

Author-only. Stripped by litprompt, so it costs the running agent nothing.
Append one dated line whenever the user gives a new correction or preference,
or whenever an approach is tried and rejected -- record what was tried and
why it failed, not just what won.

- 2026-08-19: Created as the installable home for layout + update rules.
  Those instructions do not belong on a context skill (npx skills add copies
  SKILL.md into an agent that has no Makefile). This skill is the exception:
  its job is the build system, so the published copy must explain *-src,
  .src.md, and make build.

- 2026-08-19: Do not paste a complete author-only comment into this skill's
  published prose as an example. The builder strips it even inside fences
  and leaves empty backticks. Describe the form in words.

- 2026-08-19: Added a `build-system` frontmatter field on every generated
  skill so an agent reading SKILL.md can see it is generated and should
  edit the source instead.

- 2026-08-19: Added optional `repo` frontmatter (`owner/name`) so an
  installed copy can point at the source GitHub repo. Writing it is not
  required.

- 2026-08-28: Added a required semver `version` frontmatter field and the
  bump rules. Considered a repo-level version or git tags instead: rejected,
  because skills install one directory at a time and a repo number tells an
  installed copy nothing about the skill it actually holds. Author-only edits
  explicitly do not bump, since the published file is byte-identical and a
  version that moves without the install changing is noise.

- 2026-08-28: Noted that CI may own `make build`. The published tree is
  machine-owned, so a workflow that rebuilds and commits it back to the PR
  removes the toolchain from the contributor's path entirely. Worded as a
  conditional: this skill installs into repos that may not have that workflow,
  and telling an agent to skip the build where nothing rebuilds would ship a
  stale published tree.

- 2026-08-28: Moved `make build` into CI: on a same-repo pull request the
  workflow rebuilds and commits the published tree back to the branch. Verified
  by pushing a source-only commit and watching the bot return the regenerated
  file. Two things went wrong first. The bot's own commit queued a run that sat
  at action_required, leaving the PR with no reported check, so that commit now
  carries a skip-ci marker. Then the fix for it put the marker literally in its
  own commit message and skipped its own run.

- 2026-08-28: Hand-mirrored a published SKILL.md by hand when the Go toolchain
  was not available locally, and CI's later rebuild came out byte-identical.
  Recorded, not promoted. It only held because the edit was frontmatter plus
  whole new prose sections, with no author-only block or import anywhere in the
  changed region; an edit touching either would not survive the same treatment.
  Do not read this entry as permission to edit a generated file.

- 2026-08-28: Taught `make build` to mirror non-`*.src.md` files from a source
  tree to the published one, prompted by ng-skills' wysiwyg-html-editor, the
  first skill here that ships code. Considered leaving `lib/` and `scripts/`
  only in the published tree and teaching `clean` to spare them: rejected,
  because it makes the published tree partly hand-owned, which is the exact
  invariant the two-tree split exists to protect. Copying from source keeps
  `clean` an honest `rm -rf` and gets `verify` catching a hand-edited published
  asset for free. `orphans` and `hash-generated` widened from `-name '*.md'` to
  `-type f` in the same pass, or a deleted source asset would linger published
  and undetected.

- 2026-08-28: Repo default workflow permissions differ between the two repos
  using this layout (agentr-context write, ng-skills read). The workflow
  declares contents: write, which should override a read default, but the
  bot-push path has only ever run in the repo whose default was already write.
  Unverified under a read default; the failure mode is loud, not silent.

- 2026-09-03: Moved this skill from agentrhq/agentr-context to ngaurav/ng-skills.
  It is the layout's how-to, not product context, so it does not belong in a
  company context pack. `repo` now points at ngaurav/ng-skills.
-->
