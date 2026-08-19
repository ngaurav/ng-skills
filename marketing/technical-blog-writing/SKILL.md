---
name: technical-blog-writing
description: "Write and improve B2B/technical SEO blog posts (listicles, reviews, comparisons, pricing pages, how-to guides, reference posts) that read like a sharp human practitioner and rank top-3 in 2026 search and AI Overviews. Covers de-AI voice, post-type structure, E-E-A-T, sourced data, FAQ/ItemList schema, internal linking, competitive gap audits, images, video, mermaid diagrams, AI-Overview optimization, real-time research tooling (EXA MCP, reddit-mcp, github-mcp), distribution (republishing with canonicals), and a pre-publish checklist. Use whenever drafting, rewriting, expanding, or auditing a blog/article. Universal rules apply to every post; a per-site profile in the blog repo's .technical-blog-writing/ folder carries site-specific routes, frontmatter, capability sheet, and quality bar, and overrides the universal rules where they conflict."
build-system: Generated. Edit the source file, not this file.
repo: ngaurav/ng-skills
---

# Technical Blog Writing

Write the post a smart, busy practitioner in the target role would actually find useful, then make it the most complete answer on the web for its keyword. Two goals at once: read like a real human wrote it (E-E-A-T), and give Google/AI-search the structure they reward. If a line could appear in a generic "thought leadership" template, rewrite it.

When invoked: identify the **post type** (listicle/roundup, single-product review, head-to-head comparison, pricing/cost, how-to/guide, or reference), apply that type's structure plus the universal rules below, draft or edit, then run the pre-publish checklist. Do not narrate the rules back unless asked.

Throughout, "the product" = whatever site/company you are writing for. Keep the product in a positive but honest light: recommend it where it genuinely fits, name one or two real tradeoffs (never self-sabotage), and make sure **every post names the product once and has one soft CTA** so readers do not leave without a path to act.

## Site profile (do this first, before drafting or editing)

Everything below is universal. Everything a specific blog needs on top of it (routes, frontmatter schema, which components render, what the product can truthfully claim, what has to pass before commit) lives in a **site profile** in the blog's own repo.

**Step 1: find it.** Walk up from the current directory looking for `.technical-blog-writing/`. Stop at the repo root (the directory holding `.git`). The user is often several folders deep inside the site repo, so never assume the current directory is the root.

```bash
# from anywhere inside the blog repo
git rev-parse --show-toplevel
ls "$(git rev-parse --show-toplevel)/.technical-blog-writing/"
```

**Step 2a: found it.** Read `site-profile.md` and `learnings.md` before writing a word. The profile overrides the universal rules wherever the two conflict. Re-check the "Last verified" date on the capability sheet; if it is stale relative to the repo's changelog, verify before claiming anything present-tense.

**Step 2b: not found.** Say so and offer to generate one:

> No `.technical-blog-writing/` in this repo. I recommend generating a site profile first, so posts get the right frontmatter, components, internal-link paths, and product claims. Want me to?

If the user says yes, build it from [references/site-profile-template.md](references/site-profile-template.md):

1. **Recon the repo before asking anything.** Glob the content directories to get the routes and file paths. Read one existing post end to end for the frontmatter schema and the component vocabulary actually in use. Read `CLAUDE.md`, `README.md`, and `package.json` for URLs, org handle, and build/lint commands.
2. **Pre-fill every section you inferred.** Mark each inferred value so the user can correct it.
3. **Ask only for what the repo cannot tell you:** the capability sheet (what the product does and, more importantly, does NOT do), any voice overrides, and which quality gates are mandatory before commit.
4. **Write `.technical-blog-writing/site-profile.md`** and have the user confirm the capability sheet line by line. That section is the one that causes false claims when it is wrong.
5. **Create an empty `.technical-blog-writing/learnings.md`** next to it, so later corrections have somewhere to land.

**Step 2c: user declines.** Write the post using the universal rules alone, then name what you had to guess in your response: frontmatter inferred from an existing post, components inferred from usage, internal links unverified. **With no capability sheet, make no product-capability claim at all.** Describe the product only in terms the repo's own README states verbatim.

### Learnings split

- A correction about **this site** (its schema, its taxonomy, its voice, a build gotcha) appends a dated line to `<repo-root>/.technical-blog-writing/learnings.md`.
- A correction about **blog writing in general** belongs in this skill itself, in the ng-skills repo. Edit `marketing-src/technical-blog-writing/SKILL.src.md` there (never the generated `marketing/` copy): fold the rule into the relevant section, and append a dated line to the author-only Learnings log at the bottom of the source.

When in doubt, ask which one it is. Site learnings in the shared skill are how the skill gets polluted with one company's conventions.

## Hard rules (never break)

- **No em-dashes.** Ever. Use commas, periods, parentheses, or two sentences.
- **No curly/smart quotes.** Straight ASCII quotes only.
- **Never fabricate.** No invented stats, prices, quotes, cases, studies, or URLs. A number is only stated as fact if it is the product's own/confirmed figure, OR it carries a **named, dated, third-party source you verified returns HTTP 200** (curl with a real browser User-Agent; many sites 403 to bots but are live, so name them without a link in that case). If a price/number is unknown, write "quote-based / on request" or omit it. Never a clean made-up "X costs $Y" with no source.
- **One product mention + one soft CTA per post.** Pushing the product throughout the body is advertorial and gets penalized. A single soft CTA near the end is right. (Reviews/comparisons may name it in a table once plus a closing CTA.)
- **No false capability claims** about the product (e.g. an API or feature that does not exist). Verify scope before claiming it.
- **At least 1 external link per post.** Sourced reference posts run 5-15 external links. Zero external links reads as a closed ecosystem and hurts trust.
- **At least 1 image per post.** Cover image required, plus inline screenshots/diagrams below.

## The AI tells to kill (core of the skill)

Strip every one of these. They are what make writing read as machine-generated (per [Wikipedia "Signs of AI writing"](https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing), Pangram's pattern guide, and the jalaalrd anti-slop list):

- **Booster/filler words:** delve, robust, boasts, showcase, underscore, pivotal, crucial, landscape, testament, tapestry, vibrant, meticulous, seamless, realm, elevate, navigate, "in today's...", "ever-evolving", "fast-paced world".
- **Banned sentence-opener adverbs (16):** Certainly, Moreover, Furthermore, Additionally, Indeed, Notably, Importantly, Essentially, Ultimately, Crucially, Significantly, Remarkably, Interestingly, Specifically, Particularly, Consequently. Strip on sight.
- **Banned significance-padding verbs and nouns:** stands as, serves as, marks, represents, is a testament to, is a reminder of, underscores, reflects broader trends, sets the stage for, evolving landscape, key turning point. Rewrite into a concrete claim with a subject and a number.
- **Banned conclusion shapes:** any paragraph that opens with Overall, In conclusion, In summary, To sum up, or follows the template "Despite its [positive trait] [subject] faces challenges." End on the strongest concrete point instead.
- **"Not just X, but Y"** and "it is not X, it is Y" parallelisms.
- **Rule-of-three** adjective lists ("fast, reliable, and scalable").
- **Copula-dodging:** "serves as", "stands as", "plays a vital role", "boasts", "features".
- **Trailing "-ing" summary clauses** ("..., making it the ideal choice").
- **Guru openers** ("In an increasingly digital world...") and **canned conclusions** ("In conclusion", "Challenges and Future Prospects").
- **Hedge-attribution** ("studies show", "it is widely reported") with no named source.

### Greppable word bans (Datadog + Microsoft + GitLab style guides)

These are the words to ban with a literal grep before publish. Sources: [Datadog Vale config](https://github.com/DataDog/documentation/blob/master/CONTRIBUTING.md), [Microsoft top-10 style tips](https://learn.microsoft.com/en-us/style-guide/top-10-tips-style-voice), [GitLab docs style](https://docs.gitlab.com/development/documentation/styleguide/).

- **please.** Never plead with the reader.
- **utilize.** Use "use".
- **currently, now, will.** Write timelessly. Docs and posts go stale.
- **via.** Pick a clearer preposition.
- **a number of.** Pick a few, several, or many.
- **Once** as a causal connector. Use "after".
- **easy, just, simply.** Reads condescending and is usually false.
- **You can...** and **There is / There are / There were** sentence openers. Both hide the subject. Lead with a verb or a real noun.
- **i.e. and e.g.** in body prose. Write "that is" and "for example".

Replace with: a definitive first sentence, concrete specifics, a clear point of view, and varied sentence rhythm.

## Voice and readability

- **Conversational, grade 7-8. Write like people talk.** Daily-life language, no corporate jargon, no hard words when a simple one works. Swap fancy for plain: use (not utilize), help (not facilitate), start (not commence), get (not obtain), about (not approximately), more (not additional), enough (not sufficient). The first 100 words should be readable by a smart 13-year-old.
- **Commentary, not info dump.** Write so a reader stays for the next sentence, not just the bullet. Take the angle nobody else has. Make the call before stating the facts. A post that reads like a sharp practitioner thinking out loud beats one that reads like a Wikipedia summary, even when the substance is identical. If your draft could be replaced by a 3-paragraph AI summary with no loss, you have a structure, not a piece.
- **Opinionated.** Take a stance, make the call, say who something is wrong for. Neutral fact-recaps do not rank or get cited.
- **Length follows the keyword.** Match or beat the depth of the current top-3 results. Long is fine when every section earns its place; padding is not. Cornerstone/pillar posts have a separate floor (see SEO mechanics).

## Readability gates (Hard Rule, measured on prose only)

Run these numbers on the connective prose, excluding tables, code blocks, frontmatter, and lists. Use the Hemingway Editor (hemingwayapp.com) or any Flesch-Kincaid checker. The page itself should publish a meta or footer line stating the score so editors can spot regressions.

- **Flesch Reading Ease ≥ 65** (target 70+).
- **Flesch-Kincaid Grade ≤ 8** (target 6-7).
- **Mean words per sentence ≤ 16.** Treat this as a mean, not a ceiling: see burstiness rule below.
- **Sentences per paragraph ≤ 3.** A bullet is not a paragraph.
- **Words per paragraph ≤ 60** (typically 30-50). A paragraph over 60 words is a wall, even if it's only 3 sentences.
- **Subhead every 200-300 words.** A long post should have around 10 headers total. Never a wall of unbroken text. If a section runs past 400 words without an `H3`, you missed a subhead.
- **Burstiness rule.** Standard deviation of sentence length should roughly equal the mean. If mean is 14 words, the same paragraph should contain a 4-word sentence and a 28-word sentence. Uniform sentence length is the single loudest AI tell after vocabulary. Per [GPTZero's burstiness research](https://gptzero.me/news/perplexity-and-burstiness-what-is-it/), human writing measures 0.6-1.2; GPT clusters at 0.2-0.4.
- **Sentence rhythm.** Mix short (5-10 words) with medium (12-18) with the occasional long (up to 28). Never two long sentences in a row. Read it out loud; if you ran out of breath, cut.
- **Exception:** dense reference posts (legal citations, methodology, proper nouns) may run grade 9-10. Do not gut load-bearing substance to hit a number.
- **Automated tools misread markdown.** Tables and bullet lists score as run-on sentences. Judge prose-only.

## Rich formatting (Hard Rule)

Scannability is half the reason these posts rank. A wall of paragraphs loses to a competitor with the same content broken into a table.

- **Visual Break Density: 12+ breaks per 1,000 words** (per [Backlinko's content writing research](https://backlinko.com/content-writing)). Count tables, screenshots, code blocks, callouts, blockquotes, charts, embedded video, mermaid diagrams, and inline images. A 2,000-word post needs roughly 24 breaks. Below that floor the page reads as a wall of text and scan rate drops.
- **Tables for any comparison of 3+ items on 2+ axes.** Markdown tables, real columns (Price, Feature, Best for, Source). Tables win featured snippets and AI-Overview citations.
- **Bullets for parallel lists of 3-7 items.** Parallel grammatical structure (every bullet starts the same way: noun phrase, imperative verb, or full sentence). Max one level of nesting; if you need 3 levels, you need a table or subheads.
- **Numbered lists only for ordered steps** (a procedure, a ranked roundup). Don't number unordered items.
- **Bold (`**text**`) for first-time introduction of a key term or named pattern,** not for emphasis. Reserve italics for proper-noun titles and the very rare emphasis case.
- **Fenced code blocks always have a language hint** (` ```bash`, ` ```python`, ` ```json`, ` ```mdx`). Include a comment line above non-obvious commands explaining what they do.
- **Blockquotes (`> `) only for verbatim third-party quotes**, with the source named on the line below. Never for your own emphasis.
- **Callouts / admonitions** (where the renderer supports them: Mintlify, MDX, Docusaurus) for true asides only: a `warning` block for a footgun, a `note` for an exception, a `tip` for a shortcut. Three callouts max per post. If everything is a callout, nothing is.
- **Images: at least 1 per post (cover image required).** Then one screenshot or diagram every 400-600 words. Real product UI, not stock or marketing heroes. Web-served formats (WebP first, AVIF acceptable, PNG only for transparency). Filenames kebab-case and keyword-descriptive (`github-copilot-billing-dashboard.webp`, not `screenshot-1.png`).
- **All images need alt text AND a visible caption.** Alt text describes what's in the image and includes the target keyword once when it fits naturally. Never keyword-stuff alt text; old-school penalty.
- **Lazy-load every below-the-fold image** (HTML `loading="lazy"`).
- **Zoomable on click.** The renderer must support lightbox/modal expansion so readers can zoom screenshots. If the framework doesn't ship this, wrap images in a lightbox component.
- **Video embeds (YouTube primary).** Every cornerstone post pairs with a YouTube video, embedded near the top with a 2-3 sentence caption. Pair video URL in the post and post URL in the video description. Per Ahrefs 1B-data-point study, YouTube presence correlates 0.737 with AI-Overview citation (highest off-page lever).
- **Mermaid diagrams for any flow with 3+ steps:** process flows, architectures, sequence diagrams, decision trees, dependency graphs. Inline ```mermaid``` blocks render in MDX, Mintlify, Docusaurus, GitHub, GitLab. Always include a plain-text fallback line below the diagram for readers whose viewer can't render mermaid.
- **One TL;DR block** at the top: 4-6 scannable bullets, each a standalone takeaway. This is the AEO extraction surface, so LLMs do not have to read the entire post to summarize it.
- **One comparison table or one feature matrix** in every listicle or head-to-head post.
- **No wall paragraphs.** If a draft has a paragraph over 60 words, rewrite as 2 paragraphs, a list, or a table.

### Heading hygiene (per [MDN Writing Style Guide](https://developer.mozilla.org/en-US/docs/MDN/Writing_guidelines/Writing_style_guide))

- **No bumping heads.** Every heading needs at least one paragraph of body before the next subheading.
- **No lone subsections.** If you create an H3 under an H2, you need at least two H3s, else inline the content.
- **Depth cap at H4.** The H1 is the title, body uses H2 to H4 only.
- **Phrase headings as questions when natural.** "How does GitHub Copilot bill now?" beats "GitHub Copilot Billing." Question-form headings match People-Also-Ask intent and earn featured-snippet pickups. Per Priyansh's [SEO guide](https://zriyansh.medium.com/as-a-technical-writer-know-seo-c62df581f8ff): "Structure your blog headings in a way that asks a question so Google can crawl that section."

### Link hygiene

- **Never use directional language.** Banned: above, below, "see the section above", "as mentioned earlier". LLM and mobile reflow break these pointers. Link explicitly to the named section by anchor.
- **Link text must describe the destination.** Never link the word "here" or "click here". The anchor itself carries the meaning, for accessibility and for SEO anchor relevance.
- **External link attribute:** use HTML `<a href="..." rel="noopener noreferrer">` for safety. Add `nofollow` for paid/affiliate links or links to lower-trust domains.
- **Cross-link anchor text = the destination title (or its keyword), not "this post".** The anchor is a ranking signal for the destination.

## Universal structure (every post)

1. **Title that matches search intent**, not cleverness. If the query is "how much does X cost", the title says cost; if it is "best X tools", lead with "Top/Best X". Put a number in listicle titles ("Top 11 ..."). **Title length: ≤ 60 characters** (anything longer truncates in SERPs and AI-Overview cards).
2. **Meta description: ≤ 156 characters.** Lead with the target keyword phrase. This is what shows in SERPs and what most LLM AEO surfaces extract.
3. **Answer-first intro.** First 1-2 sentences answer the query directly (the AI-overview / featured-snippet bait), then set up the rest.
4. **TL;DR near the top:** 4-6 scannable bullets, each a standalone takeaway. AEO extraction surface: LLMs lift this whole.
5. **Methodology / "How we picked"** block (E-E-A-T): the criteria, how many options considered, and that prices are sourced and sentiment is from real places. One or two short paragraphs.
6. Body in the type-specific shape below.
7. **FAQ** (`## FAQ`, 6-10 real People-Also-Ask questions, 2-4 sentence answers) so FAQPage schema fires and you win PAA boxes.
8. **One soft CTA** + 3-5 internal links to the relevant topic cluster.

### Answer islands (per-section structure)

Every H2/H3 is an answer island. Per [Digital Applied's 1,000-AIO citation study](https://www.digitalapplied.com/blog/we-analyzed-1000-ai-overviews-citation-pattern-study), cited passages cluster at 134-167 words, and 44.2% of LLM citations come from the first 30% of the page.

- Open every section with a **20-30 word direct answer** to the heading, then expand.
- Keep the full section between **134 and 167 words** so AI Overviews and snippet boxes can lift it whole.
- **Front-load the first 30% and every heading.** Load-bearing claim, primary keyword, and the strongest data point land above the first H2. Inside every heading, the first 5 words carry the topical keyword. Strip lead-in clauses ("How to", "Why you should", "The complete guide to") from H2s where the keyword can lead instead.

## Post-type structures

### Listicle / roundup ("Best/Top X tools")

**Default to listicle for commercial-intent queries.** Per [Ahrefs' 1B-data-point analysis](https://ahrefs.com/blog/ai-overview-citations-top-10/), best-X listicles are 43.8% of all pages cited by AI chatbots, the single most cited format. If the query has buyer intent ("best", "top", "cheapest", "alternatives", "vs"), frame as a numbered list with a comparison table in the first 30% of the page. Reserve guide and how-to formats for informational-intent queries.

- At least the number the field supports (often 10-15); do not pad with off-category or irrelevant entries. If the real field is small, stay small.
- Lead with a **comparison table**: rich columns buyers filter on (Price, Free trial, Seat minimum, Security/compliance, Key capability, Best for, Source). Tables win featured snippets.
- **Repeating per-tool template** (each entry is a self-contained, modular block so AI search can cite it):
 - `### N. Tool Name: best for [use case]` (entity-rich heading; use a colon, never a dash)
 - A real product screenshot
 - `**At a glance:** price (sourced or quote-based) · access (self-serve/sales) · best for [who]`
 - 1-2 sentence opinionated take; the first sentence stands alone as a definitive claim
 - `**What's good**` (2-3 bullets)
 - `**Where it falls short**` (1-2 bullets) for every tool, uniformly
 - `**What users say:**` one sourced sentiment line (real forum/review, linked if it curls 200; if none exists, say so, invent nothing)
 - `**Bottom line:**` 2 sentences on who should buy and who should skip
- If writing for a product's own site, rank it #1 honestly and still give it a real "where it falls short" tradeoff.
- For breadth without padding, add a short "Others worth knowing" tier of one-line entries.

### Single-product review

At-a-glance table (the product vs the obvious alternative). Honest verdict, who it fits, who it does not. Real strengths and real gaps. A named author and a methodology note matter most here.

### Head-to-head comparison

A scannable feature matrix (not just prose). Cover the axes buyers actually decide on. Include any independent benchmark/data with its named source. End with "which to pick, for whom".

### Pricing / cost

Per-row, dated, **attributed** numbers (named source + date + link). Cover hidden costs/TCO, minimums, contract terms, and negotiation, because that is what buyers search. Never an invented sticker price; quote-based where the vendor publishes nothing.

### How-to / guide / reference

Lead with the answer, then the steps or the table. Reference posts (state-by-state, by-X) win on accuracy, current cites, and a "last verified" date.

## E-E-A-T signals

- **Named human author** with relevant credentials, not a generic company byline.
- **Disclosure** when you have a stake ("We build [product]; here is the methodology and sources anyway, so you can check the math.").
- **Methodology** stated (how tested, how many, criteria).
- **Real publish date + honest `updatedAt`**; only bump it on a real refresh.
- **Original data is the highest-compounding asset.** A small, real, repeatable benchmark or study you ran earns links and AI citations competitors cannot copy. Do not fake it; run it or skip it.
- **Freshness floor.** Don't cite or compare against content older than 2 years (24 months) unless it's a primary specification or historical reference. Stale comparisons are a ranking penalty. When updating an old post, change the publish date AND state the diff in an "Updated for [date]" line.

### Three human signals per 800 words (minimum)

Per the [Frontiers in Education 2025 corpus study on AI-vs-human grading](https://www.frontiersin.org/journals/education/articles/10.3389/feduc.2025.1616935/full) and [Google's Search Quality Rater Guidelines](https://services.google.com/fh/files/misc/hsw-sqrg.pdf), graders identify AI writing not by surface errors but by missing first-person observation, contextual anchoring, and rhetorical spontaneity. Every 800 words must include:

- **One first-person observation** with a verb and an object. Example: "I ran this on a 4GB Postgres box and it choked at 200k rows."
- **One contextual anchor:** a date, a place, or a specific environment. Example: "tested on a 2024 M3 MacBook, k8s 1.29".
- **One rhetorical aside, parenthetical, or short rhetorical question:** the kind an editor would cut but a reader remembers.

Missing any of the three is the loudest human-vs-AI signal experienced editors use.

## Sourcing and attribution

- State competitor/market numbers only with a named, dated source you verified (curl, browser UA, 200). Format: "X is ~$Y/mo (Source, Month Year)" with the link inline.
- Cite liberally; there is no hard external-link cap for a well-sourced reference post. But every external link must resolve (curl before publishing).
- Reframe studies correctly (peer-reviewed vs preprint, year, authors). Use exact figures, not rounded-wrong ones.
- **Vague-attribution shells are fabrication tells.** Banned phrasings: "observers have cited", "industry reports suggest", "experts argue", "some critics claim", "several sources", "many analysts note". Replace with a named source plus a date plus a verifiable URL, or delete the claim. Anything that fakes a citation without a citation is treated as invented. (Per [Wikipedia AI-writing signs](https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing) and [Pangram's pattern guide](https://www.pangram.com/blog/comprehensive-guide-to-spotting-ai-writing-patterns).)

### Real user-voice required (for product, tool, and review posts)

Pull verbatim quotes from real people saying real things, not synthetic "users love X" sentences. Sources:

- **Reddit threads** (use the reddit-mcp; see Research tooling). Cite the subreddit, post title, OP or commenter handle, and link.
- **Quora answers.** Same attribution format.
- **Hacker News comments.** Link to the specific comment ID, not just the thread.
- **Twitter/X posts.** Link to the tweet; quote the relevant clause; name the handle.
- **Vendor forums and changelog discussions** (e.g. github.com/orgs/<org>/discussions, community.openai.com).

Format every quote block as a blockquote with the source on the line below: `> [verbatim quote]` then `Source: @handle, r/subreddit, [date]([url])`. One quote per major claim about user experience. If no real quote exists, write that plainly: "User reports are too thin to draw a conclusion yet."

## SEO mechanics

### On-page

- **Title length: ≤ 60 chars.** Meta description: ≤ 156 chars. Both start with the primary keyword.
- **Primary keyword in the URL slug** (`/blog/github-copilot-pricing`, not `/blog/post-1234`). Kebab-case, lowercase, no stop words longer than necessary, **no dates in the URL** (`/blog/2026/06/copilot-pricing` rots).
- **Keyword density: ≥ 5 mentions per post AND ≤ 1 mention per 200 words.** Combined: keeps you in the 0.5-1% density band the helpful-content classifier rewards. Per Priyansh's [SEO guide](https://zriyansh.medium.com/as-a-technical-writer-know-seo-c62df581f8ff).
- **Entity density: 15-20 named entities per 1,000 words.** Use the full name on first mention (PostgreSQL 16, not "the database"; Cloudflare Workers, not "the platform"). Per [AI Mode Boost's 2025 ranking-factor study](https://aimodeboost.com/resources/research/ai-overview-ranking-factors-2025/), pages above 15 get 4.8x higher AI Overview selection.
- **Cornerstone length floor: 1,800 words minimum, 2,500+ ideal.** Per Digital Applied, pages over 2,500 words earn 1.6x more AI Overview citations than sub-800 posts. Lift starts at 1,800 and plateaus around 3,500. Non-cornerstone posts still follow keyword-driven length. Do not pad to hit the floor; cut the topic instead.

### Internal linking

- **Internal linking / topic clusters:** every post links into a hub-and-spoke cluster (3-5 contextual links).
- **No orphan pages.** Every published page reachable from the homepage in ≤ 3 clicks.
- **Avoid cannibalization:** one canonical page per head term. A pillar owns the broad term and links down to the listicle; the listicle owns "best X tools" and links up. Do not let two pages chase the identical query; sharpen each title/intro and cross-link.
- **Exact-match (or descriptive title-match) anchor text** when linking to the page that should own a term. Generic "click here" or "this post" anchors waste ranking signal.
- **Fix internal-link rot:** every `/route` link must point to a real page. Audit periodically.
- **Regenerate the slug list before adding any internal link.** Never link from memory or from what feels like a plausible slug. List the content directory, derive the real link paths, and link only what the listing returns. The site profile holds the exact command for this repo. Use full prefixed paths (`/blog/<slug>`), never bare slugs and never relative `../` hops, which break under any renderer that rewrites routes.

### Schema and protocols (hygiene minimum)

- **Schema:** emit `Article` + `BreadcrumbList` + `FAQPage` (from the `## FAQ`), plus `ItemList` for ranked listicles. Reviews/comparisons may add `Review`/`AggregateRating` only if based on real testing. Validate at [Google's Rich Results Test](https://search.google.com/test/rich-results). Per the [Ahrefs 1B-data-point study](https://ahrefs.com/blog/ai-overview-citations-top-10/), schema has near-zero correlation with AI Overview citation; treat it as table stakes, do not invest review cycles tuning it.
- **Canonical tag in HTML head:** `<link rel="canonical" href="https://your-domain.com/blog/<slug>"/>`. Prevents duplicate-content penalties when the post is republished to dev.to / hashnode / Medium.
- **Breadcrumbs visible in the page** (Home > Blog > [Topic] > [Post Title]). Both a ranking signal and a UX signal.
- **Submit to IndexNow** (Bing, Yandex, Naver, Seznam) on publish for hours-to-minutes indexing instead of days. Most CMS plugins ship a one-click toggle.
- **RSS/Atom feed at /blog/feed.xml and /article/feed.xml.** AI-Search crawlers and content aggregators consume RSS.
- **llms.txt and agents.txt** at the site root so AI agents can discover what the product is and which pages matter.

### Off-page (the actual growth levers)

Per [Ahrefs' 1B-data-point analysis](https://ahrefs.com/blog/ai-overview-citations-top-10/): brand web mentions correlate **0.664**, YouTube presence **0.737**, backlinks **0.218**, schema near zero. Implications:

- **Every cornerstone post ships with a paired YouTube video,** post URL in the video description, transcript published.
- **Chase unlinked brand mentions** across newsletters, podcasts, and forum threads. Mentions beat links for LLM citation.
- **Republish to dev.to, hashnode, or Medium WITH a canonical link back to the original.** Republishing without canonicals splits SEO juice and risks duplicate-content penalties; with canonicals it consolidates ranking and earns secondary audiences.

## Three-stage workflow (any post grounded in breaking news)

News posts are where fabrication risk peaks: the facts are fresh, secondary coverage is already garbled, and the pressure is to publish first. Ship every one of them through three separate passes.

1. **Research.** Fetch the canonical primary source FIRST: the vendor blog, the SEC filing, the GitHub advisory, the official CVE record. Note the exact URL and the exact phrasing of every load-bearing claim. WebSearch and EXA are for *finding* sources, never for *substituting* them. A secondary article's summary of a primary source is not a source.
2. **Draft.** Write against the research brief. Inline a source link on every specific number, date, CVE, vendor quote, and advisory ID.
3. **Verify.** Adversarially fact-check as if trying to get the post retracted. Re-fetch every primary source. Soften any claim the source does not literally support. Strip any product-capability claim not on the site profile's capability sheet.

**After commit, independently re-spot-check the most quantitative claims against the canonical URL.** Verifier passes miss things. The second pass catches them. This is not optional politeness, it is the step that keeps a wrong number from living on the site for a year.

## Research and distribution tooling

Use the right tooling so writing time goes into the writing, not the surfaces. All of these compose with Claude Code; pick what fits the post type.

### Real-time research

- **EXA MCP** (or EXA API key directly): citation-grade semantic web search. Use over WebSearch when you need primary-source URLs with snippet-level context. Free tier covers most blog research.
- **WebFetch + Bash `curl`**: for fetching primary sources directly. Always verify the canonical primary source before any secondary coverage.
- **reddit-mcp** (free, no-auth): browse subreddits, fetch thread details, pull verbatim comments with attribution. The fastest way to source the Real User-Voice quotes the Sourcing section requires.
- **github-mcp** (free, no-auth): advisory lookup, release-note inspection, competitive feature research from open-source repos.
- **google-news-trends MCP**: surface trending stories by keyword or topic for time-sensitive posts.
- **keywordtool-guest MCP**: keyword research, search volume estimates from Google Ads and Bing Ads APIs.
- **AnswerThePublic** (free tier, web): headline ideation and PAA-style question discovery.
- **Cora** (paid, web): reverse-engineering competitor content structures at scale when planning a pillar post.

### Distribution

- **Republish queue:** every published post is republished to at least one of dev.to, hashnode, or Medium **with a canonical link back to the original**.
- **YouTube companion:** pair every cornerstone post with a YouTube video. Embed the video on the post; link the post in the video description; publish the transcript.
- **LinkedIn snippet + Reddit submission:** required for every news-style post. Full shapes in [Promo snippets](#promo-snippets-linkedin--reddit).
- **Newsletter feed-out:** the RSS feed should flow into the company newsletter automatically.

### Promo snippets (LinkedIn + Reddit)

Ship these alongside any news-grounded post. Write them after the post, from the post, so the hook is a real insight and not a restated headline.

**LinkedIn snippet** (this is the post body; the article link goes in the first comment, because in-body links suppress reach):

- Hook line, 3-9 words, strong, breaking-news framing.
- 2-3 short sentences naming the most-skipped insight, with one quoted phrase from the primary source.
- Closing line: `Full breakdown 👇 in the comments` or similar.
- One emoji max, optional.

**Reddit submission:**

- Title ≤ 290 chars, news-y, substance leads. The least clickbaity version that still surfaces the insight.
- Body 300-450 words. Open with the most-skipped detail. Inline links to primary sources. Close with a one-sentence open question to drive comments.
- Sign-off line: `Full writeup: [link in comment]`.
- Suggest 4-6 subreddits that fit the topic. Check each one's self-promotion rules first; a link-dropped post in the wrong subreddit costs the account, not just the post.

## Competitive gap audit (before writing or to improve a ranking page)

1. Search the target keyword; list the top ~10 organic results (mark real competitors vs directories).
2. Fetch the top 4-5; extract their structure, depth signals (length, original data, tables, screenshots), freshness, and what earns the ranking.
3. Compare to your draft/page. List exactly what they have that you do not (sections, data, tables, FAQs, angles).
4. Close every gap, then add one thing none of them have (original data, a better table, a sharper verdict).
5. **Target your post at roughly 50% longer than the top-ranked competitor** for the keyword (per Priyansh's [SEO guide](https://zriyansh.medium.com/as-a-technical-writer-know-seo-c62df581f8ff)). Beat them on depth, not by padding. If the top result is 1,200 words, aim ~1,800-2,000. If it's 3,000, you're at ~4,500. Combine with the cornerstone-floor rule.

Improving an existing ranking page (position 5-15, real impressions) beats writing a new one. Diagnose with search-console data first, fix the page, then measure before mass-producing.

## Images

- **At least 1 image per post (cover image required).** Real product/UI screenshots, not stock or marketing heroes. Place each right after the section that introduces the thing.
- **Format: WebP first, AVIF acceptable, PNG only for transparency.** No JPEG for screenshots. Per Priyansh's SEO guide: image format directly affects load time and SEO.
- **Lazy-load every below-the-fold image** (HTML `loading="lazy"`).
- **Zoomable on click.** Renderer must support lightbox/modal so readers can expand screenshots.
- **Descriptive alt text + visible caption.** Alt text describes the image accurately and includes the target keyword once when it fits naturally. No keyword-stuffing.
- **Filenames are kebab-case and keyword-descriptive:** `github-copilot-billing-dashboard.webp`, not `screenshot-1.png` or `image (3).PNG`.
- **Show your own product's UI**, not only competitors'.
- **Every referenced image file must exist** (case-sensitive in prod). No filenames with spaces. Keep paths consistent.

## Secret-shaped example credentials

Code blocks in security and API posts routinely need example credentials (`sk_live_...`, `ghp_...`, `AKIA...`). A complete, real-looking literal in the markdown source trips GitHub push protection and blocks the commit, and worse, gets flagged by scanners downstream of anyone who forks the repo.

Split the literal across runtime variables so no single line matches a secret pattern:

```bash
# Never paste a complete real-looking literal into markdown source
PREFIX="sk_live_"
SUFFIX="51HxYz...example"
echo "${PREFIX}${SUFFIX}"
```

The rendered post still shows the reader a realistic value. The source file contains no scannable secret.

## Quality gates before commit

Every post clears these before it lands. The site profile holds the exact commands for the repo; the gates themselves are universal.

- **The site builds.** A build catches MDX and type errors that no amount of grepping will. Confirm the route actually prerenders, do not just watch the build exit 0.
- **Em-dash count is 0.** Grep the source file. This is the single most reliable AI tell and the easiest to miss by eye.
- **Every internal link resolves to a file on disk.** Check each `/route/<slug>` against the content directory listing.
- **An independent judge pass.** A second model or a fresh agent session, with no memory of writing the draft, reviews against this skill. The author-agent is the worst possible reviewer of its own draft.
- **Canonical-source spot-check.** Re-fetch the primary URLs and confirm numbers, dates, quotes, and product names match verbatim.

## Anti-patterns (do not do)

- Mass-producing thin, near-duplicate posts. Volume without depth gets sites penalized. Improve and consolidate instead.
- Advertorial body copy (product named throughout). One mention, one CTA.
- Invented prices, stats, quotes, or "as reported" with no named source.
- Programmatic bulk pages with no unique value.
- Claiming capabilities the product does not have.
- Synthetic user voice ("users love X", "developers say Y") without a real linked quote.
- Republishing to dev.to / Medium / hashnode without a canonical tag (splits ranking signal).
- Citing content older than 2 years as current state of the art.
- AMP. Google deprecated the AMP signal; don't waste cycles on it.

## Pre-publish checklist

- [ ] Site profile read (or its absence flagged, with every guessed convention named); frontmatter matches its schema; only its allowed components used
- [ ] Every product-capability claim traced to a line on the profile's capability sheet, and the sheet's verify date is current
- [ ] Title ≤ 60 chars; meta description ≤ 156 chars; both start with the target keyword
- [ ] Answer-first intro; title matches search intent
- [ ] TL;DR + methodology block present (TL;DR is the AEO extraction surface)
- [ ] Post-type structure followed (table for listicles/comparisons; per-tool template; verdicts)
- [ ] Every H2/H3 is an answer island (20-30 word lead, 134-167 word section, keyword in first 5 words of heading); H2s/H3s phrased as questions where natural
- [ ] `## FAQ` with 6-10 PAA questions (FAQPage schema will fire)
- [ ] Named author + disclosure + `updatedAt`
- [ ] Three human signals per 800 words (first-person observation, contextual anchor, rhetorical aside)
- [ ] Real user-voice quote from Reddit/Quora/X/HN for any product or tool post; verbatim, attributed, linked
- [ ] No content older than 2 years cited as current (unless historical/spec)
- [ ] Entity density ≥ 15 named entities per 1,000 words
- [ ] Keyword density: ≥ 5 total mentions AND ≤ 1 per 200 words
- [ ] Cornerstone posts ≥ 1,800 words; paired YouTube video planned/embedded
- [ ] Article ~50% longer than top-ranked competitor for the keyword
- [ ] Every number is product-own or named-dated-sourced; nothing invented; no vague-attribution shells
- [ ] At least 1 external link; external links use `rel="noopener noreferrer"`
- [ ] Every external link curls 200 (or is named without a link); every internal `/route` exists
- [ ] 2-4 cross-links using descriptive anchor text (destination title or keyword, not "click here")
- [ ] At least 1 image (cover); all images WebP/AVIF, lazy-loaded, zoomable, alt text + visible caption, keyword-descriptive filenames
- [ ] Video embed (YouTube) for cornerstone posts; mermaid diagram for any 3+ step flow
- [ ] 0 em-dashes, 0 curly quotes, 0 AI-tell words, 0 banned adverb openers, 0 greppable word bans, no "not just X but Y", paragraphs ≤ 3 sentences and ≤ 60 words
- [ ] Burstiness present: every paragraph mixes short (< 10 words) with at least one long (> 20 words) sentence
- [ ] Visual Break Density ≥ 12 breaks per 1,000 words
- [ ] Readability in band (prose-only): Flesch ≥ 65, FK ≤ 8, mean words/sentence ≤ 16
- [ ] Heading hygiene: no bumping heads, no lone subsections, depth cap H4, ~10 headers total in a long post
- [ ] Link hygiene: no "above/below/here" anchors, link text describes destination
- [ ] URL slug includes primary keyword; no dates in URL; kebab-case
- [ ] Canonical tag in HTML head; BreadcrumbList schema + visible breadcrumbs
- [ ] Post submitted to IndexNow on publish; in RSS feed
- [ ] Republish plan: dev.to / hashnode / Medium with canonical tag
- [ ] Product named once + one soft CTA + 3-5 cluster internal links
- [ ] Build passes (catches MDX/type errors grep cannot); em-dash grep returns 0; independent judge pass; canonical-source spot-check
- [ ] Slug list regenerated before internal links were added; every link uses the full prefixed path
- [ ] **Naive-reader gate:** wrote down the 5-10 questions a target reader would ask, handed the draft to a fresh agent session or second human with no project context, patched every gap they surfaced, iterated until they stop finding new ones. (Per Anthropic's [doc-coauthoring skill](https://github.com/anthropics/skills/blob/main/skills/doc-coauthoring/SKILL.md).)
