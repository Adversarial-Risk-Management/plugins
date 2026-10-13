---
name: policy-gap-analysis
description: Compare a customer's or user's own security policy against the organization's approved Adversarial compliance documents and propose changes as one reviewable batch. Also reviews and decides pending compliance document proposals. Use when the user shares a policy to compare, asks what their policy is missing, asks to update or tailor a compliance document, or asks to review, approve or deny a policy proposal.
---

# Policy gap analysis

Compliance documents change only through proposals that a person with `documents:manage` approves. Never imply that a proposal has changed live policy.

## Comparing a policy

1. Call `list_compliance_documents` and pick the matching slug, for example `cisp`. If more than one could match, ask the user which.
2. Call `get_compliance_document` with that slug to read the approved live policy.
3. Call `get_compliance_document_editing_context` with the slug and the exact current version. It lists:
   - section keys
   - controls and their allowed values
   - supplements
   - any open proposal and the current workflow revision
4. Compare the user's policy one section at a time. If a section is long, pass `section_keys` to `get_compliance_document` rather than rereading the whole document. List the gaps by section: missing, weaker, stronger or conflicting.
5. Turn the gaps the user wants to act on into **one** `propose_compliance_document_changes` batch:
   - control settings, using allowed value IDs from the editing context
   - new supplements, or updates to existing supplement IDs
   - the exact `version` and the `expected_revision` you observed

   If the call fails because the revision is stale, fetch the editing context again and rebuild the batch. Never resend it unchanged.
6. Report the proposal ID, and tell the user it needs approval before anything goes live.

## Reviewing or deciding a proposal

1. Call `get_compliance_document_proposal` for the exact slug, version and proposal ID. Read the affected sections with `get_compliance_document` using `view` `proposal`.
2. Summarize what would change in plain language, including anything that weakens a control.
3. Call `decide_compliance_document_proposal` only when the user explicitly says approve or deny. Pass the revision you reviewed. Approval publishes immediately.
