# Product Requirements Document (PRD)

## Car Rental System — Accounting Module

| Field | Details |
|---|---|
| **Document Version** | 1.0 |
| **Date** | 2026-03-29 |
| **Prepared by** | Product Owner |
| **Business Role** | Accounting Team |
| **Project** | Car Rental System (New Line of Business) |
| **Phase** | Planning & Requirement Analysis |
| **Status** | Draft |

---

## Table of Contents

1. [Overview](#1-overview)
2. [Chart of Accounts & Financial Structure](#2-chart-of-accounts--financial-structure)
3. [Revenue Recognition & Billing](#3-revenue-recognition--billing)
4. [Tax Management](#4-tax-management)
5. [Payments, Refunds & Reconciliation](#5-payments-refunds--reconciliation)
6. [Cost Tracking & Asset Management](#6-cost-tracking--asset-management)
7. [Corporate Accounts & Credit Management](#7-corporate-accounts--credit-management)
8. [Financial Reporting & Compliance](#8-financial-reporting--compliance)
9. [Approval Workflows & Internal Controls](#9-approval-workflows--internal-controls)
10. [Constraints & Priorities](#10-constraints--priorities)
11. [Glossary](#11-glossary)

---

## 1. Overview

The Car Rental System introduces a **new line of business** alongside the existing car sales operation. This PRD captures the accounting and financial requirements gathered from the Accounting Team during the requirement analysis phase. The system must support end-to-end financial management — from revenue recognition and billing through to cost tracking, compliance reporting, and internal controls — ensuring the rental business is financially transparent, audit-ready, and scalable across multiple locations.

### 1.1 Goals

- Establish a clean, auditable financial structure for the car rental business.
- Automate billing, tax calculation, and reconciliation workflows.
- Provide accurate, real-time financial reporting to support business decisions.
- Enforce internal controls and segregation of duties.
- Comply with applicable tax and financial reporting regulations.

### 1.2 Stakeholders

| Role | Responsibility |
|---|---|
| Accounting Team | Financial operations, reporting, compliance |
| Product Owner | Requirement definition and prioritization |
| IT / Engineering | System implementation |
| Management / CFO | Financial oversight and approval authority |
| External Auditors | Audit and regulatory review |

---

## 2. Chart of Accounts & Financial Structure

### 2.1 Business Unit / Cost Centre Classification

- Car rental revenue **must** be classified as a **separate business unit** within the chart of accounts, distinct from car sales revenue.
- A dedicated cost centre must be established for the rental business to enable granular profit and loss reporting.
- The system must allow the rental business unit to be linked to the parent company's consolidated accounts.

### 2.2 Cost Categories

The system must track the following cost categories for the rental business:

| Cost Category | Description |
|---|---|
| Vehicle Depreciation | Straight-line or declining-balance depreciation per vehicle |
| Fuel | Fuel costs incurred on company-operated vehicles |
| Maintenance & Repairs | Scheduled and unscheduled servicing costs |
| Insurance Premiums | Vehicle and liability insurance costs |
| Staffing | Salaries, wages, and contractor costs for rental staff |
| Location Overhead | Rent, utilities, and facilities costs per branch |
| Fleet Acquisition | Capital cost of purchased or financed vehicles |
| Marketing & Sales | Advertising and promotional costs |
| Technology | System licensing, hosting, and support costs |

### 2.3 Multi-Entity / Multi-Branch Accounting

- The system **must** support multi-branch accounting to reflect the planned expansion to new locations.
- Each branch must be identifiable as a separate cost centre or profit centre.
- Consolidated reporting across all branches must be available.
- Future multi-entity support (e.g., separate legal entities per region) should be architecturally considered, though it may be deferred post-launch.

### 2.4 Account Separation from Car Sales Business

- Rental and sales financial accounts must be **fully separated** with no commingling of revenue or direct costs.
- Shared overhead costs (e.g., head-office functions) may be allocated to the rental business unit via an agreed internal cost-allocation methodology.
- Shared payment gateways or bank accounts must support transaction-level tagging to distinguish rental vs. sales transactions.

### 2.5 Currency

- The **base currency** is the company's domestic currency (to be confirmed during implementation, e.g., USD, EUR, GBP).
- The system **must** support **multi-currency transactions** for international customers.
- Exchange rates must be sourced from a configurable rate feed (e.g., daily mid-market rate) and stored per transaction.
- Foreign-currency gains and losses must be recorded automatically upon settlement.

---

## 3. Revenue Recognition & Billing

### 3.1 Revenue Recognition Policy

- Rental revenue must be recognised **over the rental period** (straight-line, pro-rata per day) in accordance with accrual accounting principles.
- At booking creation, any advance payment is recorded as a **deferred revenue liability**.
- Revenue is recognised progressively from the rental start date to the rental end date.
- Any adjustments (e.g., early return, late return) must trigger a corresponding revenue adjustment.

### 3.2 Deposits & Pre-Authorisations

- Security deposits and card pre-authorisations must be recorded as **current liabilities** (deferred income / customer deposits account) until the rental is completed and the deposit is either applied or released.
- The system must track the status of each deposit: *held*, *partially applied*, *fully released*, or *forfeited*.

### 3.3 Invoice Generation

- The system must **automatically generate a final invoice** at the end of each rental upon vehicle return and completion of charges.
- Invoices must include, at minimum:
  - Invoice number and date
  - Customer name and contact details
  - Rental agreement reference number
  - Vehicle details (make, model, registration)
  - Rental period (start date, end date, number of days)
  - Base rental rate (per day / per week)
  - All add-on charges itemised separately (see §3.4)
  - Subtotal before tax
  - Tax breakdown (per applicable tax type)
  - Total amount due
  - Payment method and status
  - Company details and tax registration number

### 3.4 Add-On Charges Itemisation

All add-on charges must appear as **separate line items** on the invoice. Standard add-ons include:

| Add-On | Description |
|---|---|
| Additional Insurance | Collision Damage Waiver (CDW), Super CDW, etc. |
| GPS / Navigation Device | Daily rental fee |
| Child / Baby Seat | Daily rental fee |
| Additional Driver Fee | Per additional driver per day |
| Late Return Fee | Hourly or daily rate for late vehicle return |
| Fuel Surcharge | Refuelling charge if vehicle returned below agreed fuel level |
| Toll / Traffic Violations | Pass-through charges incurred during rental |
| Cleaning Fee | Excessive soiling charge |

### 3.5 B2C and B2B Billing

- The system must support both **B2C (individual consumer)** and **B2B (corporate account)** billing.
- B2C invoices must comply with consumer receipt requirements in the applicable jurisdiction.
- B2B invoices must include the corporate client's registered name, VAT/tax registration number, purchase order reference (where applicable), and be formatted for business accounting purposes.
- Corporate clients may receive **consolidated periodic invoices** (see §7.3) rather than per-rental invoices.

### 3.6 Partial, Split & Instalment Payments

- The system must support **split payments** across multiple payment methods (e.g., credit card + corporate credit).
- **Partial payments** (e.g., deposit at booking, balance at return) must be recorded as partial settlements against the invoice.
- **Instalment billing** for corporate accounts must allow multiple scheduled payment events against a single invoice, each generating a payment receipt.
- The accounting ledger must reflect the outstanding balance accurately at all times until the invoice is fully settled.

---

## 4. Tax Management

### 4.1 Applicable Tax Types

The system must support the following tax types, configurable per jurisdiction:

| Tax Type | Applicability |
|---|---|
| VAT (Value Added Tax) | EU and other VAT-registered jurisdictions |
| GST (Goods & Services Tax) | Australia, Canada, India, and others |
| Sales Tax | US state-level taxes |
| Rental-Specific Levies | Airport surcharges, municipality rental taxes |
| Tourism / Excise Tax | Jurisdiction-specific tourism-related levies |

### 4.2 Automatic Tax Calculation

- The system **must** automatically calculate and apply the correct tax rates based on:
  - The **rental pickup location** (determines the primary tax jurisdiction).
  - The **customer type** (B2C, B2B, or tax-exempt).
- Tax rate tables must be maintainable by the Accounting Team without developer intervention.

### 4.3 Tax-Exempt Customers

- The system must support **tax-exempt customer classifications**, including but not limited to:
  - Diplomatic clients
  - Registered businesses claiming input tax credits
  - Government entities
- Exemption status must be validated against a stored exemption certificate or registration number before tax is waived.
- All tax exemptions must be logged with the authorising reference and the staff member who applied the exemption.

### 4.4 Tax Reporting

- The system must generate **tax reports** per period (monthly, quarterly, and annually) broken down by:
  - Tax type
  - Tax jurisdiction
  - Taxable revenue vs. exempt revenue
  - Tax collected
- Reports must be exportable in formats compatible with tax authority submission requirements (e.g., CSV, XML, PDF).

### 4.5 Multi-Jurisdiction Tax Rules

- The system must support **different tax rules per location** to handle multi-jurisdiction operation.
- Each branch or pickup location must be mapped to a tax jurisdiction profile.
- Where a transaction spans multiple jurisdictions (e.g., one-way rental from Location A to Location B), the system must apply the primary jurisdiction rule (pickup location) unless local regulation specifies otherwise.

---

## 5. Payments, Refunds & Reconciliation

### 5.1 Refunds & Cancellation Policy

- The system must support configurable **refund policies based on cancellation timing**:

| Cancellation Timing | Refund Policy |
|---|---|
| More than 48 hours before rental start | Full refund of deposit and advance payment |
| 24–48 hours before rental start | Partial refund (e.g., 50% of rental charge) |
| Less than 24 hours before rental start | No refund of rental charge; deposit returned |
| No-show | No refund; deposit may be forfeited |

- All refund transactions must generate a **credit note** and be posted to the appropriate revenue and liability accounts.
- Refunds above a configurable monetary threshold must require management approval (see §9.1).

### 5.2 Security Deposit Release

- Security deposit releases must be processed through a defined workflow:
  1. Vehicle return and inspection completed.
  2. Any outstanding charges identified and deducted from the deposit.
  3. Net refundable amount approved and processed.
  4. Accounting entry reverses the deposit liability and records the net settlement.
- Release transactions must be traceable back to the original booking and deposit record.

### 5.3 Daily Reconciliation

- The system must support **daily reconciliation** of:
  - Payments received (by payment method: card, cash, bank transfer, corporate credit).
  - Bookings completed and invoices raised.
  - Outstanding receivables.
- A daily reconciliation report must be auto-generated and distributed to the Accounting Team.

### 5.4 Failed & Disputed Payments

- Failed payments must be:
  - Flagged in the system with the failure reason (e.g., insufficient funds, card expired, gateway timeout).
  - Recorded in a dedicated **failed payments ledger**.
  - Escalated to the Accounts Receivable team for follow-up within one business day.
- Disputed payments (chargebacks) must be:
  - Recorded against the original invoice.
  - Tracked through a dispute resolution workflow until resolved.
  - Posted to a suspense account until the dispute outcome is determined.

### 5.5 Bank Statement Reconciliation

- The system must support **semi-automatic bank reconciliation**:
  - Bank statement transactions are imported (via file upload or direct bank feed integration).
  - The system matches imported transactions to posted payment records.
  - Unmatched items are flagged for manual review.
- Full automated reconciliation is a post-launch enhancement; manual override must always be available.
- Reconciliation reports must be generated **daily**, with a formal review completed by the Accounting Team on a **weekly** basis.

---

## 6. Cost Tracking & Asset Management

### 6.1 Vehicle Capitalisation & Depreciation

- Vehicle acquisition costs must be **capitalised** as fixed assets on the balance sheet.
- The system must support the following depreciation methods, configurable per vehicle or vehicle category:
  - Straight-line depreciation
  - Declining-balance depreciation
- Depreciation must be posted automatically on a monthly basis to the appropriate expense account.
- Residual value assumptions must be configurable per vehicle type.

### 6.2 Per-Vehicle Profitability Tracking

- The system **must** track per-vehicle profitability, including:
  - Total rental revenue generated
  - Maintenance and repair costs
  - Insurance allocation
  - Depreciation charge
  - Net contribution margin per vehicle
- A per-vehicle P&L report must be available on demand and exportable.

### 6.3 Maintenance & Repair Cost Allocation

- Maintenance and repair costs must be allocated at **three levels**:
  - Per vehicle (primary allocation)
  - Per location / branch (secondary allocation for shared workshops)
  - Per cost centre (for management reporting)
- Unplanned repair costs above a configurable threshold must trigger a notification to the Finance Manager.

### 6.4 Insurance Premium Amortisation

- Vehicle insurance premiums paid upfront must be recorded as **prepaid expenses** (current assets) and amortised over the coverage period on a monthly straight-line basis.
- The system must track each insurance policy by vehicle, policy number, start date, end date, and premium amount.

### 6.5 Vehicle Write-Offs & Disposals

- Vehicle write-offs (total loss or end-of-life disposal) must follow a defined financial process:
  1. Net book value is calculated at the date of disposal.
  2. Proceeds from disposal (salvage, insurance payout) are recorded.
  3. The difference between net book value and proceeds is posted to a **gain/loss on disposal** account.
  4. The asset and accumulated depreciation accounts are cleared.
- All disposal transactions must be approved by the Finance Manager (see §9.1).

---

## 7. Corporate Accounts & Credit Management

### 7.1 Credit Terms for Corporate Clients

- The system must support configurable **credit terms** for approved corporate accounts, including:
  - Net 15, Net 30, Net 60 (and custom terms)
  - Credit limits (monetary cap on outstanding balance)
- Credit terms must be set per corporate account and enforced at booking creation.

### 7.2 Credit Limit Management

- The system must **enforce credit limits** at the point of booking:
  - If a new booking would cause the outstanding balance to exceed the approved credit limit, the booking must be flagged or blocked pending approval.
- Credit limit increases must be subject to an approval workflow (see §9.1).
- The Accounting Team must be able to view real-time credit utilisation per corporate account.

### 7.3 Consolidated Corporate Invoicing

- The system must be capable of generating **consolidated periodic invoices** for corporate clients that aggregate multiple rentals within a billing cycle (e.g., monthly).
- Consolidated invoices must list each rental as a separate line item, with a subtotal per rental and a grand total.
- Invoice frequency must be configurable per corporate account.

### 7.4 Overdue Invoice Tracking & Escalation

- The system must automatically flag invoices as overdue once payment is not received by the due date.
- An escalation workflow must be triggered as follows:

| Days Overdue | Action |
|---|---|
| 1–7 days | Automated payment reminder sent to corporate contact |
| 8–14 days | Secondary reminder and flag for Accounts Receivable review |
| 15–30 days | Escalation to Finance Manager; potential credit suspension |
| 30+ days | Escalation to Collections; credit terms suspended |

### 7.5 Collections Process

- The system must support a **collections workflow** for unpaid invoices, enabling the Accounting Team to:
  - Record collection activities (calls, emails, formal notices).
  - Log dispute details and resolution status.
  - Record partial recoveries and write-off decisions.
  - Track the status of each overdue account through to resolution.

---

## 8. Financial Reporting & Compliance

### 8.1 Standard Financial Reports

The system must generate the following reports for the Accounting Team:

| Report | Frequency | Description |
|---|---|---|
| Revenue by Vehicle Type | Monthly | Rental revenue broken down by vehicle category |
| Revenue by Location | Monthly | Rental revenue per branch / pickup location |
| Monthly P&L (Rental Business) | Monthly | Income statement for the rental business unit |
| Fleet Utilisation & Revenue | Weekly / Monthly | Occupancy rate and associated revenue per vehicle |
| Accounts Receivable Ageing | Weekly | Outstanding invoices grouped by age bucket |
| Tax Summary Report | Monthly / Quarterly | Tax collected per jurisdiction and tax type |
| Reconciliation Report | Daily / Weekly | Payment vs. booking reconciliation |
| Per-Vehicle Profitability Report | Monthly / On-demand | Net contribution per vehicle |
| Cost Centre Expenditure Report | Monthly | Costs by category and cost centre |
| Annual Budget vs. Actual | Annually | Variance analysis against budget |

### 8.2 Reporting Period Structure

- Standard reporting periods: **monthly, quarterly, and annually**.
- Financial year end and quarter-end dates must be configurable.
- Reports must be filterable by date range, branch, vehicle type, and customer type.

### 8.3 ERP / Accounting System Integration

- The system must support integration with the company's existing accounting or ERP platform. Target systems to be confirmed during implementation (e.g., SAP, Oracle Financials, QuickBooks, Xero).
- Integration must support:
  - Automated journal entry export (e.g., via API or structured file export in CSV / XML / JSON).
  - Real-time or near-real-time synchronisation of invoices, payments, and credit notes.
  - Chart of accounts mapping configuration.
- A manual export option (CSV / XLSX) must be available as a fallback.

### 8.4 Audit Trail Requirements

- The system must maintain a **complete, immutable audit trail** for all financial transactions, including:
  - Invoice creation, modification, and cancellation.
  - Payment receipt, reversal, and refund.
  - Tax calculation and adjustment.
  - Credit note issuance.
  - User identity, timestamp, and change description for every event.
- Audit logs must be retained for a minimum of **7 years** (or as required by local regulation, whichever is longer).
- Audit logs must not be editable or deletable by any user, including system administrators.

### 8.5 Data Retention Policy

- All financial transaction records must be retained for a minimum of **7 years** in accordance with standard accounting regulations.
- Records required for ongoing tax audits must remain accessible and unaltered for the duration of the audit.
- The system must support data archiving to cold storage after the active retention period without losing retrieval capability.

### 8.6 External Audit & Regulatory Reporting Support

- The system must be capable of producing an **audit-ready data export** covering any specified date range, including all transactions, adjustments, and supporting documentation.
- Reports required for regulatory submission (e.g., VAT returns, sales tax filings) must be generated in the format required by the relevant authority.
- The system must support the issuance of formal financial statements (Income Statement, Balance Sheet extracts) for the rental business unit.

---

## 9. Approval Workflows & Internal Controls

### 9.1 Financial Approval Workflows

The following transactions must be subject to defined approval workflows:

| Transaction Type | Approval Threshold | Approving Authority |
|---|---|---|
| Customer Refund | Above configurable threshold (e.g., > $500) | Finance Manager |
| Write-Off (Bad Debt) | Any amount | Finance Manager + CFO |
| Vehicle Write-Off / Disposal | Any amount | Finance Manager + CFO |
| Credit Limit Increase | Any increase | Finance Manager |
| Manual Invoice Adjustment | Any amount | Finance Supervisor |
| Discount / Override | Above configurable threshold | Finance Manager |
| Journal Entry Adjustment | Any post-close adjustment | Finance Manager |

### 9.2 Authority Matrix

- The system must enforce a **role-based authority matrix** defining who can perform which financial actions.
- Roles include (at minimum): Accounts Receivable Clerk, Accounts Payable Clerk, Finance Supervisor, Finance Manager, CFO, System Administrator.
- Authority levels and thresholds must be configurable without code changes.

### 9.3 Segregation of Duties

The following segregation of duties must be enforced by the system:

| Rule | Description |
|---|---|
| Invoice Creation vs. Payment Approval | The user who creates an invoice must not be able to approve the associated payment. |
| Refund Processing vs. Approval | The user who processes a refund must not be the same user who approves it above the threshold. |
| Journal Entry vs. Approval | The user who creates a manual journal entry must not be able to approve or post it. |
| Credit Limit Setting vs. Sales | The Accounting Team sets credit limits; Sales staff cannot modify them. |

### 9.4 Financial Period Locking

- The system must support **financial period locking** after month-end / quarter-end / year-end close.
- Once a period is locked, no backdated entries may be posted to that period without explicit approval from the Finance Manager.
- An audit record must be created whenever a locked period is unlocked and entries are posted.
- Period lock and unlock actions must be restricted to the Finance Manager role.

---

## 10. Constraints & Priorities

### 10.1 Hard Accounting Deadlines

- The system must be **operational from Day 1 of the rental business launch**.
- Key deadlines to be confirmed with the Finance team, such as:
  - Fiscal year start date
  - First VAT / GST filing date
  - First payroll run date for rental staff

### 10.2 Day-1 Must-Have Features (MVP)

The following features are **mandatory for the initial launch**:

| Feature | Rationale |
|---|---|
| Invoice generation (automated, end-of-rental) | Required for every customer transaction |
| Tax calculation and collection | Legal requirement |
| Payment recording and receipt generation | Required for all payment types |
| Basic chart of accounts setup (rental unit) | Required for financial reporting |
| Revenue recognition posting (deferred → earned) | Compliance with accrual accounting |
| Daily reconciliation report | Required for cash management |
| Audit trail for all transactions | Regulatory requirement |
| Security deposit recording and release | Required for every rental |
| Basic financial period management | Required for accurate reporting |

### 10.3 Post-Launch Enhancements (Phase 2)

The following features can be deferred to a subsequent release:

- Full automated bank reconciliation via direct bank feed.
- ERP real-time integration (file-based export acceptable for Day 1).
- Per-vehicle profitability dashboard (report is Day-1; dashboard is Phase 2).
- Multi-entity accounting (multi-branch is Day 1; separate legal entities deferred).
- Advanced collections workflow automation.

### 10.4 Financial Risks if Requirements Are Not Met

| Risk | Impact |
|---|---|
| Revenue not recognised correctly | Misstated financial statements; regulatory penalties |
| Tax not calculated or collected | Tax authority fines and back-tax liability |
| No audit trail | Failure of external audit; regulatory sanctions |
| Deposits not tracked as liabilities | Balance sheet misstatement |
| Refunds processed without approval | Financial loss and fraud exposure |
| No period locking | Data integrity issues; restatement risk |
| Failed reconciliation | Undetected revenue leakage or cash discrepancies |

---

## 11. Glossary

| Term | Definition |
|---|---|
| **B2B** | Business-to-Business — transactions with corporate clients |
| **B2C** | Business-to-Consumer — transactions with individual customers |
| **CDW** | Collision Damage Waiver — optional insurance add-on |
| **Chart of Accounts** | A structured list of all financial accounts used in the general ledger |
| **Cost Centre** | An organisational unit that incurs costs tracked separately |
| **Credit Note** | A document issued to reduce the amount a customer owes |
| **Deferred Revenue** | Revenue received but not yet earned; recorded as a liability |
| **Depreciation** | Systematic allocation of an asset's cost over its useful life |
| **GST** | Goods and Services Tax |
| **Journal Entry** | An accounting record of a financial transaction in the general ledger |
| **Net Book Value** | Asset cost minus accumulated depreciation |
| **P&L** | Profit and Loss statement (Income Statement) |
| **PRD** | Product Requirements Document |
| **Prepaid Expense** | Payment made in advance for services not yet consumed |
| **Reconciliation** | Process of verifying that two sets of records agree |
| **Segregation of Duties** | Internal control dividing financial tasks among multiple people to prevent fraud |
| **VAT** | Value Added Tax |

---

*End of PRD — Car Rental System Accounting Module v1.0*
