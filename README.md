# Forge Plugins

Plugin marketplace for Claude Code. Publishes forge modules as standalone plugins that work independently or as part of the full forge ecosystem.

## Available Plugins

| Plugin                                                       | Description                                                                     |
| ------------------------------------------------------------ | ------------------------------------------------------------------------------- |
| [forge-finance](https://github.com/N4M3Z/forge-finance)     | Tax law rules, document analysis, and filing workflows for Czech personal income tax (DPFO) |

## Usage

Add this marketplace:

```sh
/plugin marketplace add N4M3Z/forge-plugins
```

Install a plugin:

```sh
/plugin install forge-finance@forge-plugins
```

Or test locally:

```sh
claude --plugin-dir /path/to/plugin
```

## Recommended Third-Party

| Plugin            | Source                    | Purpose                                          |
| ----------------- | ------------------------- | ------------------------------------------------ |
| safety-net        | `cc-marketplace`          | Safety guardrails for AI tool operations          |
| security-guidance | `claude-plugins-official` | Security best practices and vulnerability awareness |

## Skills

| Skill       | What it does                                                              |
| ----------- | ------------------------------------------------------------------------- |
| **Publish** | Validate marketplace readiness and publish forge modules as standalone plugins |

Invoke with `/Publish validate Modules/forge-tlp` or `/Publish` to start the publish workflow.

## Building

Rust plugins require the Rust toolchain ([rustup.rs](https://rustup.rs)):

```sh
cargo build --release
```

Shell plugins need only bash.

## License

[EUPL-1.2](LICENSE)
