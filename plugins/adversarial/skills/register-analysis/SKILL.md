---
name: register-analysis
description: Answer questions about an organization's risk and incident data in Adversarial with exact numbers. Counts, breakdowns, trends, overdue and ownership reports, posture by threat objective, and summaries for leadership. Use when the user asks how many, which, who owns, what changed, what is overdue or trending, asks for a report, dashboard, chart or briefing, or asks for insights about their risks or incidents.
---

# Register analysis

Analysis only reads. Make no changes unless the user asks for one after seeing the results.

## Count with the server, not by reading rows

`list_risks` and `list_incidents` return `pagination.total_items`, the exact number of matching records. To count, call the list tool with the filters you need and `page_size` `1`, then read `total_items`. Never count the rows on a page: a page holds at most 200 records, and a partial count is wrong.

- **Breakdowns:** make one count call per bucket, in parallel. Examples: one per `urgency` for open risks, one per `severity` for incidents, one per assignee or `source`.
- **Trends:** bucket by date with inclusive `_after` and `_before` bounds, for example one call per month with `created_after` `2026-07-01` and `created_before` `2026-07-31`. For risks, use `closed_after`/`closed_before` for closures and `discovered_*` for discovery dates. Incidents have `occurred_*`, `detected_*`, `responded_*` and `contained_*` bounds, for example incidents contained in a given month.
- **Open risks:** `status` `New`, `Urgency Proposed`, `Remediation` and `Closure Proposed`. **Open incidents:** `New`, `In Progress` and `Review`.
- **Overdue risks:** open risks with `due_before` set to yesterday.
- **Unscored or unassigned:** pass the string `"null"`, for example `urgency` `["null"]` or `assigned_to` `["null"]`.
- **By threat:** call `get_threat_profile` for the objective names, then count with one `threat_objectives` value per call.

## When you need the rows

List results omit descriptions and most dates. Risk rows carry only `due_date` and `updated_date`; incident rows carry only `detected_date` and `updated_date`. If the question needs other fields:

1. Narrow with filters first, then fetch with `page_size` `200`, paging until `pagination.total_pages`.
2. Call `get_risk` or `get_incident` only for the records you will quote. For anything larger, take a sample and say it is a sample.
3. If more than about 1,000 rows would be needed, propose narrower filters before fetching.
4. If you can run code, aggregate the fetched rows in code rather than by eye.

## Reporting

1. Lead with the answer as numbers.
2. State the scope: the filters applied and the date the data was pulled.
3. Label anything that isn't an exact server count as a sample or an estimate.
4. Use a table when a breakdown has more than three buckets. Point to the IDs (`RSK-<n>`, `INC-<n>`) behind any finding the user may act on.
5. Name trends only across at least three time buckets. Don't explain a change with a cause the data doesn't show.
6. Offer one useful follow-up, such as rescoring the risks without a score or assigning the unowned ones.
