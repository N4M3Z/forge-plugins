## Publish Workflow

Publish a validated forge module as a standalone Claude Code plugin.

### Step 1: Run validation

Run the [Validate Workflow](SKILL.md#validate-workflow) on the target module. If validation fails, stop and present the issues. Do not proceed.

### Step 2: Determine marketplace identity

Read `marketplace.json` from the forge-plugins module:

```bash
cat Modules/forge-plugins/.claude-plugin/marketplace.json
```

Check if the module already has an entry:
- **Existing entry** -- this is a version update. Use the existing marketplace name and repo URL.
- **New entry** -- ask the user for the marketplace name. Suggest: strip `forge-` prefix, apply descriptive rename if the bare name is ambiguous. Confirm the GitHub org (default: `N4M3Z`).

### Step 3: Check or create standalone repo

```bash
gh repo view N4M3Z/<marketplace-name> --json name 2>/dev/null
```

If repo does not exist:

```bash
gh repo create N4M3Z/<marketplace-name> --public \
    --description "<description from plugin.json>"
```

### Step 4: Sync module content

Clone the standalone repo and sync the module files into it.

**Include:**
- `src/`, `bin/`, `hooks/`, `skills/`, `commands/`
- `.claude-plugin/plugin.json`
- `module.yaml`, `defaults.yaml`
- `Makefile`, `README.md`, `LICENSE`
- `CLAUDE.md`, `AGENTS.md`, `GEMINI.md`, `INSTALL.md`, `VERIFY.md`
- `.gitignore`, `.github/`
- `Cargo.toml`, `Cargo.lock` (if Rust module)
- `lib/` as a submodule reference (forge-lib)

**Exclude:**
- `target/`, `config.yaml`
- Provider dirs (`.claude/`, `.gemini/`, `.codex/`, `.opencode/`)

**Name update:** The standalone repo's `.claude-plugin/plugin.json` must use the marketplace name in the `name` field (not the forge-* name).

**First publish (empty repo):**
1. Copy all included files
2. Update plugin.json `name` to marketplace name
3. Add forge-lib as submodule: `git submodule add https://github.com/N4M3Z/forge-lib.git lib`
4. Commit: `feat: initial publish from forge-<name>`
5. Push

**Version update (existing repo):**
1. Sync changed files (rsync or manual copy)
2. Update version in plugin.json
3. Commit: `feat: update to v<version>`
4. Push

### Step 5: Tag the release

```bash
gh release create "v<version>" \
    --repo "N4M3Z/<marketplace-name>" \
    --title "v<version>" \
    --notes "Release v<version> from forge-<module-name>"
```

### Step 6: Update marketplace.json

For new entries, add to the `plugins` array:

```json
{
    "name": "<marketplace-name>",
    "description": "<description>",
    "source": {
        "source": "url",
        "url": "https://github.com/N4M3Z/<marketplace-name>.git"
    }
}
```

For existing entries, update `description` if it changed. Do not modify `source` unless the repo URL changed.

Write the updated `marketplace.json` using the Edit tool (or Write if restructuring).

### Step 7: Commit forge-plugins

Stage and commit the marketplace.json update in forge-plugins:

```bash
git -C Modules/forge-plugins add .claude-plugin/marketplace.json
git -C Modules/forge-plugins commit -m "feat: add <marketplace-name>"
git -C Modules/forge-plugins push
```

Then update the submodule pointer in the parent repo:

```bash
git add Modules/forge-plugins
```

### Step 8: Verify

```bash
gh repo view "N4M3Z/<marketplace-name>" --json name,description
```

Confirm the install command works:

```
/plugin marketplace add N4M3Z/forge-plugins
/plugin install <marketplace-name>@forge-plugins
```

Report: **PUBLISHED** with the version, repo URL, and install command.