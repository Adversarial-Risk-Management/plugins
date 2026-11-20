#!/usr/bin/env bash
# Builds one zip per host from plugins/adversarial into dist/:
#   adversarial-agent-plugins-<v>.zip  Agent Plugins 1.0 (ChatGPT, Codex, Cursor, ...)
#   adversarial-claude-<v>.zip         Claude plugin layout
#   adversarial-m365-<v>.zip           Microsoft 365 app package (Copilot Cowork)
set -euo pipefail

root=$(cd "$(dirname "$0")/.." && pwd)
src="$root/plugins/adversarial"
dist="$root/dist"
manifest="$src/plugin.json"
version=$(jq -r .version "$manifest")

claude_version=$(jq -r .version "$src/.claude-plugin/plugin.json")
if [[ "$claude_version" != "$version" ]]; then
  echo "version mismatch: plugin.json $version, .claude-plugin/plugin.json $claude_version" >&2
  exit 1
fi

# Cowork rejects a skill whose frontmatter name differs from its folder.
for skill in "$src"/skills/*/; do
  folder=$(basename "$skill")
  name=$(sed -n 's/^name: *//p' "$skill/SKILL.md" | head -n1)
  if [[ "$name" != "$folder" ]]; then
    echo "skills/$folder/SKILL.md: name '$name' doesn't match its folder" >&2
    exit 1
  fi
done

rm -rf "$dist"
mkdir -p "$dist"
stage=$(mktemp -d)
trap 'rm -rf "$stage"' EXIT

(cd "$src" && zip -qr "$dist/adversarial-agent-plugins-$version.zip" . -x '.*')

(cd "$src" && zip -qr "$dist/adversarial-claude-$version.zip" .claude-plugin skills assets)

m365="$stage/m365"
mkdir -p "$m365"
cp -R "$src/skills" "$m365/"
cp "$src/assets/color.png" "$src/assets/outline.png" "$m365/"
# Descriptions are shared with the ChatGPT listing; com.microsoft holds only what Microsoft alone needs:
# its publisher name and a long description with the account requirement and onboarding links.
# The connector has no authorization block: Cowork registers its own OAuth client through our DCR endpoint.
jq --slurpfile mcp "$src/mcp.json" '
  .extensions["com.openai"].interface as $ui
  | .extensions["com.microsoft"] as $ms
  | {
      "$schema": "https://developer.microsoft.com/json-schemas/teams/v1.29/MicrosoftTeams.schema.json",
      manifestVersion: "1.29",
      version,
      id: $ms.id,
      developer: {
        name: ($ms.developerName // .author.name),
        websiteUrl: .homepage,
        privacyUrl: $ui.privacyPolicyURL,
        termsOfUseUrl: $ui.termsOfServiceURL
      },
      name: {short: $ui.displayName, full: "\($ui.displayName) Risk Management"},
      description: {short: $ui.shortDescription, full: ($ms.longDescription // $ui.longDescription), features: $ms.features},
      icons: {color: "color.png", outline: "outline.png"},
      accentColor: $ms.accentColor,
      agentSkills: [$skills[] | {folder: "./skills/\(.)"}],
      agentConnectors: [$mcp[0].mcpServers | to_entries[] | {
        id: .key,
        displayName: $ui.displayName,
        description: $ui.shortDescription,
        toolSource: {remoteMcpServer: {mcpServerUrl: .value.url}}
      }]
    }' --argjson skills "$(cd "$src/skills" && printf '%s\n' */ | sed 's:/$::' | jq -R . | jq -s .)" \
  "$manifest" > "$m365/manifest.json"
(cd "$m365" && zip -qr "$dist/adversarial-m365-$version.zip" .)

ls -1 "$dist"
