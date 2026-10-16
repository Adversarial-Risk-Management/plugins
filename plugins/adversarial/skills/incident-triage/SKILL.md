---
name: incident-triage
description: Log and triage security incidents in Adversarial. Creates incidents from alerts, tickets or chat, sets severity against the organization's incident response plan, links related risks or parent incidents, and keeps status and comments current. Use when the user reports an alert, breach, outage or suspicious activity, asks to open, escalate, update or close an incident, or asks for a status summary of open incidents.
---

# Incident triage

## Opening an incident

1. **Check for an existing incident.** Call `list_incidents` with a `query` built from the alert's key terms and `status` `New`, `In Progress` and `Review`. If one exists, update it or link the new one as a child with `parent_id`.
2. **Discover valid values.** Call these in parallel:
   - `list_incident_sources`: `source` must be one of these strings.
   - `get_threat_profile`: for threat objectives.
   - `list_tags`: for tags.
3. **Set severity from the plan.** Call `get_compliance_document` with slug `cirp`.
   - Choose `severity` from `SEV-1` to `SEV-5` using its definitions.
   - Write `severity_reasoning` that cites the criteria you applied.
   - If the facts are too thin to choose, say what is missing and propose a provisional severity.
4. **Record dates.** Fill `detected_date` and any containment dates you know. Bare `YYYY-MM-DD` dates are accepted.
5. **Confirm, then create.** Show the user the title, summary, source, severity with reasoning and assignee. Call `create_incident` only after they confirm. Then report the new `INC-<n>`.

## Updating an incident

- Read it first with `get_incident`.
- Change status in order: `New` → `In Progress` → `Review` → `Closed`.
- Record what changed and why with `add_incident_comment` alongside every status or severity change.
- Treat closing or deleting as a final step and confirm it explicitly. `delete_incident` is for duplicates and mistakes, never for resolved incidents.

## Status summary

Call `list_incidents` with `status` `New`, `In Progress` and `Review`, then group the results by severity. For each SEV-1 and SEV-2, include its owner and the date of the last update (from `get_incident` or `list_incident_comments`). Flag any incident with no recent update.
