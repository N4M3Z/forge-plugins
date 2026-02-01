# Forge Marketplace

Plugin marketplace for the [Forge Framework](https://github.com/N4M3Z/forge) — personal AI infrastructure for Claude Code.

Inspired by [danielmiessler/Personal_AI_Infrastructure](https://github.com/danielmiessler/Personal_AI_Infrastructure).

## Available Plugins

| Plugin | Description |
|--------|-------------|
| [context-tlp](https://github.com/N4M3Z/context-tlp) | Traffic Light Protocol file access control |

## Usage

Add this marketplace:

```
/plugin marketplace add N4M3Z/forge-plugins
```

Install a plugin:

```
/plugin install context-tlp@forge-plugins
```

Or test a plugin locally:

```bash
claude --plugin-dir /path/to/context-tlp
```

## Building

Plugins containing Rust binaries compile automatically on first use.
Requires the Rust toolchain: https://rustup.rs
