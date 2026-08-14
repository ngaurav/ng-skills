# ng-skills

Agent skills, grouped by category. Each skill is a directory with a `SKILL.md`.

```
<category>/<skill-name>/SKILL.md
```

## marketing

| Skill | What it does |
|---|---|
| [landing-page-copywriter](marketing/landing-page-copywriter/SKILL.md) | Interactive 3-phase process for landing page copy: key message and CTAs, section outline, per-section drafting. |
| [technical-blog-writing](marketing/technical-blog-writing/SKILL.md) | B2B/technical SEO blog posts that read human and rank: de-AI voice, post-type structures, E-E-A-T, sourcing, pre-publish checklist. Site-specific rules live in a per-repo profile generated from [site-profile-template.md](marketing/technical-blog-writing/references/site-profile-template.md). |

## Install

Symlink or copy a skill into your agent's skills directory:

```bash
ln -s "$PWD/marketing/technical-blog-writing" ~/.claude/skills/technical-blog-writing
```
