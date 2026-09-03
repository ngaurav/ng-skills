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
