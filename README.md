# Adversarial plugins

Plugins that connect AI assistants to [Adversarial Risk Management](https://adversarial.com) through its MCP server (`https://api.adversarial.com/mcp`), with skills for common workflows.

`plugins/adversarial/` is an [Agent Plugins](https://agent-plugins.org) package: `plugin.json`, `mcp.json`, and `skills/`. Two catalogs point at it:

- `.agents/plugins/marketplace.json` for ChatGPT and Codex
- `.claude-plugin/marketplace.json` for Claude Code and Cowork, which declares the MCP server in the catalog entry

Access requires a verified Adversarial organization. Each user signs in with their own Adversarial account, and every action runs with their permissions.

## Install

- **ChatGPT workspace:** Admin console → Plugins → Add → Import marketplace, with this repository's URL.
- **Codex:** add this repository as a plugin marketplace.
- **Claude Code:** `/plugin marketplace add Adversarial-Risk-Management/plugins`, then `/plugin install adversarial@adversarial`.

- **Microsoft Copilot Cowork:** upload `adversarial-m365-<version>.zip` from a release, in Cowork under Customize → Plugins → Add plugin, or tenant-wide in the Microsoft 365 admin center under Manage apps → Upload custom app.

## Releases

Each release attaches one zip per host, all built from `plugins/adversarial/` by `scripts/build.sh`:

| Zip | Layout | Hosts |
| --- | --- | --- |
| `adversarial-agent-plugins-<version>.zip` | Agent Plugins 1.0, as in this repo | ChatGPT, Codex, Cursor |
| `adversarial-claude-<version>.zip` | `.claude-plugin/plugin.json` from the Claude catalog entry | Claude |
| `adversarial-m365-<version>.zip` | Microsoft 365 app package (`manifest.json`, `color.png`, `outline.png`) | Copilot Cowork |

The M365 manifest is generated from `plugin.json`: descriptions come from the `com.openai` interface, and `extensions.com.microsoft` holds the fields only Microsoft uses. Its `id` identifies the app to Microsoft 365, so never change it. The connector declares no authorization, so Cowork registers its own OAuth client through the Adversarial MCP server's dynamic client registration.

To release, bump `version` in `plugin.json` and in the `.claude-plugin/marketplace.json` entry, then push a `v<version>` tag. The Release workflow builds the zips, validates the manifests, and publishes the GitHub release.

Check changes with `scripts/build.sh`, `claude plugin validate .` and `claude plugin validate plugins/adversarial`.
