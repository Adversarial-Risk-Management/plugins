---
name: onboarding
description: First-run setup for the Adversarial plugin. Confirms which Adversarial organization and permissions this connection has, summarizes how the organization classifies risks and incidents, and suggests first tasks. Run right after the plugin is installed or reconnected, or when the user asks what Adversarial can do here or which organization they are connected to.
---

# Adversarial onboarding

Orient the user in their Adversarial organization. This skill only reads; make no changes during onboarding.

1. Call `whoami`. Tell the user which organization and account they are connected as. Translate the permission list into plain terms: what they can read, and whether they can create or edit risks and incidents, comment, or manage compliance documents. If a permission they are likely to need is missing, say an Adversarial admin grants it under **Settings → Team**.
2. Call `list_risk_sources`, `list_incident_sources`, `get_threat_profile` and `list_tags` in parallel. Summarize in a few lines how this organization classifies its work: the risk and incident sources, the threat objectives with their current likelihood and impact, and the available tags. Don't dump the raw lists.
3. Call `list_risks` with `urgency` `Critical` and `High`, `status` `New`, `Urgency Proposed`, `Remediation` and `Closure Proposed`, and `sort` `["-urgency"]`. Call `list_incidents` with `status` `New`, `In Progress` and `Review` and `sort` `["-severity"]`. Take the counts from `pagination.total_items`, then report them with the first three items of each by ID and title.
4. Offer two or three next steps that fit what you found. For example:
   - "Score RSK-12 against your risk methodology"
   - "Log an incident from this alert"
   - "Compare your access control policy with ours"

Keep the whole reply short enough to read at a glance.
