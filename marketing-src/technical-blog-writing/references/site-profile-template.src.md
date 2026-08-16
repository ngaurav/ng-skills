# Site profile template

A site profile records everything about one blog that the universal rules in `SKILL.md` cannot know: where posts live, what the frontmatter schema is, which components render, what the product can actually do, and what has to pass before commit.

**To use:** copy the Template block below to `<repo-root>/.technical-blog-writing/site-profile.md`, fill every `[placeholder]`, and delete any section that does not apply. Do not copy this instruction block or the worked example at the bottom.

**Filling it in:** read the repo before asking the user. Content globs give you the routes, one existing post gives you the frontmatter schema and the component vocabulary, `CLAUDE.md`/`README.md`/`package.json` give you URLs, org, and build commands. Ask the user only for what the repo cannot tell you: the capability sheet, the voice overrides, and which quality gates are mandatory.

**Keep it true.** A stale capability sheet is worse than no capability sheet, because it produces confident false claims. Date it, and re-verify on every use.

<!-- @
Author-only. This file lives in marketing-src/ and builds into marketing/;
edit it here, never the published copy. Notes like this one are stripped,
including inside the fenced template blocks below, so the block an agent
copies out stays clean, and nothing here ships to an installation.

Two rules. Keep a comment on its own line: a trailing author-only comment at
the end of a content line eats the newline and joins that line to the next one.
And never write a comment-closing sequence inside the note itself, not even as
an example, because it closes the block early and leaks the rest into output.
-->


---

## Template

````markdown
# Site profile: [domain]

Last verified [YYYY-MM-DD]. Applies to the `[repo-name]` repo.
These rules override the universal rules in the technical-blog-writing skill where they conflict.

## Site and repo

- Product: [one line, what it is]
- Marketing site: [https://...]
- Docs: [https://... or "none"]
- Source repo: [https://github.com/org/repo]
- Site repo: [https://github.com/org/repo]
- Org handle: [org] ([note any wrong-but-common alternative so nobody uses it])

## Routes and surfaces

[One block per publishing surface. If the site has only one, say so and delete the rest.]

- **`/[route]`**: [editorial intent, what belongs here and what does not]. Files in `[path/to/content]/<slug>.[ext]`. Signed `[author convention]`.
- **`/[route]`**: [editorial intent]. Files in `[path/to/content]/<slug>.[ext]`. Signed `[author convention]`.

[If a seed or README post defines the editorial split canonically, name it here and require reading it first.]

## Frontmatter schema

[Paste the real schema, with per-field constraints as comments. Copy it from an existing post, not from memory.]

```yaml
---
title: "..."          # required, <= 60 chars
description: "..."    # <= 156 chars, keyword-first
date: YYYY-MM-DD      # required, today's actual date
[field]: ...          # [constraint]
---
```

## Allowed components

Only these render. Anything else breaks the build or looks wrong.

- [component or markdown feature] [when to use it, any cap]
- [required closing block, with a copy-pasteable example]

<!-- @
This section is phrased as "name what is NOT included, explicitly" rather than
just listing features. A sheet that only lists what exists still lets the model
infer neighbouring capabilities and state them present-tense. The explicit
negative list is what stops that, so keep the NOT-included bullets even when
they feel redundant.
-->
## Capability sheet (ground truth)

Last verified [YYYY-MM-DD]. Do NOT state anything beyond this as present-tense capability.

- [What the product is, licensing, distribution]
- [Core mechanic, in the words a user would recognize]
- [What IS included, named explicitly. Name the ones people wrongly assume are included.]
- [What is NOT included, named explicitly]
- [Ship status boundary: features that are planned or discussed but must never be stated present-tense]

Re-verify by reading [file], [upstream repo], and any changelog newer than the date above. Update the date when the sheet still matches reality.

## Voice overrides

[Only the places this site departs from the universal rules. Delete if there are none.]

- [Mention/CTA rule, if tighter or looser than "one mention + one soft CTA"]
- [Lead framing: what the headline leads with]
- [Honest framing: the specific problem classes this product does NOT solve, which posts must say out loud]

## Cross-linking

Regenerate the slug list before adding any internal link:

```bash
[the exact ls/find command that emits valid link paths]
```

- Link format: [`/prefix/<slug>`, never bare slugs, never `../`]
- [Any per-surface linking restriction]

## Quality bar (must pass before commit)

```bash
[build command]          # must succeed
[em-dash grep]           # must return 0
[link-resolution check]
[judge or lint pass]
```

- [Any non-command gate, e.g. a canonical-source spot-check]

## Distribution

- [Which channels this site republishes to, with canonical rules]
- [Default subreddits, newsletters, or communities that fit this audience]
- [Any channel that is off-limits and why]
````

---

## Worked example: authsome.ai

The filled profile for the `authsome-web` repo. Use it to see the level of specificity each section needs, then throw it away.

````markdown
# Site profile: authsome.ai

Last verified 2026-05-29. Applies to the `authsome-web` repo.
These rules override the universal rules in the technical-blog-writing skill where they conflict.

## Site and repo

- Product: Authsome, a local-first credential broker for AI agents.
- Marketing site: https://authsome.ai
- Docs: https://authsome.ai/docs (Mintlify, proxied)
- Quickstart (always in NextSteps): https://authsome.ai/docs/quickstart
- Source repo: https://github.com/agentrhq/authsome
- Site repo: https://github.com/agentrhq/authsome-web
- Org handle: agentrhq (NOT agentr-labs, despite what older docs say)

## Routes and surfaces

- **`/blog`**: original team work, product announcements, integration walkthroughs, opinion pieces. Files in `content/blog/<slug>.mdx`. Signed `authors: [priyansh]`.
- **`/article`**: ecosystem coverage, vendor news, CVE roundups, model releases, standards-track drafts, trend writeups, field reports. Files in `content/article/<slug>.mdx`. Signed `authors: [authsome]`.

The seed file `content/article/welcome-to-articles.mdx` is the canonical definition of the editorial split. Read it before writing any /article post.

## Frontmatter schema

Contentlayer, identical for Blog and Article.

```yaml
---
title: "..."                      # required, <= 60 chars
description: "..."                # <= 156 chars, no em-dashes, keyword-first
date: 2026-06-02                  # required, YYYY-MM-DD, today's actual date
tags: [tag1, tag2, tag3]          # 3-4 lowercase, from project taxonomy
authors:
  - priyansh                      # for /blog
  # OR
  - authsome                      # for /article
cover: /path/to/cover.webp        # required
draft: false                      # default false
noindex: false                    # default false, true for legal/internal
summary: "..."                    # optional, distinct from description
---
```

## Allowed components

Only these. Anything else breaks the build or renders ugly.

- Fenced code blocks with a language hint (bash, python, mdx, mermaid).
- Markdown tables.
- `<Admonition type="warning|note|tip">...</Admonition>` for true asides, 3 max per post.
- Closing `<NextSteps>` block, required at the end of every post:

```mdx
<NextSteps>
  <NextStepCard icon="rocket" title="Quickstart" description="..." href="https://authsome.ai/docs/quickstart" />
  <NextStepCard icon="shield" title="..." description="..." href="..." />
</NextSteps>
```

Valid `icon` values: `rocket`, `shield`, `book`, `users`, `layers`.

## Capability sheet (ground truth)

Last verified 2026-05-29. Do NOT state anything beyond this as present-tense capability.

- Open source, MIT licensed, PyPI `authsome`. Local-first credential broker for AI agents.
- Mechanic: `authsome login <provider>` once, then `authsome run -- <agent>` launches the agent under a local HTTPS proxy. Agent env holds only a PLACEHOLDER. Proxy matches destination and swaps in the real header on the outbound request. Library mode: `from authsome.context import AuthsomeContext`.
- 45 bundled providers. **OpenAI IS bundled** (api-key). **GitHub IS bundled** (OAuth2). **Google IS bundled** (OAuth2, Gmail/Calendar/Drive). **Anthropic, AWS, Azure, Stripe are NOT bundled** (use a CUSTOM provider JSON in `~/.authsome/providers/<name>.json`).
- Flows: PKCE, Device Code, Dynamic Client Registration (DCR), API key. NO "service account" flow.
- AWS SigV4 / Azure Managed Identity / GCP Workload Identity Federation are NOT in scope for the broker. Short-lived STS / IdP-issued tokens via OIDC are the right primitive for those workloads.
- Encrypted SQLite vault under `~/.authsome/`. Append-only JSONL audit log.
- A global allow/deny proxy mode per run DOES exist.
- Per-agent policy (deciding which agent may use which provider) does NOT ship today.
- NOT shipped (never state present-tense): per-agent policy engine, multi-tenant vaults, OpenTelemetry export, native MCP tool, Homebrew, GitHub Actions integration, managed SaaS, Windows.

Re-verify by reading `authsome-web/CLAUDE.md`, the upstream repo, and any product changelog newer than the date above. Update the date when the sheet still matches reality.

## Voice overrides

- **At most ONE in-body Authsome mention per /article post**, framed as a credential-angle observation, never a pitch. Plus the closing NextSteps card. For /blog posts, the universal one-mention-one-CTA rule applies as written.
- **Lead with the topic, never with Authsome.** The headline says what happened in the world. The Authsome connection comes in a short closing section.
- **Honest framing.** When the broker pattern does NOT solve the problem cleanly (renderer XSS, AWS SigV4, GCP Workload Identity Federation, JWT-in-the-frontend bugs), the post must say so. "This is a different bug class that a credential broker does not fully solve" is the right energy. Never paper over a gap.

## Cross-linking

Regenerate the slug list before adding any internal link:

```bash
ls authsome-web/content/blog/*.mdx | xargs -n1 basename | sed 's/.mdx$//' | sed 's|^|/blog/|'
ls authsome-web/content/article/*.mdx | xargs -n1 basename | sed 's/.mdx$//' | sed 's|^|/article/|'
```

- Always use the full prefix: `/blog/<slug>` or `/article/<slug>`. Never bare slugs, never `../`.
- 2 to 4 cross-links per post, evergreen-relevant only.

## Quality bar (must pass before commit)

```bash
cd authsome-web && npm run build                      # route prerenders to .next/server/app/{blog,article}/<slug>.html
grep -c '—' content/{blog,article}/<slug>.mdx         # must return 0
```

- Internal-link resolution: every `/blog/<slug>` and `/article/<slug>` referenced exists on disk.
- Independent OpenAI judge pass (`judge_blogs.py`) returns `APPROVE q5` with `agree=true`.
- Canonical source spot-check: re-fetch the primary URL and confirm specific numbers, dates, quotes, and product names match verbatim.

## Distribution

- Republish to dev.to or hashnode with a canonical link back to the original.
- Default subreddits by topic: r/programming, r/devops, r/MachineLearning, r/ClaudeAI, r/aws, r/cybersecurity.
````
