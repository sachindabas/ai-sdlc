# Project Guidelines

## Workspace Purpose

- This repository is a documentation and specification workspace for the Car Rental System initiative, not an executable application codebase.
- Treat the PRDs in `docs/` as the source of truth for business requirements, scope, and delivery priorities.
- Prefer improving requirements clarity, consistency, traceability, and structure over proposing implementation artifacts inside this repository.

## Key Documents

- See `docs/prd-accounting.md` for accounting, finance, tax, reconciliation, compliance, and approval workflow requirements.
- See `docs/prd-marketing.md` for marketing, pricing, promotions, channels, personalization, and analytics requirements.
- Link to existing sections or documents instead of copying long requirement blocks into new files.

## Editing Conventions

- Preserve the existing tone of each document: `docs/prd-accounting.md` is formal and compliance-focused; `docs/prd-marketing.md` is intentionally upbeat and should not be normalized to a neutral tone unless explicitly requested.
- Keep requirement changes precise and auditable. When adding content, make scope, actors, constraints, and expected outcomes explicit.
- Maintain the current markdown style: headings, numbered sections, bullet lists, and tables are preferred over dense prose.
- When updating requirements, keep phase distinctions intact such as launch scope, later phases, deferred work, open questions, and assumptions.
- Do not silently resolve open questions or business decisions unless the user provides the answer.

## Domain Guidance

- The product context assumes a new car rental line of business alongside an existing car sales business. Preserve that relationship in requirements that touch branding, customers, finance, or reporting.
- For accounting requirements, do not weaken compliance, auditability, segregation-of-duties, tax, or retention requirements.
- For marketing requirements, preserve channel, promotion, segmentation, and personalization intent while keeping business rules testable and unambiguous.

## Build And Test

- There are currently no build, test, or lint commands in this repository.
- Do not invent executable validation steps; validate by checking markdown structure, internal consistency, and alignment with the existing PRDs.

## Conventions

- Prefer small, targeted edits over broad rewrites.
- If a new document is needed, place it under `docs/` unless the user asks for a different structure.
- Cross-reference existing PRDs when requirements overlap instead of duplicating content.
