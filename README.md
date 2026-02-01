# Forge Plugins

Plugin marketplace for AI coding tools. Each plugin is a standalone CLI binary or shell script that any tool can invoke — Claude Code adapters included.

## Available Plugins

| Plugin | Type | Description |
|--------|------|-------------|
| [context-tlp](https://github.com/N4M3Z/context-tlp) | Rust | Traffic Light Protocol file access control with inline redaction |
| [session-reflect](https://github.com/N4M3Z/session-reflect) | Rust | Session reflection enforcement — blocks exit without memory writes |
| [load-avatar](https://github.com/N4M3Z/load-avatar) | Shell | Digital avatar — loads identity, preferences, and goals into AI sessions |

## What is an Avatar?

Your digital avatar is the set of markdown files that tell AI tools who you are. Think of it as **dotfiles for AI identity** — just as `.bashrc` configures your shell, avatar files configure your AI environment.

Three core files define your avatar:

- **Identity.md** — background, role, expertise
- **Preferences.md** — communication style, code conventions
- **Goals.md** — what you're working toward

The `load-avatar` plugin includes a scaffold with empty templates to create your own. See its [README](https://github.com/N4M3Z/load-avatar) for details.

## How They Compose

The three plugins form a complete AI session lifecycle:

1. **load-avatar** (SessionStart) — loads your identity, preferences, and goals
2. **context-tlp** (PreToolUse) — enforces file access policies during the session
3. **session-reflect** (PreCompact + Stop) — ensures learnings are captured before exit

Each is independent — install any subset.

## Recommended Third-Party

| Plugin | Source | Purpose |
|--------|--------|---------|
| safety-net | `cc-marketplace` | Safety guardrails for AI tool operations |
| security-guidance | `claude-plugins-official` | Security best practices and vulnerability awareness |

## Usage

Add this marketplace:

```
/plugin marketplace add N4M3Z/forge-plugins
```

Install plugins:

```
/plugin install context-tlp@forge-plugins
/plugin install session-reflect@forge-plugins
/plugin install load-avatar@forge-plugins
```

Or test locally:

```bash
claude --plugin-dir /path/to/plugin
```

## Building

Rust plugins require the Rust toolchain ([rustup.rs](https://rustup.rs)):

```bash
cargo build --release
```

Shell plugins (load-avatar) need only bash.
