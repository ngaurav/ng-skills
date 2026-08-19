---
name: agent-native-cli
description: "Design and audit command-line tools that AI agents drive through shell execution. Use when building, extending, reviewing, or code-generating any CLI an agent will call. Covers non-interactive execution, uniform --json with a stdout/stderr channel contract, errors that enumerate valid values, unknown-flag rejection, idempotent mutations, token-efficient schemas and truncation, pre-computed aggregates, agent-context introspection, --wait plus a job ledger, profiles, --deliver sinks, cross-CLI vocabulary consistency, and schema-enforced consistency. Carries a blocker/friction/optimization severity rubric so the same document works for reviewing an existing CLI."
build-system: Generated. Edit the source file, not this file.
repo: ngaurav/ng-skills
---

# Agent-Native CLIs

Agents are the primary consumer of most CLIs now. They arrive with no ability to answer a prompt, a context window that every line of output is charged against, a habit of retrying, and a generalized model of "how CLIs work" built from every other CLI they have seen. A tool that ignores those facts still technically works. It just costs more tokens, more retries, and more failure modes that only surface in production.

Design for agents first and humans benefit. The reverse order is what produces the prompt-prone, table-formatted, unbounded CLIs that Tier 1 below exists to correct.

<!-- @
SOURCES. This skill is a merge of two documents, pulled 2026-08-16:

  1. kunchenguid/axi — .agents/skills/axi/SKILL.md (also published at axi.md).
     10 principles under Efficiency / Robustness / Discoverability. Strongest
     on token economics: minimal schemas, truncation previews, aggregates.
  2. Trevin Chow, "10 Principles for Agent-Native CLIs" (trevinsays.com),
     which supersedes his earlier "7 Principles for Agent-Friendly CLIs".
     Strongest on lifecycle: async, profiles, introspection, vocabulary.
     Draws on Cloudflare's "The CLI for all of Cloudflare" and HeyGen's CLI.

The older 7-principles post is NOT dead. Four things in it were compressed out
of the newer one and are pulled forward here: severity-varies-by-command-type,
the TTY-detach hang test, ANSI suppression on non-TTY stdout, and stdin / `-`
pipelining. Check it before assuming the 10-post is complete.

Raw copies were not committed. Re-pull if a claim here needs verifying.
-->

## How to use this

**Building or extending a CLI:** the principles are normative. Apply them by tier — Tier 1 first, because nothing in Tier 2 or 3 helps a CLI that hangs.

**Reviewing an existing CLI:** each principle ends with a severity line. Report findings as Blocker / Friction / Optimization, not pass-fail, and rank by tier.

**Severity depends on what the command does.** Do not apply every principle uniformly. Idempotence is high-value for a mutating command and irrelevant for a streaming log tail. Structured output is a blocker for a read/query command and marginal for a one-off bootstrap wizard. `--wait` only applies to commands that wrap an async API; profiles only to a CLI with configuration worth persisting; `--deliver` only to commands that emit an artifact. Judge each command by its own kind.

<!-- @
The severity-by-command-type rule is from the OLDER post ("A severity rubric,
not a scorecard"). The 10-post dropped it. Pulling it forward does double duty:
it is the applicability gate for the conditional Tier 3 principles (--wait,
profiles, --deliver), which otherwise each need their own "only if..." caveat.
Stating it once up front is cheaper than restating it six times.
-->

---

# Tier 1: Don't break the agent

Table stakes. Every gap here is paid on every call.

## 1. Non-interactive by default

Any command an agent might automate must complete with flags alone. When a subagent spawns a background process there is nothing to answer a prompt, so the command hangs until it is killed. Interactive mode can exist for humans, but only as a convenience layer over a fully flag-driven path.

```
# Hangs forever waiting for a confirmation that will never come
$ mycli post delete post_8f2a < /dev/null
Are you sure you want to delete post_8f2a? [y/N]: ^C

# With --force: bypasses the prompt, agent gets through cleanly
$ mycli post delete post_8f2a --force --json
{"deleted":"post_8f2a"}
```

- **Treat a non-TTY stdin as headless.** If stdin is not a TTY, never prompt. Period.
- **`--no-input` on every command that could prompt**, plus `--force` for destructive confirmation bypass. Pick one convention and enforce it everywhere; Cloudflare standardizes on `--force` and explicitly bans `--skip-confirmations`.
- **Suppress prompts from wrapped tools.** A dependency that prompts hangs your CLI just as hard.
- **Missing required input fails immediately** with an enumerating error (§3), never a prompt.

**Verify it.** Detach stdin, enforce a timeout, and assert the process exits:

```python
import subprocess, sys
try:
    r = subprocess.run(["mycli", "post", "delete", "post_8f2a"],
                       stdin=subprocess.DEVNULL, capture_output=True,
                       text=True, timeout=10)
    print("PASS: exited", r.returncode)
except subprocess.TimeoutExpired:
    print("FAIL: hung waiting for input"); sys.exit(1)
```

> **Severity** — Hangs on a prompt: **Blocker**. Bypass exists but is inconsistent across subcommands: **Friction**. Global non-interactive mode the agent can rely on without per-command lookups: **Optimization target**.

## 2. Structured output and a channel contract

A nicely aligned table with ANSI colors is for humans. An agent extracting a post ID needs JSON.

**Use `--json`. One flag, every data-returning command.** Not `--format=json` on some and `--output json` on others. Inconsistency at this layer is its own category of brokenness, and it is the single easiest thing for an agent to pattern-match across tools.

<!-- @
DECISION: JSON, not TOON. AXI principle 1 mandates TOON on stdout for ~40%
token savings over JSON. Rejected, for three reasons:

  1. Training density. JSON is in every model's pretraining at enormous volume
     and agents reach for jq reflexively. TOON is 2025-era with effectively no
     pretraining presence — an agent parses it by inferring from the header
     line, which works but is a different reliability class.
  2. jq is the real token win. Once output leaves the agent's context into a
     pipeline (`| jq -r '.posts[].id'`), JSON is the only format with tooling.
     Filtering 800 rows WITHOUT reading them into context saves far more than
     encoding 800 rows 40% smaller.
  3. It optimizes the wrong layer. 20 rows x 4 fields: JSON vs TOON is a
     rounding error. 800 rows: the bug is that you returned 800 rows. AXI's own
     principles 2/3/5 (minimal schemas, truncation, bounds) dominate encoding.

Shipping both would also manufacture exactly the format inconsistency this
section warns against. If TOON gets real ecosystem tooling, revisit — the
token argument is sound, it is just smaller than the alternatives.
-->

### The channel contract

| exit | stdout | stderr | meaning |
|---|---|---|---|
| 0 | `{"posts":[...],"total":47}` | — | data |
| 0 | `{"posts":[],"total":0,"filters":{...}}` | — | definitively none (§10) |
| non-zero | *(empty)* | `{"error":"not_found",...}` | failure |

- **The exit code is the discriminator.** Non-zero means the payload is an error. Every harness surfaces exit codes, and it lets the agent branch before parsing anything.
- **stdout stays typed:** data on success, empty on failure. This is what keeps `mycli list --json | jq '.posts[]'` safe forever.
- **Structured errors go to stderr**, in the same format as stdout so they are machine-readable either way.
- **Debug and progress logging also go to stderr, but off by default**, gated behind `--verbose` or a log level. A quiet default means a failing run's stderr contains exactly one thing: the error object. An agent that reads `Fetching data...` will try to interpret it as data.
- **Suppress ANSI when stdout is not a TTY.** Plenty of CLIs detect TTY correctly for prompts and still blast escape codes into piped output. An agent parsing `\x1b[32m✓ Published\x1b[0m` is burning tokens on noise.
- **Document an exit-code taxonomy** and expose it in `agent-context` (§13). A workable default: `0` success including no-ops and empty results, `1` runtime error, `2` usage error, `3` auth, `4` not found, `5` conflict or failed precondition.

<!-- @
The specific 0-5 taxonomy is OURS, not from either source. Neither commits to
one: AXI principle 6 stops at 0 success / 1 error / 2 usage, and Trevin says
only "non-zero for failure with a stable taxonomy if you can manage it", though
his example shows a bare `4` for a not-found. Extending AXI's three with auth /
not-found / conflict covers the failure classes an agent actually branches on,
and matches what curl, git and most HTTP-backed CLIs already do closely enough
that it should not surprise anyone.

Deliberately presented as "a workable default", not a mandate. The load-bearing
rules are that the taxonomy is STABLE and that it is DISCOVERABLE via
agent-context (§13) — the exact integers matter far less, and a CLI with an
existing published set should keep it rather than renumber for this skill.

This matters more here than in either source, because §2 makes the exit code
the discriminator between data, empty-but-fine, and failure. Once the code is
load-bearing for that, leaving the set undefined pushes the agent back to
parsing stdout to find out what happened, which is the thing being avoided.
-->

<!-- @
DECISION: errors on stderr, not stdout. AXI principle 6 puts structured errors
on stdout so the agent is guaranteed to see them, with stderr reserved for debug
logs. Rejected. The cost is that stdout stops being a TYPED channel: if stdout
means "data OR an error object", every consumer must discriminate first, which
is a permanent tax on every pipeline to buy visibility the exit code already
signals unambiguously.

AXI's underlying worry is a harness that drops stderr — real, and the honest
cost of this call: exit 4 with nothing at all is worse than a vague message.
Two mitigations are in the text: the documented exit-code taxonomy (the code
alone carries meaning) and quiet-by-default stderr (no needle in a haystack).

Where AXI is actually wrong is the OTHER half of its split — "stderr = debug
logs" is what makes stderr look unreliable in the first place. Turn logging off
by default and the objection mostly evaporates. What separates logs from errors
is structure and verbosity level, not channel.

Considered and rejected: mirroring the error onto stdout when --json is passed.
Covers the dropped-stderr harness, but makes the channel rule conditional on a
flag, which is worse to document and worse to remember.

Note both sources agree on the part that matters more — errors must be
structured, actionable, and enumerate valid values. The channel is the smaller
question. If a target harness genuinely drops stderr, flipping this is a local
change, not a redesign.
-->

> **Severity** — No structured output: **Blocker**. Coverage gaps, or data and diagnostics mixed on one stream: **Friction**. Uniform `--json`, clean channel separation, documented exit codes: **Optimization target**.

## 3. Errors that enumerate

An error is the highest-signal context an agent ever gets, because it fires exactly when the agent does not know what to do next. Spend tokens here.

```
# Unhelpful: agent must read --help, parse it, guess, retry
$ mycli post create --visibility=secret --content="hi"
error: invalid visibility

# Better: names the valid set, agent self-corrects in one retry
$ mycli post create --visibility=secret --content="hi"
error: --visibility must be one of: public, private, unlisted (got: "secret")
usage: mycli post create --content <file> [--visibility <v>] [--json]
example: mycli post create --content post.md --visibility public
```

A good error does four things: **names the specific problem**, **shows the correct invocation shape**, **enumerates valid values**, and **includes a working example**.

- **Enumerate whenever an enum is the cause.** Any rejection against an enum, an enum-shaped resource list, or a schema should surface the enumeration. This generalizes: unknown `--deliver` scheme, unknown profile name, unknown region.
- **Validate before any side effect** and before calling any dependency.
- **Never leak dependency output.** No raw API errors, no stack traces, no upstream tool names. Translate: extract the actionable meaning, discard the noise, and reference *your* commands in the suggestion.

> **Severity** — Silent or vague failures: **Blocker**. Errors that name the problem but not the fix: **Friction**. Errors carrying the valid set and a working invocation: **Optimization target**.

## 4. Fail loud on unrecognized input

Reject unknown flags and arguments by name. Never silently ignore them.

A dropped flag is worse than an error: the agent gets plausible-looking output it believes is filtered or scoped, then proceeds confidently on wrong data. This is the same guarantee a CLI already owes for an unknown *command*; extend it to flags.

```
$ mycli post list --stat closed
error: unknown flag --stat for `post list`
help: valid flags for `post list`: --state, --assignee, --limit, --json
```

- **Exit 2**, the same as a missing required flag, and validate before any dependency call.
- **`--help` always passes.** Beyond it, a CLI may standardize its own always-allowed globals (a `--profile` selector, say); whatever the set, those pass on every command and are never reported as unknown.
- **Renamed or removed flags get a targeted hint**, not the generic list: `--status was renamed; use --state instead`. One-step self-correction.
- **Validate against the subcommand's flag set**, not the parent's. A `list` and a `create` under the same noun take different flags, and only the subcommand layer knows which is in play.
- **Fold the help lookup into the error.** The agent's deterministic next move is `mycli post list --help`, so inline the valid flags and collapse a two-turn correction into one. Per §9 the expensive cost is the follow-up call, and per §13 per-command help is already concise.

> **Severity** — Unknown flags silently ignored: **Blocker**. Rejected but with no indication of what is valid: **Friction**. Rejected by name with the valid set inline: **Optimization target**.

## 5. Safe retries and explicit mutation boundaries

Agents retry. A human who runs a command twice notices the duplicate row; an agent in a retry loop does not, unless the CLI says so.

```
# Idempotent create — second call returns the existing resource
$ mycli post create --json --content="hello world"
{"id":"post_8f2a","existing":false}
$ mycli post create --json --content="hello world"
{"id":"post_8f2a","existing":true}

# Destructive ops are explicit; --dry-run previews
$ mycli post delete post_8f2a --dry-run --json
{"would_delete":"post_8f2a","status":"dry_run"}
```

- **Idempotency tokens or natural keys on create**, so a retry returns the existing resource rather than a duplicate.
- **Do not error when the desired state already exists.** Closing an already-closed item is a no-op with exit 0, flagged in the payload. Reserve non-zero for intents that genuinely cannot be satisfied.
- **`--dry-run` for anything consequential**, and an explicit non-default flag for anything destructive.
- **Return identifiers in every mutation response** so the agent can tell whether it repeated work.
- **Strict idempotence is not always possible.** For append/send/trigger commands, make the mutation boundary explicit and return enough state to detect a replay.
- **Idempotence extends across the whole async arc** (§15). If a `--wait` invocation dies mid-poll, the next call must find the in-flight job, not submit a new one. That is what the job ledger is for.

> **Severity** — Silent duplication or state corruption on retry: **Blocker**. Destructive commands scriptable without preview: **Friction**. Idempotent mutations, durable job state, explicit destructive flags: **Optimization target**.

---

# Tier 2: Don't waste the context window

Tier 1 is about correctness. This tier is about cost. Every field, row, and character on stdout is charged against a context window, multiplied by how often the command runs. Narrow six ways: columns, rows, long fields, follow-up calls, empty answers, and ambient surfaces.

<!-- @
STRUCTURE DECISION: three tiers, not Trevin's two.

Trevin's tiers are Table Stakes / Compounding. AXI's token-economics material
(minimal schemas, truncation previews, aggregates) has no clean home there —
folding it under his principle 5 "bounded responses" buries the best material
in the source three levels deep. Splitting cost out as its own tier gives it a
home and makes the axis honest: correctness, then cost, then leverage.

Rejected: a flat list of 17 with no grouping. Scans faster but loses the
fix-these-first ordering, which is most of what makes the rubric actionable.
-->

## 6. Minimal default schemas — narrow the columns

Every field in a response costs tokens, multiplied by row count. Default to the smallest schema that lets the agent decide what to do next: typically an identifier, a label, and a status.

- **Default list schemas carry 3-4 fields, not 10.**
- **Long-form content belongs in detail views**, never in a list.
- **Offer `--fields`** so an agent can request more explicitly when it knows it needs more.
- **Default limits high enough to cover the common case in one call.** If most repos have under 100 labels, default to 100, not 30. A second page is a second round trip.

> **Severity** — Full records returned in every list: **Friction**. Minimal default with `--fields` to widen: **Optimization target**.

## 7. Bounded lists that teach the next query — narrow the rows

Filtering, pagination, and limits on every list-style command. When the CLI truncates, it should teach the agent how to narrow rather than hand it a parsing problem.

```
$ mycli post list --json
{"posts":[...20 items...],"total":312,"truncated":true,
 "hint":"narrow with --status published --since 7d, or page with --cursor"}

$ mycli post list --json --cursor=abc123
{"posts":[...],"next":null}
```

- **Bounded default page size**, with `--limit` and cursor-based continuation.
- **Concise versus detailed modes**, summaries and identifiers before raw detail.
- **The truncation message names the narrowing flags**, so the next query is better rather than merely longer.

> **Severity** — Routine commands dumping unbounded output: **Blocker**. Narrowing exists but defaults are broad: **Friction**. Bounded defaults that teach the next query: **Optimization target**.

## 8. Truncate with a preview, never omit — narrow the long fields

Detail views carry large text fields. Omitting them forces the agent to go hunting; including them in full wastes the context window. Do neither.

```json
{"number":42,"title":"Fix auth bug","state":"open",
 "body":"First 800 chars of the issue body...",
 "body_truncated":true,"body_chars_total":8432,
 "help":"mycli post view 42 --full for the complete body"}
```

- **Never omit a large field entirely** — include a truncated preview.
- **Report the total size** so the agent knows how much it is missing and can decide.
- **Suggest the escape hatch only when content was actually truncated.**
- **Pick a limit that covers most uses**, roughly 500-1500 characters.

> **Severity** — Large fields dropped silently, or dumped whole: **Friction**. Preview plus total size plus a `--full` hatch: **Optimization target**.

## 9. Pre-computed aggregates — kill the follow-up call

The most expensive token cost is usually not a longer response. It is a second invocation. If the backend can cheaply answer the question the agent will ask next, answer it now.

```json
{"posts":[...30 items...],"count":30,"total":847}
```

- **Include the total count in list output**, not just the page size. Without a definitive total the agent paginates to find out.
- **Include cheap derived status** where the next step almost always involves checking related state: `"checks":"3/3 passed"`, `"comments":7`.
- **Only what the backend provides cheaply.** A summary, not the full underlying data — otherwise this principle fights Tier 2's entire purpose.

> **Severity** — Page size returned with no total: **Friction**. Totals and cheap derived summaries inline: **Optimization target**.

## 10. Definitive empty states

When the answer is "nothing", say so unambiguously. An ambiguous empty result makes the agent re-run with different flags just to confirm it was not a mistake.

JSON gives most of this for free — `{"posts":[],"total":0}` is already an explicit zero, not a blank line. What is worth adding is **the context that proves the query ran as intended**:

```json
{"posts":[],"total":0,"filters":{"state":"closed"},"scope":"repo:acme/web"}
```

Echoing the applied filters back is stronger than prose, because it is checkable. The agent confirms `--state closed` was actually applied, which is the confidence the principle is really buying. It also doubles as a second line of defense against a silently dropped flag (§4).

<!-- @
Reframed from AXI principle 5, which prescribes prose: "tasks: 0 closed tasks
found in this repository". That wording exists because AXI's output is TOON/text
and a text list can degenerate to zero bytes. Once output is JSON (§2), the
bare-zero failure mode is already gone, so the prose form is largely redundant.

Considered folding this into §7 as one case of list-response shape. Kept
standalone because the checkable-filter-echo rule is a real, separate
instruction and it earns its own line in an audit.
-->

> **Severity** — Empty output indistinguishable from failure: **Blocker**. Explicit zero with no query context: **Friction**. Zero plus applied filters and scope: **Optimization target**.

## 11. Budget ambient surfaces, not on-demand ones

Description surfaces cost tokens too, and the question is *when you pay*.

**Pulled surfaces are cheap.** `--help` is fetched only when the agent asks for it, so it can afford to be generous — flags with defaults, required arguments, 2-3 examples.

**Pushed surfaces are expensive.** They load whether or not they are used, on every call or every session. Budget them hard:

- **MCP tool descriptions** load on every call. Most burn ~1,000 tokens on a single tool. Cloudflare serves ~3,000 operations in under 1,000 tokens total. Set a per-tool budget and audit it at build time, not "however much explanation felt natural."
- **Session-hook context** (§13) loads on *every* session. Include just enough for the agent to orient and act; deep data belongs in an explicit invocation.
- **Skill manifest frontmatter** is loaded to decide whether to load the skill. Keep the description trigger-shaped and terse.

This also resolves a tension between the two things Tier 2 asks for. Adding filters, limits and modes keeps *output* small, but each flag enlarges the surface that documents it. In a CLI that trade is nearly free, because `--help` is pulled. In an MCP wrapper it is not, because the description is pushed. Same flags, different bill.

<!-- @
This principle is ours, not either source's. Trevin's 10-post has a narrow
version ("a budget per tool description, audited at build time"). Widened to
cover every pushed surface after noticing that AXI principle 7's session-hook
context has exactly the same cost shape — it loads every session whether used
or not — as does skill frontmatter.

The pull/push framing also explains WHY the older 7-post could advocate a rich
flag surface (principle 7) plus fully documented help (principle 5) without
noticing a cost, and why the newer post hit it as soon as MCP entered: in a CLI
the documentation is pulled, in MCP it is pushed. That is the whole difference.

Reasoning trail: AXI 7 also argues (in "Why CLI over MCP?", 7-post) that this
is a structural argument for CLIs over MCP servers generally. Not stated in the
shipped text — it is a tool-choice argument, not a CLI-design rule.
-->

> **Severity** — An MCP or hook surface with no token budget: **Friction**. Every pushed surface budgeted and audited in CI: **Optimization target**.

---

# Tier 3: Compound

Tier 1 keeps you in the game and Tier 2 keeps you cheap. This tier makes the CLI *more* useful the more agents use it.

## 12. Cross-CLI vocabulary consistency

Agents do not memorize one CLI at a time. They build a generalized model of what CLIs do from every CLI they have seen. When your tool says `info` for what every other tool calls `get`, the agent does not fail — it succeeds slowly, after burning tokens on `--help`. Multiply that across thousands of invocations a week.

```
# Recognized immediately
$ mycli posts list --json
$ mycli posts get post_8f2a --json

# Has to be relearned for your tool specifically
$ mycli posts ls                        # use list, not ls
$ mycli posts info post_8f2a            # use get, not info
$ mycli post delete x --skip-confirmations   # use --force
$ mycli post list --format=json         # use --json
```

- **Use the dominant convention:** `get` / `list` / `create` / `update` / `delete`; `--force` for destructive bypass; `--yes` for confirmation; `--limit` for paging; `--json` for structured output.
- **Where you must invent vocabulary** because the concept is genuinely new, name it consistently across your own commands and document it once, prominently.
- **Internal consistency counts too.** If `posts list` takes `--limit` and `comments list` takes `--max-results`, the agent has to remember an arbitrary difference instead of reusing a pattern.
- **Enforce it mechanically** — see below. "Manually enforcing consistency through reviews is Swiss cheese."

> **Severity** — Verbs or flags contradicting universal conventions: **Blocker**. Internal inconsistency between your own subcommands: **Friction**. Schema-enforced vocabulary an agent recognizes on first encounter: **Optimization target**.

## 13. Three-layer introspection

Each layer answers a different question, and all three must be generated from the same source so they cannot drift.

**Layer 1 — `--help`: what does this command do?** Human-shaped text. Top level lists commands; each subcommand gives a one-line purpose, required arguments, flags with defaults, safety modifiers, and 2-3 concrete examples. Keep it scoped to the requested subcommand — never dump the whole manual. Examples matter more than they look like they should; without them the agent synthesizes an invocation from flag descriptions, which works but invites mistakes.

**Layer 2 — `agent-context`: what is the shape of everything?** A top-level subcommand emitting versioned, machine-readable JSON describing the full command surface. This is what an introspecting agent should actually consume.

```
$ mycli agent-context | jq '.commands.post.subcommands.create.flags'
{
  "--content":    {"type":"string","required":true},
  "--visibility": {"type":"enum","values":["public","private","unlisted"]},
  "--json":       {"type":"bool","default":false},
  "--dry-run":    {"type":"bool","default":false}
}
```

Carry a `schema_version` so a consuming agent can detect breaking shape changes. Surface the exit-code taxonomy (§2), available profiles (§16), and whether an upstream feedback channel exists (§17) here too — that is how an agent discovers them without parsing config files.

**Layer 3 — a skill manifest: when would I use this?** Long-form prose teaching the agent to compose operations into workflows, described from the perspective of tasks rather than commands. Ship it installable:

```sh
npx skills add <owner>/<repo> --skill <name>
```

- **Generate it from one source**, ideally the same content the no-args home view prints, and add a `--check` build step that fails CI if the committed skill is stale.
- **Strip live state.** A skill is static; dynamic data belongs to the runtime surfaces.
- **Write commands so they run without a global install** (`npx -y mytool ...`), since a skill can be installed on a machine where the binary is not on PATH.
- **Trigger-shaped frontmatter:** terse, outcome-focused, so the agent loads it on the right intent.

### Answer identity probes instantly

`-v`, `-V` and `--version` must all print the bare version and exit 0. Harnesses probe `--version` constantly — to confirm the tool is installed, to check whether a fix shipped, to decide whether to suggest an update. That makes latency an ergonomics property, not a perf tweak: 80 ms is paid at every session start, before any useful work happens.

The trap is static imports. If the entrypoint statically imports the module that builds the command graph, every dependency in that graph is evaluated *before* the version check runs, and one heavy import anywhere in the tree is paid on every probe. Keep the version in a leaf module that imports nothing but standard library, and defer the real CLI behind a dynamic import or lazy load.

Two things keep it honest: the version constant must live in a genuine **leaf** module (defined inside the CLI module, it re-pulls the whole graph and the fast path buys nothing), and the guard test should measure against the bare interpreter-startup floor **measured in the same process**, not an absolute millisecond budget that goes flaky across machines.

<!-- @
Generalized from AXI principle 10, which is written entirely around Node/ESM
and names `axi-sdk-js/fast-path` with a code sample. Dropped the vendor SDK and
the ESM specifics — the mechanism (don't evaluate the command graph to answer
an identity probe) applies to any language with import-time cost, and citing
one ecosystem's helper package would date fast.

Kept the two "keeps it honest" points verbatim in substance, because both are
non-obvious and both are how the optimization silently stops working.
-->

### Ambient context via session hooks (optional)

A CLI can register into an agent's session lifecycle so every conversation starts with relevant state already visible. If you do this: install only from an explicit user-invoked setup command, never from ordinary commands; make repeat installs idempotent no-ops; scope output to the current working directory; resolve the hook command to a PATH-verified binary name when it matches the current executable and an absolute path otherwise; and re-check the recorded path on each setup run so a reinstall or relocation repairs itself. Budget the injected context ruthlessly (§11) — it loads on every session.

<!-- @
AXI principle 7 is a long section: per-app integration detail for Claude Code
(~/.claude/settings.json, SessionStart), Codex (~/.codex/hooks.json plus
[features].hooks = true), and OpenCode (~/.config/opencode/plugins/), plus
lifecycle-capture-on-session-end.

Compressed to one paragraph deliberately. Those paths and config keys are
harness-specific and drift fast; a skill that names them is wrong within a
release or two, and being confidently wrong about a config path is worse than
being silent. The install-hygiene rules (explicit opt-in, idempotent, path
repair, directory-scoped, PATH-verified binary) are the durable part, so those
survive. The skill-manifest half of AXI 7 moved up into layer 3, where it
belongs — it is the same thing Trevin calls introspection layer 3.

Also: this is a distribution concern, not CLI ergonomics. Kept only because the
install-hygiene rules are genuinely easy to get wrong.
-->

> **Severity** — Only `--help`, nothing structured: **Blocker**. `agent-context` unversioned, or a skill manifest drifting from the real command surface: **Friction**. Three layers, schema-versioned, machine-validated against the implementation: **Optimization target**.

## 14. Content first, help on request

When an agent sees actual state it can act immediately. When it sees a usage manual it has to make a second call. Invocation therefore splits three ways:

**`--help` → help text.** Always, at every level. This is the explicit request path (§13, layer 1).

**No arguments, and the command can resolve to data → return the data.** A bare noun dispatches to its most useful read action rather than printing a subcommand menu:

```
# Conventional: a bare noun prints a menu
$ gh issue
Work with GitHub issues.
USAGE: gh issue <command> [flags]
AVAILABLE COMMANDS: close, create, list, view, ...

# Agent-native: a bare noun returns state
$ mycli issue
{"bin":"~/.local/bin/mycli","description":"Browse and manage issues",
 "count":14,"total":8771,
 "issues":[{"number":51815,"title":"[Bug]: plugin crash","state":"open"}, ...],
 "help":["mycli issue view <number> for details",
         "mycli issue create --title \"<title>\" to add one"]}
```

The top-level home view also **identifies the tool**: the absolute path of the current executable with `$HOME` collapsed to `~`, and a one-sentence description of what it does.

**No arguments, and mandatory input is genuinely missing → an enumerating error** (§3). Never a silent fallback to help — that reads as success and tells the agent nothing about what was missing.

**Gate:** a CLI with no ambient scope — a pure converter, a stateless API client with no workspace or account context — has nothing to show, and a bare invocation falls back to help. Content-first requires content.

<!-- @
DECISION: AXI principle 8 and Trevin's principle 5 (progressive help discovery)
initially looked contradictory. They are not, and the resolution is the user's:
Trevin governs the explicit --help FLAG; AXI governs a command invoked WITHOUT
its arguments. Confirmed against axi.md, whose own example contrasts `gh issue`
(bare noun -> subcommand menu) with the AXI form that returns issues — so the
claim is specifically about a bare noun defaulting to its most useful action.

The ambient-scope gate is ours; neither source states it. AXI writes the rule
unconditionally, which is wrong for a stateless tool with literally nothing to
list. Stated as a gate rather than a hedge so it is checkable in an audit.

Worth being explicit that this DEPARTS from the human-first norm (CLI Guidelines
et al. say a bare noun should print help). That is deliberate, and it is the
single most likely thing for a reviewer to flag as a bug. Do not quietly drop it
if challenged — the round-trip saving is the whole point.
-->

### Contextual disclosure

Include a few next steps that follow logically from the current output. The agent then discovers your surface area by using the tool, rather than reading a manual up front.

- **Relevant:** after an open item suggest closing; after an empty list suggest creating; after a list suggest viewing.
- **Actionable:** every suggestion is a complete command, carrying forward any disambiguating flags from the current invocation.
- **Parameterize dynamic values.** Use `<id>` or `"<title>"` placeholders rather than guessing a concrete value that may mislead.
- **Omit when self-contained.** A detail view, a count, or a confirmation fully answers the query; suggestions there are noise. Include them on list and mutation responses, where the next step is not obvious.
- **Guide discovery, not workflows.** Offer a variety of next actions rather than prescribing a sequence. An agent that already knows what it wants should never be nudged into an extra step.
- **Reveal truncation** (§7): when a list shows the most recent N of a larger total, say how to see the rest.

> **Severity** — Bare invocation prints a manual when live state was available: **Friction**. State plus identity header plus a few parameterized next steps: **Optimization target**.

## 15. Async-aware execution

*Applies to commands wrapping an async API.*

Most CLIs mirror the underlying HTTP shape: submit returns a job ID, poll returns a status, the rest is the agent's problem. Two failure modes follow. Either the agent writes its own poll loop — burning tokens and getting the backoff subtly wrong — or it does not, and the next step runs before the result exists.

The fix is `--wait`.

```
# Without --wait: the agent writes its own polling loop
$ mycli video render --script=story.txt --json
{"job_id":"job_8f2a","status":"queued"}
$ mycli video status job_8f2a --json
{"job_id":"job_8f2a","status":"running","progress":0.34}
...

# With --wait: one command, no polling logic
$ mycli video render --script=story.txt --wait --json
{"job_id":"job_8f2a","status":"complete","url":"https://.../out.mp4"}
```

- **`--wait` on every submitting command**, backed by a poll loop with exponential backoff and jitter.
- **A persistent job ledger** (`~/.mycli/jobs.jsonl` is fine) written as jobs progress.
- **A `jobs` parent command** exposing `list`, `get <id>`, and `prune`.
- **Recovery is the point** (§5): if a `--wait` invocation is killed mid-poll, the next invocation finds the in-flight job instead of submitting a duplicate.

> **Severity** — Async commands that return a job ID and stop: **Blocker**. `--wait` that does not survive disconnect, or no way to inspect in-flight jobs: **Friction**. `--wait` everywhere with a durable, recoverable ledger: **Optimization target**.

## 16. Persistent identity through profiles

*Applies to a CLI with configuration worth persisting.*

Agents do not show up once. They show up tomorrow, in a different shell, with the same underlying intent and a different specific input. A stateless CLI makes every invocation re-specify the same eight flags.

```
$ mycli profile save my-podcast --avatar=lila --voice=warm-en \
    --webhook=https://podcast.example.com/hook

$ mycli video create --profile=my-podcast --script=ep_42.txt --json
{"job_id":"job_8f2a","using_profile":"my-podcast"}

# Explicit flags win over profile values
$ mycli video create --profile=my-podcast --voice=energetic --script=... --json
{"job_id":"job_a91","using_profile":"my-podcast","voice":"energetic"}
```

- **Precedence: explicit flag > environment variable > profile > default.** Document it.
- **`profile save / use / list / show / delete`** subcommands, with `--profile <name>` as a persistent root flag.
- **A stable storage location** such as `~/.mycli/profiles.json`.
- **Surface the available profile names in `agent-context`.** This is the part that is usually missed, and it is how an introspecting agent discovers which identities exist without reading a config file.

> **Severity** — No way to persist configuration: **Friction**. Profiles that exist but are not discoverable through introspection: **Friction**. Named profiles with documented precedence, surfaced in `agent-context`: **Optimization target**.

## 17. Two-way I/O

Agents do not only consume a CLI through pipes, and a CLI does not only emit through stdout.

**Pipelining.** Accept input via flags, files, or stdin wherever it helps automation, and support `-` as a stdin/stdout alias when file paths are involved. Prefer flags for ambiguous multi-field operations; reserve positional arguments for conventional cases.

```
cat posts.json | mycli posts import --stdin
mycli posts list --json | jq -r '.posts[].title'
```

**Artifact delivery.** *Applies to commands that emit an artifact.* Route it where it is actually needed, rather than making the agent shuttle stdout into a temp file and move it:

```
$ mycli video create --script=story.txt --deliver=file:./out.mp4 --json
{"delivered_to":"file:./out.mp4","bytes":4823091}

$ mycli video create --script=story.txt --deliver=webhook:https://example.com/hook --json
{"delivered_to":"webhook:https://example.com/hook","status":201}

$ mycli video create --script=... --deliver=s3:bucket/key
error: --deliver scheme must be one of: stdout, file:<path>, webhook:<url>
```

File sinks write atomically. Webhook sinks POST and surface the HTTP status. Unknown schemes get a structured refusal that enumerates what is supported (§3).

**Feedback upstream.** Agents hit friction constantly — a flag rejected for the wrong reason, a race in an async path, an error that does not enumerate — and almost none of it is ever reported, because there is no channel. The agent retries, eventually succeeds, and the maintainer never learns the call was painful.

```
$ mycli feedback "the --tier flag rejects 'enterprise' but the docs list it as valid"
feedback recorded locally (1 entry)
```

Write local JSONL by default; POST upstream when an endpoint is configured. Surface in `agent-context` whether the upstream channel exists, so the agent knows if reporting will reach anyone.

<!-- @
`feedback` is the most speculative item in either source — no established
convention behind it, and it only pays off if a maintainer actually reads the
JSONL. Kept on an explicit call, because the cost is tiny (one subcommand, an
append-only file) and the failure it addresses is real and otherwise invisible.
If it turns out nobody implements it, demote to a one-line mention rather than
deleting — the diagnosis is sound even if the mechanism is unproven.
-->

> **Severity** — Commands that cannot participate in pipelines: **Blocker**. Output sinks that are not atomic, or a feedback channel that is not discoverable: **Friction**. Structured delivery and discoverable feedback, both versioned in introspection: **Optimization target**.

---

## Enforce mechanically, not in review

Almost everything in Tier 3 is hard to apply by hand and easy to apply from a schema. Vocabulary, introspection layers, async detection, profile precedence, delivery routing: each is the kind of thing you would be inconsistent about across a dozen subcommands if a human wrote them, and trivially consistent about if a template did.

This is why Cloudflare's TypeScript schema is the load-bearing detail of their post rather than a footnote. Generating the CLI, the SDKs, the Terraform provider, and the MCP server from one source is what makes the principles hold across thousands of operations without drift. **"Manually enforcing consistency through reviews is Swiss cheese."**

What this looks like in practice:

- **A documented naming policy**, and a static check in CI that fails on banned verbs and flag aliases (`ls`, `info`, `--skip-*`, `--format=json`).
- **Flag surfaces declared once**, so `--help`, `agent-context`, and unknown-flag validation (§4) cannot disagree.
- **A `--check` build step** asserting the committed skill manifest matches generated output (§13).
- **A token budget per pushed surface**, audited at build time (§11).
- **A hang test in CI** — every command run with stdin detached under a timeout (§1).

If you maintain a hand-written CLI of any size, the consistency bar keeps rising, and the only way to keep up is to move enforcement out of code review and into the schema or the build.

## Audit checklist

Walk the tiers in order and classify each finding by severity, scoped to what each command actually does.

- [ ] Every automatable command completes with flags alone; stdin detached under a timeout exits (§1)
- [ ] Non-TTY stdin never prompts; wrapped tools cannot prompt either (§1)
- [ ] `--json` on every data-returning command, one flag name across the whole CLI (§2)
- [ ] stdout carries data only; structured errors on stderr; logging off by default; ANSI suppressed off-TTY (§2)
- [ ] Exit-code taxonomy documented and exposed in `agent-context` (§2)
- [ ] Errors name the problem, show the invocation, enumerate the valid set, give an example (§3)
- [ ] No dependency stack traces, API errors, or upstream tool names leak through (§3)
- [ ] Unknown flags rejected by name with exit 2 and the valid set inline; `--help` always allowed (§4)
- [ ] Mutations idempotent or replay-detectable; `--dry-run` and explicit destructive flags; IDs returned (§5)
- [ ] List schemas 3-4 fields by default, widened via `--fields` (§6)
- [ ] Limits, filters and cursors on every list; truncation names the narrowing flags (§7)
- [ ] Large text fields previewed with total size and a `--full` hatch, never omitted or dumped (§8)
- [ ] Totals and cheap derived summaries included so the agent skips a follow-up call (§9)
- [ ] Empty results echo total, applied filters and scope (§10)
- [ ] Every pushed surface (MCP descriptions, hook context, skill frontmatter) has an audited budget (§11)
- [ ] Verbs and flags match the dominant convention; internal naming consistent across subcommands (§12)
- [ ] `--help`, versioned `agent-context`, and a generated skill manifest all present and in sync (§13)
- [ ] `--version` / `-v` / `-V` answer without loading the command graph, guarded by a floor-relative test (§13)
- [ ] Bare noun returns live state plus identity header and next steps, or falls back to help if unscoped (§14)
- [ ] Next-step suggestions are complete, parameterized, and omitted where output is self-contained (§14)
- [ ] `--wait` on async submissions, with a durable job ledger and `jobs list/get/prune` (§15)
- [ ] Profiles with documented precedence, surfaced in `agent-context` (§16)
- [ ] stdin and `-` supported; `--deliver` sinks atomic with enumerating refusals; `feedback` discoverable (§17)
- [ ] Consistency enforced by schema, codegen, or CI check rather than code review (Enforce mechanically)

<!-- @
## Learnings log

Author-only. Append one dated line per correction or rejected approach.

- 2026-08-16: Skill created by merging kunchenguid/axi's SKILL.md with Trevin
  Chow's "10 Principles for Agent-Native CLIs", plus four items pulled forward
  from his superseded "7 Principles for Agent-Friendly CLIs". Decisions were
  made interactively with the user; the reasoning for each contested call lives
  in an author note next to the relevant section rather than here. Summary of
  the contested ones: JSON over TOON (§2); errors on stderr with the exit code
  as discriminator, against AXI's stdout stance (§2); three tiers rather than
  Trevin's two (Tier 2 header); empty states reframed around echoing applied
  filters since JSON already makes zero explicit (§10); the MCP-description
  budget widened into a general pushed-vs-pulled surface principle (§11); AXI's
  session-hook section compressed to install hygiene only (§13); content-first
  and progressive help resolved as non-contradictory with an added
  ambient-scope gate (§14).

- 2026-08-16: The 0-5 exit-code taxonomy in §2 is a synthesis rather than a
  decision either source forced — neither commits to a set. Noted here because
  it is the one normative-looking table in the skill with no upstream authority
  behind it; reasoning is in the author note beside it. If a reader pushes back,
  the defensible core is "stable and discoverable via agent-context", not the
  specific integers.

- 2026-08-16: Rejected splitting the audit checklist into references/. The
  design and audit paths interleave — the severity lines live under each
  principle — so an agent loads the whole file either way and a second file
  would only add an import.
-->
