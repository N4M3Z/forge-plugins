Validate and publish forge modules as standalone Claude Code plugins. Each forge module maps to a marketplace-friendly name and standalone GitHub repo.

## Workflow Routing

| Workflow | Trigger | Section |
|----------|---------|---------|
| **Validate** | "validate plugin", "check marketplace readiness" | [Validate Workflow](#validate-workflow) |
| **Publish** | "publish module", "release plugin" | @Publish.md |

## Conventions

### Name Mapping

Forge modules use `forge-*` internally but publish under user-friendly names. The marketplace name strips the `forge-` prefix and applies a descriptive rename when the bare name is ambiguous:

| Forge module | Marketplace name | Standalone repo |
|-------------|-----------------|-----------------|
| forge-tlp | context-tlp | N4M3Z/context-tlp |
| forge-reflect | session-reflect | N4M3Z/session-reflect |
| forge-avatar | load-avatar | N4M3Z/load-avatar |
| forge-journals | journals | N4M3Z/journals |

The marketplace name must be unique across the registry. Check `.claude-plugin/marketplace.json` in this module (forge-plugins) for the current registry.

### plugin.json Fields

The standalone repo's `.claude-plugin/plugin.json` needs these fields for marketplace publishing:

**Required (Claude Code plugin system):**

| Field | Format | Example |
|-------|--------|---------|
| `name` | string | `"context-tlp"` |
| `version` | semver | `"0.2.0"` |
| `description` | string | `"TLP file access control..."` |
| `author` | object | `{"name": "N4M3Z"}` |

**Marketplace-recommended:**

| Field | Format | Example |
|-------|--------|---------|
| `license` | SPDX identifier | `"EUPL-1.2"` |
| `repository` | URL string | `"https://github.com/N4M3Z/context-tlp"` |
| `keywords` | array | `["security", "access-control"]` |

**Component paths (include what applies):**

| Field | When |
|-------|------|
| `hooks` | Module has hooks: `"./hooks/hooks.json"` |
| `skills` | Module has skills: `["./skills"]` |

### Dual-Mode Detection

Every publishable module must work both as a forge-core submodule and as a standalone Claude Code plugin. Hook scripts detect mode via env vars:

```bash
if [ -n "$FORGE_MODULE_ROOT" ]; then
    MODULE_ROOT="$FORGE_MODULE_ROOT"
elif [ -n "$CLAUDE_PLUGIN_ROOT" ]; then
    MODULE_ROOT="$CLAUDE_PLUGIN_ROOT"
else
    MODULE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fi
```

Modules without this pattern will fail when installed as standalone plugins.

---

## Validate Workflow

### Step 1: Identify the target module

Accept either:
- Relative path: `Modules/forge-tlp`
- Module name: `forge-tlp` (resolve to `Modules/forge-tlp`)

If no argument, ask which module to validate.

### Step 2: Check plugin.json

Read `.claude-plugin/plugin.json` and verify:

| Check | Pass criteria |
|-------|---------------|
| File exists | `.claude-plugin/plugin.json` present |
| Valid JSON | Parses without error |
| `name` | Non-empty string |
| `version` | Valid semver (X.Y.Z) |
| `description` | Non-empty string |
| `author` | Object with `name` field |
| `license` | SPDX identifier present (warn if missing) |
| `repository` | URL string present (warn if missing) |
| `keywords` | Non-empty array (warn if missing) |

### Step 3: Check module.yaml

| Check | Pass criteria |
|-------|---------------|
| File exists | `module.yaml` present |
| `name` | Non-empty |
| `version` | Matches `plugin.json` version exactly |
| `description` | Non-empty |

### Step 4: Check documentation

| Check | Pass criteria |
|-------|---------------|
| `README.md` | Exists, not empty |
| `LICENSE` | Exists (required for marketplace distribution) |

### Step 5: Check standalone capability

For each `.sh` file in `hooks/`:

| Check | Pass criteria |
|-------|---------------|
| Dual-mode | References both `FORGE_MODULE_ROOT` and `CLAUDE_PLUGIN_ROOT` |
| Strict mode | Contains `set -euo pipefail` |
| Alias safety | Uses `command` prefix for `cd`, `cp`, `mv`, `rm` |

For each skill in `skills/`:

| Check | Pass criteria |
|-------|---------------|
| `SKILL.md` | Has `name:`, `description:`, `version:` in frontmatter |
| `SKILL.yaml` | Has `sources:` field |

### Step 6: Check binaries (if applicable)

If `Cargo.toml` exists:

| Check | Pass criteria |
|-------|---------------|
| Lazy build | `bin/_build.sh` exists (first-run compilation) |
| Binary names | Hook scripts reference binaries matching `[[bin]]` entries |

If no `Cargo.toml` -- shell-only module, skip this section.

### Step 7: Report

```
Section              Status
──────────────────────────────
plugin.json          PASS / FAIL (N issues)
module.yaml          PASS / FAIL (N issues)
Documentation        PASS / FAIL (N issues)
Standalone mode      PASS / FAIL (N issues)
Binaries             PASS / SKIP
──────────────────────────────
Verdict: READY TO PUBLISH / NOT READY (N blocking issues)
```

List specific failures with file paths and remediation hints. Warnings (missing `license`, `repository`, `keywords`) do not block but should be flagged.

@Publish.md

## Constraints

- Never publish a module that fails validation -- always run Validate first
- Never overwrite an existing marketplace.json entry without user confirmation
- The standalone repo name comes from the marketplace name, not the forge-* name
- Use `gh` CLI for all GitHub operations (repo create, release)
- marketplace.json is the single source of truth for the registry
- Version in plugin.json and module.yaml must match
- Standalone plugin.json `name` field uses the marketplace name (not forge-*)