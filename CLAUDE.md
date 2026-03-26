# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

Plugin marketplace and publishing module for the Forge ecosystem. Two responsibilities:

1. **Marketplace registry** — `.claude-plugin/marketplace.json` lists published plugins that users install via `/plugin marketplace add N4M3Z/forge-plugins`
2. **Publish skill** — validates forge modules for standalone plugin readiness and publishes them to individual GitHub repos

Each published plugin is an independent repo (e.g. `N4M3Z/context-tlp`) that works both as a forge submodule and as a standalone Claude Code plugin.

## Build

```sh
make install                # install skills (SCOPE=workspace|user|all)
make test                   # validate module structure
make lint                   # lint schemas and scripts
make check                  # verify prerequisites
make clean                  # remove installed skills
```

Requires forge-lib submodule (`lib/`). Run `make init` if not yet initialized.

## Key Files

| File                                | Purpose                                            |
| ----------------------------------- | -------------------------------------------------- |
| `.claude-plugin/marketplace.json`   | Plugin registry — source of truth for published plugins |
| `.claude-plugin/plugin.json`        | This module's own plugin manifest                  |
| `skills/Publish/SKILL.md`          | Publish skill — validate + publish workflow         |
| `skills/Publish/Publish.md`        | Publish workflow companion (step-by-step sync/release) |
| `module.yaml`                       | Forge module metadata                              |
| `defaults.yaml`                     | Skill dispatch config (multi-provider: claude, gemini, codex, opencode) |
| `build/`                            | Generated provider-specific skill copies            |

## Architecture

**Dual-mode design**: every publishable module must detect its runtime context:

```sh
if [ -n "$FORGE_MODULE_ROOT" ]; then
    # Running as forge submodule
elif [ -n "$CLAUDE_PLUGIN_ROOT" ]; then
    # Running as standalone plugin
fi
```

**Name mapping**: forge modules publish under user-friendly names (`forge-tlp` becomes `context-tlp`). The mapping lives in `skills/Publish/SKILL.md` and marketplace entries use the friendly name.

**Publish flow**: Validate (`plugin.json`, `module.yaml`, docs, standalone capability, binaries) then sync to standalone repo, tag release, update `marketplace.json`.

## Conventions

- `marketplace.json` entries use `"type": "url"` in the source object (not `"source": "url"`)
- Plugin names in `marketplace.json` use the marketplace-friendly name, not `forge-*`
- Version in `plugin.json` and `module.yaml` must match
- All GitHub operations use `gh` CLI
