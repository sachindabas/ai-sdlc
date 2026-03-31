# Technical Requirements Document (TRD)

## Car Rental System — Car Management Module
### Feature: Initial Fleet Size & Growth Planning

| Field | Details |
|---|---|
| **Document Version** | 1.0 |
| **Date** | 2026-03-31 |
| **Prepared by** | Engineering Team |
| **Business Role** | Car Management Team |
| **Project** | Car Rental System (New Line of Business) |
| **Phase** | Planning & Requirements Analysis |
| **Status** | Draft |
| **PRD Reference** | [§2.1 Initial Fleet Size & Growth Planning](../prd-car-management.md#21-initial-fleet-size--growth-planning) |

---

## Table of Contents

1. [Overview](#1-overview)
2. [Scope](#2-scope)
3. [Data Model](#3-data-model)
4. [Functional Requirements](#4-functional-requirements)
5. [Business Rules](#5-business-rules)
6. [Admin Interface Requirements](#6-admin-interface-requirements)
7. [API Specifications](#7-api-specifications)
8. [Non-Functional Requirements](#8-non-functional-requirements)
9. [Acceptance Criteria](#9-acceptance-criteria)
10. [Dependencies & Assumptions](#10-dependencies--assumptions)
11. [Open Questions](#11-open-questions)
12. [Glossary](#12-glossary)

---

## 1. Overview

This TRD specifies the technical requirements for the **Initial Fleet Size & Growth Planning** feature of the Car Rental System's Car Management Module. The feature enables administrators to define the fleet composition at launch and progressively expand it as the business grows through the first operational year.

The requirements in this document are derived directly from [PRD §2.1](../prd-car-management.md#21-initial-fleet-size--growth-planning) and must be read alongside the supporting fleet-related sections of that PRD (§2.2 Vehicle Categories, §2.3 Vehicle Attributes, §2.5 Rental Locations).

### 1.1 Goals

- Allow administrators to configure a target fleet size per vehicle category, per rental location, at any point in time.
- Enable progressive vehicle additions without system downtime or code changes.
- Provide visibility into planned versus actual fleet counts, and projected fleet growth over time.

### 1.2 Actors

| Actor | Role |
|---|---|
| Administrator | Configures fleet capacity plans; adds, updates, and deactivates vehicles |
| Car Management Team | Monitors fleet growth against plan; triggers vehicle additions |
| System | Enforces business rules; maintains audit trail; exposes plan data to dependent modules |

---

## 2. Scope

### 2.1 In Scope

- Definition and storage of a fleet capacity plan (target vehicle count by category, by location, by date range).
- Adding new vehicles to the fleet at any time against the active plan.
- Tracking plan versus actual fleet counts in real time.
- Administrator UI and API for managing the fleet plan and individual vehicle registrations.
- Audit trail for all plan changes and vehicle additions.

### 2.2 Out of Scope

- Vehicle pricing, rental tariffs, and revenue planning (see `prd-accounting.md` and `prd-marketing.md`).
- Vehicle maintenance scheduling and service records (see [PRD §8](../prd-car-management.md#8-vehicle-maintenance--service)).
- Vehicle handover from the car sales inventory (see [PRD §2.4](../prd-car-management.md#24-vehicle-transition-from-car-sales-inventory)).
- Inter-location transfers (see [PRD §2.6](../prd-car-management.md#26-inter-location-vehicle-transfers)).
- Booking and availability engine (see [PRD §3](../prd-car-management.md#3-vehicle-availability--booking-fulfillment)).

---

## 3. Data Model

### 3.1 `fleet_capacity_plan`

Stores the administrator-defined target fleet configuration per category per location.

| Column | Type | Constraints | Description |
|---|---|---|---|
| `id` | UUID | PK, not null | Unique plan entry identifier |
| `location_id` | UUID | FK → `rental_location.id`, not null | Target rental location |
| `vehicle_category_id` | UUID | FK → `vehicle_category.id`, not null | Target vehicle category |
| `target_count` | INTEGER | not null, ≥ 1 | Planned number of vehicles for this category at this location |
| `effective_date` | DATE | not null | Date from which this plan target is active |
| `expiry_date` | DATE | nullable | Date after which this plan target is superseded; null = indefinite |
| `created_by` | UUID | FK → `system_user.id`, not null | Administrator who created this record |
| `created_at` | TIMESTAMP | not null, default now() | Record creation timestamp (UTC) |
| `updated_by` | UUID | FK → `system_user.id`, nullable | Administrator who last updated this record |
| `updated_at` | TIMESTAMP | nullable | Record last updated timestamp (UTC) |
| `notes` | TEXT | nullable | Free-text rationale or context for the plan entry |

- **Unique constraint**: `(location_id, vehicle_category_id, effective_date)` — only one target per category/location/date combination.

### 3.2 `vehicle`

Core vehicle record. Captures all attributes required by [PRD §2.3](../prd-car-management.md#23-vehicle-attributes).

| Column | Type | Constraints | Description |
|---|---|---|---|
| `id` | UUID | PK, not null | Unique vehicle identifier |
| `vin` | VARCHAR(17) | unique, not null | Vehicle Identification Number |
| `license_plate` | VARCHAR(20) | unique, not null | Current registration plate |
| `make` | VARCHAR(100) | not null | Manufacturer (e.g., Toyota, BMW) |
| `model` | VARCHAR(100) | not null | Model name |
| `year` | SMALLINT | not null | Manufacturing year |
| `color` | VARCHAR(50) | not null | Exterior colour |
| `fuel_type` | ENUM | not null | One of: `petrol`, `diesel`, `hybrid`, `electric` |
| `transmission` | ENUM | not null | One of: `manual`, `automatic` |
| `seating_capacity` | SMALLINT | not null, ≥ 1 | Number of passenger seats |
| `odometer_km` | INTEGER | not null, ≥ 0 | Current recorded mileage in kilometres |
| `vehicle_category_id` | UUID | FK → `vehicle_category.id`, not null | Assigned rental category |
| `location_id` | UUID | FK → `rental_location.id`, not null | Currently assigned rental branch |
| `status` | ENUM | not null | One of: `available`, `booked`, `in_service`, `under_maintenance`, `in_transit`, `retired` |
| `date_added_to_fleet` | DATE | not null | Date the vehicle was added to the rental fleet |
| `created_by` | UUID | FK → `system_user.id`, not null | Administrator who registered this vehicle |
| `created_at` | TIMESTAMP | not null, default now() | Record creation timestamp (UTC) |
| `updated_by` | UUID | FK → `system_user.id`, nullable | Administrator who last updated this record |
| `updated_at` | TIMESTAMP | nullable | Record last updated timestamp (UTC) |
| `retired_at` | TIMESTAMP | nullable | Timestamp when the vehicle was retired from the fleet |
| `notes` | TEXT | nullable | Free-text operational notes |

### 3.3 `vehicle_category`

Lookup table for vehicle categories as defined in [PRD §2.2](../prd-car-management.md#22-vehicle-categories).

| Column | Type | Constraints | Description |
|---|---|---|---|
| `id` | UUID | PK, not null | Unique category identifier |
| `name` | VARCHAR(100) | unique, not null | Category display name (e.g., Economy, SUV) |
| `description` | TEXT | nullable | Optional description |
| `is_active` | BOOLEAN | not null, default true | Whether the category is available for planning and assignment |
| `created_at` | TIMESTAMP | not null, default now() | Record creation timestamp (UTC) |

### 3.4 `rental_location`

Lookup table for rental locations referenced by fleet plan and vehicle records.

| Column | Type | Constraints | Description |
|---|---|---|---|
| `id` | UUID | PK, not null | Unique location identifier |
| `name` | VARCHAR(200) | not null | Branch name |
| `address` | TEXT | not null | Physical address |
| `is_active` | BOOLEAN | not null, default true | Whether the location is open for operations |
| `created_at` | TIMESTAMP | not null, default now() | Record creation timestamp (UTC) |

---

## 4. Functional Requirements

### 4.1 Fleet Capacity Plan Management

| ID | Requirement | Actor | Expected Outcome |
|---|---|---|---|
| FR-FP-01 | The system must allow an administrator to create a fleet capacity plan entry specifying a target vehicle count for a given category at a given location, with an effective date. | Administrator | A `fleet_capacity_plan` record is persisted; an audit log entry is created. |
| FR-FP-02 | The system must allow an administrator to update the target count or expiry date of an existing plan entry. | Administrator | The existing record is updated; the change is logged in the audit trail. |
| FR-FP-03 | The system must allow an administrator to deactivate a plan entry by setting its expiry date. | Administrator | The plan entry is marked expired; it is excluded from active plan calculations after the expiry date. |
| FR-FP-04 | The system must allow plan entries to be created independently per category and per location, enabling granular fleet composition control. | Administrator | Multiple plan entries can coexist for different category/location combinations. |
| FR-FP-05 | The system must allow administrators to create future-dated plan entries to pre-configure expected fleet growth milestones. | Administrator | Future-dated entries are stored and become active on their `effective_date`. |
| FR-FP-06 | The system must prevent duplicate active plan entries for the same `(location_id, vehicle_category_id, effective_date)` combination. | System | An error is returned; no duplicate record is created. |

### 4.2 Vehicle Registration (Adding Vehicles to the Fleet)

| ID | Requirement | Actor | Expected Outcome |
|---|---|---|---|
| FR-VR-01 | The system must allow an administrator to register a new vehicle by providing all mandatory attributes defined in [PRD §2.3](../prd-car-management.md#23-vehicle-attributes). | Administrator | A `vehicle` record is created with status `available`; the fleet count for the corresponding category and location increases by one. |
| FR-VR-02 | The system must enforce that the VIN and license plate are unique across all vehicles in the system. | System | Duplicate VIN or license plate submissions are rejected with a descriptive error. |
| FR-VR-03 | The system must support registering multiple vehicles in a single batch operation (bulk import). | Administrator | Valid vehicle records in the batch are committed; invalid rows are rejected with per-row error details; the batch uses partial-commit semantics where valid rows succeed independently of invalid rows. |
| FR-VR-04 | The system must allow a vehicle to be registered to any active location and any active category without requiring a corresponding fleet capacity plan entry. | System | Vehicle registration is not blocked if no plan entry exists. |
| FR-VR-05 | The system must record the `date_added_to_fleet` for every vehicle at the time of registration. | System | `date_added_to_fleet` is persisted automatically from the registration timestamp. |
| FR-VR-06 | The system must allow an administrator to retire a vehicle by updating its status to `retired` and recording a retirement timestamp. | Administrator | The vehicle is excluded from availability and capacity plan comparisons; a retirement audit log entry is created. |

### 4.3 Plan vs. Actual Fleet Tracking

| ID | Requirement | Actor | Expected Outcome |
|---|---|---|---|
| FR-PA-01 | The system must calculate and expose the current actual vehicle count per category per location in real time. | System | The count reflects all active (non-retired) vehicles assigned to that category and location. |
| FR-PA-02 | The system must calculate and expose the variance between the plan target and actual vehicle count for any given category/location at any point in time. | System | Variance = `target_count` (from the active plan entry on that date) minus actual count. |
| FR-PA-03 | The system must provide a summary view listing all active plan entries alongside their current actual counts and variances. | Car Management Team / Administrator | The summary is queryable via API and viewable in the admin UI. |
| FR-PA-04 | The system must allow filtering the plan vs. actual summary by location, category, and date range. | Car Management Team / Administrator | Filtered results are returned matching the specified criteria. |

---

## 5. Business Rules

| ID | Rule |
|---|---|
| BR-01 | A fleet capacity plan entry is considered **active** on a given date if `effective_date` ≤ that date AND (`expiry_date` is null OR `expiry_date` > that date). |
| BR-02 | If multiple plan entries exist for the same category and location with overlapping date ranges, the entry with the latest `effective_date` that is ≤ the query date takes precedence. |
| BR-03 | A vehicle with status `retired` must not be counted in the actual fleet count or in availability calculations. |
| BR-04 | A vehicle with status `in_transit` is counted in the **origin** location's actual fleet count until the transfer is completed. (See [PRD §2.6](../prd-car-management.md#26-inter-location-vehicle-transfers).) |
| BR-05 | The target count in a plan entry must be a positive integer (≥ 1). |
| BR-06 | Administrators must be the only user role permitted to create, update, or deactivate fleet capacity plan entries. |
| BR-07 | All changes to `fleet_capacity_plan` records (creates, updates, deactivations) must be recorded in the system audit log with the acting user's identity and a UTC timestamp. |
| BR-08 | Fleet capacity plan entries may be created before the corresponding vehicles or rental locations exist in the system, to allow pre-launch configuration. |

---

## 6. Admin Interface Requirements

| ID | Requirement |
|---|---|
| UI-01 | The admin interface must provide a **Fleet Capacity Plan** screen where administrators can view, create, edit, and deactivate plan entries. |
| UI-02 | The Fleet Capacity Plan screen must display plan entries in a tabular layout, sortable by location, category, effective date, and target count. |
| UI-03 | The admin interface must provide a **Plan vs. Actual** dashboard showing the current target, actual count, and variance for every active category/location combination. |
| UI-04 | The Plan vs. Actual dashboard must highlight rows where the actual fleet count is below the plan target (e.g., negative variance), to direct operational attention. |
| UI-05 | The admin interface must provide a **Vehicle Registration** form allowing entry of all mandatory vehicle attributes from [PRD §2.3](../prd-car-management.md#23-vehicle-attributes). |
| UI-06 | The Vehicle Registration form must include a **bulk import** option supporting CSV upload; the system must display a per-row validation report before committing the import. |
| UI-07 | All admin forms must require confirmation before destructive or irreversible actions (e.g., vehicle retirement). |

---

## 7. API Specifications

All endpoints use JSON over HTTPS. Authentication and authorisation follow the platform-wide identity standard. Administrators must hold the `fleet:admin` permission scope.

### 7.1 Fleet Capacity Plan Endpoints

| Method | Path | Permission | Description |
|---|---|---|---|
| `GET` | `/api/v1/fleet/capacity-plan` | `fleet:read` | List all fleet capacity plan entries; supports filtering by `location_id`, `category_id`, `date`. |
| `POST` | `/api/v1/fleet/capacity-plan` | `fleet:admin` | Create a new fleet capacity plan entry. |
| `PUT` | `/api/v1/fleet/capacity-plan/{id}` | `fleet:admin` | Update `target_count`, `expiry_date`, or `notes` for an existing plan entry. |
| `DELETE` | `/api/v1/fleet/capacity-plan/{id}` | `fleet:admin` | Deactivate a plan entry by setting `expiry_date` to the current date. |
| `GET` | `/api/v1/fleet/capacity-plan/summary` | `fleet:read` | Return plan vs. actual summary for all active category/location combinations. |

### 7.2 Vehicle Registration Endpoints

| Method | Path | Permission | Description |
|---|---|---|---|
| `GET` | `/api/v1/vehicles` | `fleet:read` | List vehicles; supports filtering by `location_id`, `category_id`, `status`. |
| `POST` | `/api/v1/vehicles` | `fleet:admin` | Register a new vehicle. |
| `GET` | `/api/v1/vehicles/{id}` | `fleet:read` | Retrieve a single vehicle record by ID. |
| `PUT` | `/api/v1/vehicles/{id}` | `fleet:admin` | Update vehicle attributes. |
| `POST` | `/api/v1/vehicles/bulk-import` | `fleet:admin` | Submit a batch of vehicle records for bulk registration. Returns per-row validation results. |
| `PATCH` | `/api/v1/vehicles/{id}/retire` | `fleet:admin` | Retire a vehicle; sets status to `retired` and records `retired_at`. |

### 7.3 Request / Response Conventions

- All timestamps are returned in ISO 8601 UTC format (`YYYY-MM-DDTHH:MM:SSZ`).
- All IDs are UUIDs.
- Validation errors return HTTP `422 Unprocessable Entity` with a JSON body listing per-field errors.
- Authorisation failures return HTTP `403 Forbidden`.
- Not-found responses return HTTP `404 Not Found`.

---

## 8. Non-Functional Requirements

| ID | Requirement | Category |
|---|---|---|
| NFR-01 | Fleet capacity plan read endpoints (`GET`) must respond within **500 ms** at the 95th percentile under normal load. | Performance |
| NFR-02 | The plan vs. actual summary endpoint must reflect vehicle additions within **60 seconds** of the vehicle being registered. | Data freshness |
| NFR-03 | Bulk vehicle import must support batches of up to **500 vehicles** per request without timeout or data loss. | Scalability |
| NFR-04 | All fleet capacity plan and vehicle registration data must be stored in the system's primary relational database with full ACID compliance. | Data integrity |
| NFR-05 | The audit log for fleet plan and vehicle changes must be retained for a minimum of **7 years** in line with the accounting PRD's data retention policy. | Compliance / Audit |
| NFR-06 | Access to fleet capacity plan management endpoints must be restricted to authenticated users holding the `fleet:admin` permission scope. | Security |
| NFR-07 | The bulk import endpoint must validate all rows before committing any; partial imports where some rows fail must commit only the valid rows and return a per-row error report. | Reliability |

---

## 9. Acceptance Criteria

| ID | Criterion | Verification Method |
|---|---|---|
| AC-01 | An administrator can create a fleet capacity plan entry for a given category, location, and effective date, and the entry is retrievable via the API. | Integration test / manual UAT |
| AC-02 | Creating a second plan entry with the same `(location_id, vehicle_category_id, effective_date)` returns a `422` error and no duplicate is created. | Integration test |
| AC-03 | An administrator can register a new vehicle with all mandatory attributes; the vehicle appears in the fleet list with status `available` and `date_added_to_fleet` set to today's date. | Integration test / manual UAT |
| AC-04 | Attempting to register a vehicle with a duplicate VIN or license plate returns a `422` error and no record is created. | Integration test |
| AC-05 | The plan vs. actual summary returns the correct target count, actual count, and variance for each active category/location combination. | Integration test |
| AC-06 | Retiring a vehicle removes it from actual fleet counts and the plan vs. actual summary. | Integration test |
| AC-07 | A bulk import of 500 vehicles completes successfully within the configured API timeout; per-row errors are reported without rolling back valid rows. | Load / integration test |
| AC-08 | All creates, updates, and deactivations of fleet capacity plan entries are recorded in the audit log with the acting user's ID and a UTC timestamp. | Audit log inspection |
| AC-09 | A user without the `fleet:admin` scope receives HTTP `403` when attempting to create or modify a plan entry or register a vehicle. | Security / integration test |
| AC-10 | A future-dated plan entry is not included in the active plan calculations until its `effective_date` is reached. | Integration test |

---

## 10. Dependencies & Assumptions

### 10.1 Dependencies

| Dependency | Detail |
|---|---|
| `rental_location` data | At least one active rental location must exist before fleet plan entries referencing it can be created. See [PRD §2.5](../prd-car-management.md#25-rental-locations). |
| `vehicle_category` data | At least one active vehicle category must exist before fleet plan entries or vehicle registrations referencing it can be created. See [PRD §2.2](../prd-car-management.md#22-vehicle-categories). |
| Authentication & authorisation service | The platform-wide identity and permissions system must be available to enforce the `fleet:admin` and `fleet:read` permission scopes. |
| Audit log service | A platform-level audit logging service must be in place to record all fleet plan and vehicle record changes. |

### 10.2 Assumptions

- The number of rental locations and initial vehicle categories will be confirmed and seeded into the system before launch as a one-time pre-launch data setup activity.
- Rental locations and vehicle categories are fully configurable by administrators without requiring code changes; new entries may be added at any time after launch.
- Vehicle count targets in the capacity plan are advisory/operational — they do not enforce a hard system cap on the number of vehicles that can be registered.
- The CSV format for bulk vehicle import will be defined and published as a separate data specification; this TRD assumes the format will include all mandatory vehicle attributes from [PRD §2.3](../prd-car-management.md#23-vehicle-attributes).
- "First year" growth in [PRD §2.1](../prd-car-management.md#21-initial-fleet-size--growth-planning) is an operational planning horizon; the system imposes no technical limit on when or how many vehicles may be added.

---

## 11. Open Questions

| ID | Question | Owner | Status |
|---|---|---|---|
| OQ-01 | What is the confirmed list of rental locations at launch? The number of locations affects the initial seeding of `rental_location` records and the fleet capacity plan configuration. | Product Owner | Open |
| OQ-02 | What is the confirmed initial target fleet size per category per location at launch? This is required to pre-populate the first fleet capacity plan entries. | Car Management Team / Product Owner | Open |
| OQ-03 | Should negative variance (actual < plan target) trigger an automated notification to the Car Management Team, and if so via which channel (in-system, email, SMS)? | Product Owner | Open |
| OQ-04 | What CSV column format and validation rules should be applied for bulk vehicle import? | Engineering / Car Management Team | Open |
| OQ-05 | Should plan entries be version-controlled (i.e., retain the full history of target count changes per category/location), or is the current state sufficient? | Product Owner | Open |

---

## 12. Glossary

| Term | Definition |
|---|---|
| Fleet Capacity Plan | An administrator-defined record specifying the target number of vehicles per category per location over a given date range. |
| Active Plan Entry | A `fleet_capacity_plan` record whose `effective_date` has been reached and whose `expiry_date` has not been reached (or is null). |
| Actual Fleet Count | The count of non-retired vehicles assigned to a specific category and location at a given point in time. |
| Variance | The difference between the plan target count and the actual fleet count; a negative value indicates fewer vehicles than planned. |
| VIN | Vehicle Identification Number — a unique 17-character identifier assigned to each vehicle. |
| Administrator | A system user holding the `fleet:admin` permission scope, authorised to manage fleet plan configuration and vehicle records. |
| Bulk Import | The ability to register multiple vehicles simultaneously via a structured file upload (CSV). |
| Retired Vehicle | A vehicle that has been permanently removed from the active rental fleet; status set to `retired`. |
