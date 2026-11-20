# Adversarial plugins

Plugins that connect AI assistants to [Adversarial Risk Management](https://adversarial.com) through its MCP server (`https://api.adversarial.com/mcp`), with skills for common workflows.

`plugins/adversarial/` holds one set of skills with three manifests:

- `plugin.json` and `mcp.json`: the [Agent Plugins](https://agent-plugins.org) manifest, for ChatGPT, Codex and Cursor, listed in `.agents/plugins/marketplace.json`
- `.claude-plugin/plugin.json`: the Claude manifest, with the MCP server inline, listed in `.claude-plugin/marketplace.json`
- `.antigravity-plugin/plugin.json`, `mcp_config.json`, `logo.svg` and `README.md`: the [Antigravity](https://antigravity.google/docs/build-plugins) manifest. Antigravity reads `.antigravity-plugin/plugin.json` in place of the root one and ignores `mcp.json`.

The manifests use different schemas, so each is a separate file. Keep their `version` the same; `scripts/build.sh` fails when they differ. Antigravity's logo is an SVG that switches color in dark themes; it sits outside `assets/` because the Claude plugin directory rejects SVGs with `<style>` there.

Access requires a verified Adversarial organization. Each user signs in with their own Adversarial account, and every action runs with their permissions. The ticket tools need the `integrations:read` scope, which the `mcp` scope includes from platform release 2026.11.17. Connections made before that release must reconnect to use them.

## Install

- **ChatGPT workspace:** Admin console → Plugins → Add → Import marketplace, with this repository's URL.
- **Codex:** add this repository as a plugin marketplace.
- **Claude Code:** `/plugin marketplace add Adversarial-Risk-Management/plugins`, then `/plugin install adversarial@adversarial`.
- **Antigravity:** `agy plugin install <clone>/plugins/adversarial`, or unzip `adversarial-antigravity-<version>.zip` from a release and install that folder. Sign in from `/plugin`.
- **Microsoft Copilot Cowork:** upload `adversarial-m365-<version>.zip` from a release, in Cowork under Customize → Plugins → Add plugin, or tenant-wide in the Microsoft 365 admin center under Manage apps → Upload custom app.

## Releases

Each release attaches one zip per host, all built from `plugins/adversarial/` by `scripts/build.sh`:

| Zip | Layout | Hosts |
| --- | --- | --- |
| `adversarial-agent-plugins-<version>.zip` | Agent Plugins 1.0, as in this repo | ChatGPT, Codex, Cursor |
| `adversarial-claude-<version>.zip` | `.claude-plugin/plugin.json`, `skills/` and `assets/` | Claude |
| `adversarial-m365-<version>.zip` | Microsoft 365 app package (`manifest.json`, `color.png`, `outline.png`) | Copilot Cowork |
| `adversarial-antigravity-<version>.zip` | `.antigravity-plugin/plugin.json` at the root, `mcp_config.json`, `skills/`, `logo.svg`, `README.md` | Antigravity |

The M365 manifest is generated from `plugin.json`: descriptions come from the `com.openai` interface, and `extensions.com.microsoft` holds the fields only Microsoft uses. Its `id` identifies the app to Microsoft 365, so never change it. The connector declares no authorization, so Cowork registers its own OAuth client through the Adversarial MCP server's dynamic client registration.

To release, bump `version` in `plugin.json`, `.claude-plugin/plugin.json` and `.antigravity-plugin/plugin.json`, then push a date tag like the platform repo's, zero-padded (`2026.11.04` for version `2026.11.4`). The Release workflow builds the zips, validates the manifests, and publishes the GitHub release.

Check changes with `scripts/build.sh`, `claude plugin validate .`, `claude plugin validate plugins/adversarial --profile directory --strict` and `agy plugin validate dist/adversarial-antigravity-*.zip --strict`. `agy plugin validate plugins/adversarial` passes but warns about `mcp.json` and the root `plugin.json`, which belong to the other hosts.
