---
name: risk-intake
description: Turn a finding, scan result, audit note, or conversation into a well-formed Adversarial risk, or rescore an existing one against the organization's risk methodology. Checks for duplicates, uses only the organization's own sources, tags and threat objectives, and records likelihood and impact with reasoning. Use when the user asks to log, file, create, rate, score, or rescore a risk, asks to turn an incident into a risk, or pastes a vulnerability or finding to track.
---

# Risk intake and scoring

## New risk

1. **Check for duplicates first.** Call `list_risks` with a `query` of two or three distinctive terms from the finding, such as a CVE, product or hostname. Every word must appear in the risk's title, description, remediation task or comments, so a long query misses near-duplicates. If nothing matches, try one other set of terms before concluding there is none. If an open risk already covers it, show it and offer to comment on or update it instead of creating another.
2. **Discover valid values before writing.** Call these in parallel:
   - `list_risk_sources`: `source` must be one of these strings.
   - `get_threat_profile`: `threat_objectives` names must come from here.
   - `list_tags`: reuse an existing tag before calling `create_tag`.
3. **Score with the organization's methodology.** Call `get_compliance_document` with slug `ramp`.
   - Pick `likelihood` and `impact` from its definitions.
   - Write `likelihood_reasoning` and `impact_reasoning` that cite the criteria you applied.
   - Never pass `urgency`. Adversarial computes it from likelihood × impact.
4. **Pick the class and assignee.**
   - Choose the class (`type`) from `Code`, `Configuration`, `Control Deficiency`, `Policy`, `Procedural`, `Vulnerability` or `Third-party`.
   - For `assigned_to`, use the name or email the user gave. If a name is ambiguous, ask which candidate they mean rather than guessing.
5. **Confirm, then create.** Show the user the title, description, source, class, likelihood and impact with reasoning, threat objectives, tags and assignee in one compact block. Call `create_risk` only after they confirm. Then report the new `RSK-<n>`.
6. **Link and track.** If the finding came from an incident, call `link_incident_to_risk`. To track remediation in Jira, Linear or ServiceNow, offer a ticket with the tickets skill.

When the user wants a risk for an existing incident, call `create_risk_from_incident` instead of `create_risk`. It takes the incident's title and threat objectives, sets the initially reported urgency from the incident's severity, and links the two. It sets no likelihood or impact, so score it as in "Rescoring an existing risk".

## Rescoring an existing risk

1. Call `get_risk` to read the current scores and reasoning.
2. Call `get_compliance_document` with slug `ramp` for the methodology.
3. **Confirm, then update.** Show the current and proposed likelihood and impact side by side, with the reasoning for each change. Call `update_risk` with `likelihood`, `impact`, `likelihood_reasoning` and `impact_reasoning` only after the user confirms.
4. If the score moved by more than one level, offer to add a comment explaining the change with `add_risk_comment`.
