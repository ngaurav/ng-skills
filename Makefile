LITPROMPT ?= litprompt

# Layout: every source lives in a <category>-src/ tree and builds to the same
# relative path under <category>/, with the .src.md suffix reduced to .md.
#
#   marketing-src/technical-blog-writing/SKILL.src.md
#     -> marketing/technical-blog-writing/SKILL.md
#   marketing-src/technical-blog-writing/references/site-profile-template.src.md
#     -> marketing/technical-blog-writing/references/site-profile-template.md
#
# Source files are never named SKILL.md. That is deliberate: `npx skills add`
# matches the literal filename SKILL.md, so nothing in a -src tree is ever
# discovered as a skill, and author-only notes cannot reach an installation.
# litprompt.yaml cannot express a cross-tree rename, so builds run per file.

SRC_TREES := $(wildcard *-src)
PUB_TREES := $(patsubst %-src,%,$(SRC_TREES))
SOURCES   := $(shell find $(SRC_TREES) -name '*.src.md' 2>/dev/null | sort)

# <category>-src/a/b.src.md -> <category>/a/b.md
out_path = $(shell echo '$(1)' | sed 's|-src/|/|; s|\.src\.md$$|.md|')

.PHONY: build check verify orphans versions install-tool clean hash-generated

build:
	@test -n "$(SOURCES)" || { echo "ERROR: no *.src.md sources found"; exit 1; }
	@for src in $(SOURCES); do \
		out=$$(echo "$$src" | sed 's|-src/|/|; s|\.src\.md$$|.md|'); \
		mkdir -p "$$(dirname "$$out")"; \
		$(LITPROMPT) build "$$src" -o "$$out" -q || exit 1; \
		echo "  $$src -> $$out"; \
	done
	@echo "ok: built $(words $(SOURCES)) file(s)"

# Imports resolve, no cycles, nothing written. Plus the frontmatter contract.
check: versions
	@$(LITPROMPT) check . --match '**/*.src.md'

# Every skill source declares a semver `version:` in its frontmatter. Bumped by
# hand when a skill's behaviour changes, so an installed copy can be compared
# against this repo. Checked on the source only: the published file is a copy.
versions:
	@status=0; \
	for src in $$(find $(SRC_TREES) -name 'SKILL.src.md' 2>/dev/null | sort); do \
		v=$$(awk 'NR>1 && /^---$$/{exit} /^version:/{print $$2; exit}' "$$src"); \
		if [ -z "$$v" ]; then \
			echo "MISSING VERSION: $$src has no 'version:' in its frontmatter"; status=1; \
		elif ! echo "$$v" | grep -Eq '^[0-9]+\.[0-9]+\.[0-9]+$$'; then \
			echo "BAD VERSION: $$src has 'version: $$v', want MAJOR.MINOR.PATCH"; status=1; \
		fi; \
	done; \
	[ $$status -eq 0 ] && echo "ok: every skill declares a semver version"; exit $$status

# Every published file must trace back to a source. Catches a skill deleted
# from the source tree but left behind in the installable one.
orphans:
	@status=0; \
	for out in $$(find $(PUB_TREES) -name '*.md' 2>/dev/null | sort); do \
		src=$$(echo "$$out" | sed 's|/|-src/|; s|\.md$$|.src.md|'); \
		if [ ! -f "$$src" ]; then \
			echo "ORPHAN: $$out has no source at $$src"; status=1; \
		fi; \
	done; \
	[ $$status -eq 0 ] && echo "ok: no orphaned published files"; exit $$status

# Fail if anything published differs from a fresh build. Hashes before and
# after rather than reading git state, so it is honest whether or not the
# change is committed, and it catches a missing output too.
verify: orphans
	@before=$$($(MAKE) -s hash-generated); \
	$(MAKE) -s build >/dev/null || exit 1; \
	after=$$($(MAKE) -s hash-generated); \
	if [ "$$before" != "$$after" ]; then \
		echo "ERROR: published files are out of sync with their sources."; \
		echo "Run 'make build' and commit the result."; \
		git status --short -- $(PUB_TREES); \
		exit 1; \
	fi; \
	echo "ok: published files are in sync"

hash-generated:
	@find $(PUB_TREES) -name '*.md' 2>/dev/null | sort | xargs git hash-object

install-tool:
	go install github.com/tgvashworth/litprompt@latest

# The published trees are entirely machine-owned, so this is safe.
clean:
	@rm -rf $(PUB_TREES)
	@echo "removed: $(PUB_TREES)"
