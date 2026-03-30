---
description: "Use when writing, editing, reviewing, or extending Product Requirement Documents (PRDs) — including adding requirements, sections, open questions, use cases, acceptance criteria, or phase annotations. Covers tone, structure, traceability, and compliance rules for docs/prd-accounting.md and docs/prd-marketing.md."
applyTo: "docs/**/*.md"
---

# PRD Editing Guidelines

## Document Identity

Each PRD has a deliberate, distinct voice — preserve it:

| Document | Tone | Primary audience |
|---|---|---|
| `prd-accounting.md` | Formal, compliance-focused, precise | Accounting team, auditors, finance |
| `prd-marketing.md` | Upbeat, cheerful, enthusiastic (emoji use is intentional) | Marketing team, product |

Do **not** neutralise the marketing document's cheerful tone. Do **not** add informality to the accounting document.

## Requirement Quality Rules

Every requirement you add or modify must satisfy all of the following:

- **Scope** — state what is in scope and what is explicitly excluded.
- **Actor** — name who or what performs the action (system, user role, scheduled process).
- **Constraint** — specify thresholds, limits, formats, or conditions.
- **Expected outcome** — describe the observable result that confirms the requirement is met.
- **Testability** — the requirement must be verifiable without ambiguity.

Use `must`, `must not`, `should`, and `may` consistently. Avoid weak language like "ideally", "as needed", or "if possible" for launch-scope requirements.

## Structure & Formatting

- Use numbered sections and sub-sections (`## 3.`, `### 3.1`) to maintain navigability.
- Use markdown tables for requirement lists, comparisons, and lookup data (e.g., tax types, refund tiers, vehicle categories).
- Use bullet lists for enumerated constraints, actors, or conditions.
- Do not introduce dense prose paragraphs where a table or list communicates more clearly.

## Phase and Priority Annotations

Both PRDs use explicit phase labels. Preserve them on every edit:

| Label meaning | How to annotate |
|---|---|
| Required at go-live | No special marker, or note "Launch scope" |
| Available after go-live, within 90 days | Note "Phase 2 (90-day post-launch)" |
| Later or nice-to-have | Note "Later phase / deferred" |
| Cannot be firmly scoped yet | Note "Open question — see §X.Y" or add to the open questions section |

Do not silently promote a deferred item to launch scope, or demote a launch-scope item, without an explicit instruction from the user.

## Open Questions

- Open questions exist in both PRDs. Do not answer them or write requirements that assume an answer unless the user explicitly provides one.
- When adding a new open question, place it in the document's existing open questions section and assign it a unique identifier.

## Accounting PRD — Non-Negotiable Rules

When editing `prd-accounting.md`:

- **Do not weaken** compliance, auditability, segregation-of-duties, tax, or data retention requirements.
- Minimum audit trail retention is **7 years** — do not reduce this.
- Approval workflows and authorisation thresholds must remain explicit; do not make them configurable without specifying who holds that authority.
- Tax calculation, exemption logging, and multi-jurisdiction rules are regulatory requirements — they require auditability, not just functionality.
- Any requirement touching financial data must explicitly state whether it applies to B2C, B2B, or both.

## Marketing PRD — Non-Negotiable Rules

When editing `prd-marketing.md`:

- Preserve channel coverage (website, mobile app, phone/call centre, walk-in, OTA/third-party).
- Promotion types (discount codes, early-bird, bundles, flash sales, weekend specials) must remain individually configurable by the Marketing team without engineering involvement.
- Loyalty programme requirements must remain extensible across both rental and car sales activity.
- Segmentation and personalisation requirements must reference specific data attributes (e.g., recency, frequency, category preference) — do not make them generic.
- Consent management requirements must reference applicable regulation names (GDPR, CAN-SPAM, PECR or equivalent); do not remove these.

## Cross-PRD Consistency

When requirements in both PRDs share a concept (customer identity, deposits, corporate accounts, loyalty, multi-currency), ensure the language is consistent. If a concept is defined in one PRD, cross-reference it rather than defining it again.

## What Not to Do

- Do not copy long requirement blocks from one section to another — link instead.
- Do not add implementation details (architecture, code, technology choices) to PRD content.
- Do not close open questions or resolve business decisions without explicit user confirmation.
- Do not rewrite or restructure a whole section when a targeted addition or amendment is sufficient.
