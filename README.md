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

Check changes with `claude plugin validate .` and `claude plugin validate plugins/adversarial`.
