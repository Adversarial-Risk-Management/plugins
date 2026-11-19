---
name: tickets
description: Open, link, list and unlink Jira, Linear or ServiceNow tickets on Adversarial risks and incidents through the organization's ticket integrations. Use when the user asks to file, open, create or attach a ticket for a risk or incident, link an existing ticket, see which tickets track a record, or remove a ticket link.
---

# Tickets

Tickets go through the organization's ticket integrations. Each integration files tickets for one register: `risk` or `incident`.

## Pick the integration

1. Call `list_ticket_integrations`. Use only integrations with `available` `true` whose `register` matches the record.
2. If exactly one matches, you may omit `integration_id`. If more than one matches, ask the user which one.
3. If none exists, tell the user an Adversarial admin connects one under **Settings → Integrations**. If the call fails with a permission error, the connection may predate ticket support: tell the user to disconnect and reconnect the Adversarial plugin.

## Open a new ticket

1. Read the record with `get_risk` or `get_incident`, and check `list_linked_tickets` so you don't file a duplicate.
2. Ask for the `project`: the Jira project key, Linear team key or ServiceNow table. For Jira, also ask for an optional `epic`.
3. **Confirm, then create.** Show the record ID, integration and project. The ticket is built from the record's details. Call `create_ticket` with exactly one of `risk_id` or `incident_id` only after the user confirms. Report the ticket `key` and `url`.

## Link an existing ticket

1. If the user doesn't give the key, call `search_tickets` with the `integration_id` and two or three distinctive terms. ServiceNow needs `project` (the table).
2. Call `link_ticket` with the `ticket_key`. For ServiceNow, pass the table as `project`. Linking doesn't change the provider ticket.

## List or unlink

- `list_linked_tickets` takes exactly one of `risk_id` or `incident_id`. A ticket with `available` `false` is no longer returned by the provider. Its link can still be removed.
- To unlink, pass the `link_id` and `integration_id` from `list_linked_tickets` to `unlink_ticket`. Confirm first. Unlinking doesn't close or change the provider ticket.

To find records with or without a ticket, see `ticket` in `list_risks` and `list_incidents`: `"any"` or `"null"`.
