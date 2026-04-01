# Database Design — Fleet Categorization

## Car Rental System — Car Management Module

| Field | Details |
|---|---|
| **Document Version** | 1.0 |
| **Date** | 2026-04-01 |
| **Prepared by** | Engineering Team |
| **Project** | Car Rental System (New Line of Business) |
| **Phase** | Planning & Requirements Analysis |
| **Status** | Draft |
| **TRD Reference** | [trd-car-management-fleet-size-growth-planning.md](../trd/trd-car-management-fleet-size-growth-planning.md) |
| **PRD Reference** | [prd-car-management.md §2 — Fleet Inventory & Vehicle Setup](../prd-car-management.md#2-fleet-inventory--vehicle-setup) |

---

## Table of Contents

1. [Overview](#1-overview)
2. [Scope](#2-scope)
3. [ENUM Type Definitions](#3-enum-type-definitions)
4. [Table Definitions](#4-table-definitions)
   - [4.1 `vehicle_category`](#41-vehicle_category)
   - [4.2 `rental_location`](#42-rental_location)
   - [4.3 `fleet_capacity_plan`](#43-fleet_capacity_plan)
   - [4.4 `vehicle`](#44-vehicle)
5. [Indexes](#5-indexes)
6. [Seed Data — Vehicle Categories](#6-seed-data--vehicle-categories)
7. [Business Rules Enforced at Database Level](#7-business-rules-enforced-at-database-level)
8. [Migration Notes](#8-migration-notes)

---

## 1. Overview

This document provides the concrete PostgreSQL DDL for the fleet categorization data model defined in [TRD §3](../trd/trd-car-management-fleet-size-growth-planning.md#3-data-model). It covers the four core tables:

- **`vehicle_category`** — lookup table of rental vehicle categories (Economy, SUV, etc.).
- **`rental_location`** — lookup table of rental branches.
- **`fleet_capacity_plan`** — administrator-defined target vehicle counts per category per location per date range.
- **`vehicle`** — canonical vehicle record tracking all attributes required by [PRD §2.3](../prd-car-management.md#23-vehicle-attributes).

The `vehicle_category` table is the central entity for fleet categorization; it is referenced by both `fleet_capacity_plan` and `vehicle`. All tables use UUID primary keys and UTC timestamps.

---

## 2. Scope

### In Scope

- DDL for all four entities in the fleet categorization data model.
- ENUM type definitions for `fuel_type`, `transmission`, and `vehicle_status`.
- Unique constraints, check constraints, and foreign key relationships.
- Performance indexes for common query patterns (fleet plan lookups, vehicle filtering by category/location/status).
- Seed data for the standard vehicle categories defined in [PRD §2.2](../prd-car-management.md#22-vehicle-categories).

### Out of Scope

- Application-layer audit log tables (platform-level concern; see [TRD §NFR-05](../trd/trd-car-management-fleet-size-growth-planning.md#8-non-functional-requirements)).
- `system_user` table DDL — the `system_user` entity is defined and owned by the platform-wide identity service; the foreign key references in this schema depend on that table existing.
- Vehicle assignment, maintenance block, hold, and waitlist tables — see the Vehicle Assignment TRD ([trd-car-management-vehicle-assignment.md](../trd/trd-car-management-vehicle-assignment.md)).

---

## 3. ENUM Type Definitions

These custom ENUM types must be created before the `vehicle` table.

```sql
-- Fuel type options for a vehicle
CREATE TYPE fuel_type AS ENUM (
    'petrol',
    'diesel',
    'hybrid',
    'electric'
);

-- Transmission type options for a vehicle
CREATE TYPE transmission_type AS ENUM (
    'manual',
    'automatic'
);

-- Lifecycle status of a vehicle within the rental fleet
CREATE TYPE vehicle_status AS ENUM (
    'available',
    'booked',
    'in_transit',
    'under_maintenance',
    'on_hold',
    'retired'
);
```

---

## 4. Table Definitions

### 4.1 `vehicle_category`

Lookup table for rental vehicle categories as defined in [PRD §2.2](../prd-car-management.md#22-vehicle-categories). New categories must be addable by administrators without code changes ([TRD §3.3](../trd/trd-car-management-fleet-size-growth-planning.md#33-vehicle_category)).

```sql
CREATE TABLE vehicle_category (
    id          UUID        NOT NULL DEFAULT gen_random_uuid(),
    name        VARCHAR(100) NOT NULL,
    description TEXT,
    is_active   BOOLEAN     NOT NULL DEFAULT TRUE,
    created_at  TIMESTAMP   NOT NULL DEFAULT NOW(),

    CONSTRAINT vehicle_category_pkey PRIMARY KEY (id),
    CONSTRAINT vehicle_category_name_unique UNIQUE (name)
);

COMMENT ON TABLE  vehicle_category             IS 'Lookup table of rental vehicle categories (e.g. Economy, SUV). Source of truth for fleet categorization.';
COMMENT ON COLUMN vehicle_category.id          IS 'Unique category identifier (UUID).';
COMMENT ON COLUMN vehicle_category.name        IS 'Display name of the category. Must be unique (e.g. Economy, Compact, SUV).';
COMMENT ON COLUMN vehicle_category.description IS 'Optional human-readable description of the category.';
COMMENT ON COLUMN vehicle_category.is_active   IS 'When FALSE the category is excluded from fleet planning and vehicle registration dropdowns.';
COMMENT ON COLUMN vehicle_category.created_at  IS 'Record creation timestamp (UTC).';
```

---

### 4.2 `rental_location`

Lookup table for rental branches referenced by fleet plan and vehicle records ([TRD §3.4](../trd/trd-car-management-fleet-size-growth-planning.md#34-rental_location)).

```sql
CREATE TABLE rental_location (
    id         UUID        NOT NULL DEFAULT gen_random_uuid(),
    name       VARCHAR(200) NOT NULL,
    address    TEXT        NOT NULL,
    is_active  BOOLEAN     NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP   NOT NULL DEFAULT NOW(),

    CONSTRAINT rental_location_pkey PRIMARY KEY (id)
);

COMMENT ON TABLE  rental_location            IS 'Rental branch locations. Referenced by fleet_capacity_plan and vehicle.';
COMMENT ON COLUMN rental_location.id         IS 'Unique location identifier (UUID).';
COMMENT ON COLUMN rental_location.name       IS 'Branch name (e.g. City Centre, Airport).';
COMMENT ON COLUMN rental_location.address    IS 'Full physical address of the branch.';
COMMENT ON COLUMN rental_location.is_active  IS 'When FALSE the location is closed and excluded from active planning.';
COMMENT ON COLUMN rental_location.created_at IS 'Record creation timestamp (UTC).';
```

---

### 4.3 `fleet_capacity_plan`

Administrator-defined target fleet configuration per vehicle category per rental location ([TRD §3.1](../trd/trd-car-management-fleet-size-growth-planning.md#31-fleet_capacity_plan)).

A plan entry is **active** on a given date when `effective_date ≤ date AND (expiry_date IS NULL OR expiry_date > date)` (see [TRD BR-01](../trd/trd-car-management-fleet-size-growth-planning.md#5-business-rules)).

```sql
CREATE TABLE fleet_capacity_plan (
    id                  UUID        NOT NULL DEFAULT gen_random_uuid(),
    location_id         UUID        NOT NULL,
    vehicle_category_id UUID        NOT NULL,
    target_count        INTEGER     NOT NULL,
    effective_date      DATE        NOT NULL,
    expiry_date         DATE,
    created_by          UUID        NOT NULL,
    created_at          TIMESTAMP   NOT NULL DEFAULT NOW(),
    updated_by          UUID,
    updated_at          TIMESTAMP,
    notes               TEXT,

    CONSTRAINT fleet_capacity_plan_pkey
        PRIMARY KEY (id),

    CONSTRAINT fleet_capacity_plan_location_fk
        FOREIGN KEY (location_id)
        REFERENCES rental_location (id),

    CONSTRAINT fleet_capacity_plan_category_fk
        FOREIGN KEY (vehicle_category_id)
        REFERENCES vehicle_category (id),

    -- Prevents duplicate active plan entries for the same category/location/date
    -- (TRD FR-FP-06, AC-02)
    CONSTRAINT fleet_capacity_plan_unique_entry
        UNIQUE (location_id, vehicle_category_id, effective_date),

    -- Enforces BR-05: target count must be a positive integer
    CONSTRAINT fleet_capacity_plan_target_count_positive
        CHECK (target_count >= 1),

    -- Enforces logical date ordering
    CONSTRAINT fleet_capacity_plan_date_order
        CHECK (expiry_date IS NULL OR expiry_date > effective_date)
);

COMMENT ON TABLE  fleet_capacity_plan                      IS 'Administrator-defined target vehicle counts per category per location per date range.';
COMMENT ON COLUMN fleet_capacity_plan.id                   IS 'Unique plan entry identifier (UUID).';
COMMENT ON COLUMN fleet_capacity_plan.location_id          IS 'FK to rental_location. Target branch for this plan entry.';
COMMENT ON COLUMN fleet_capacity_plan.vehicle_category_id  IS 'FK to vehicle_category. Target category for this plan entry.';
COMMENT ON COLUMN fleet_capacity_plan.target_count         IS 'Planned number of vehicles for this category at this location. Must be >= 1.';
COMMENT ON COLUMN fleet_capacity_plan.effective_date       IS 'Date from which this plan target is active (inclusive).';
COMMENT ON COLUMN fleet_capacity_plan.expiry_date          IS 'Date after which this plan target is superseded (exclusive). NULL = indefinite.';
COMMENT ON COLUMN fleet_capacity_plan.created_by           IS 'FK to system_user. Administrator who created this record.';
COMMENT ON COLUMN fleet_capacity_plan.created_at           IS 'Record creation timestamp (UTC).';
COMMENT ON COLUMN fleet_capacity_plan.updated_by           IS 'FK to system_user. Administrator who last modified this record.';
COMMENT ON COLUMN fleet_capacity_plan.updated_at           IS 'Record last updated timestamp (UTC). NULL if never updated.';
COMMENT ON COLUMN fleet_capacity_plan.notes                IS 'Free-text rationale or context for this plan entry.';
```

---

### 4.4 `vehicle`

Canonical vehicle record. Captures all attributes required by [PRD §2.3](../prd-car-management.md#23-vehicle-attributes) and referenced by the Vehicle Assignment TRD ([trd-car-management-vehicle-assignment.md](../trd/trd-car-management-vehicle-assignment.md)) ([TRD §3.2](../trd/trd-car-management-fleet-size-growth-planning.md#32-vehicle)).

```sql
CREATE TABLE vehicle (
    id                    UUID              NOT NULL DEFAULT gen_random_uuid(),
    vin                   VARCHAR(17)       NOT NULL,
    license_plate         VARCHAR(20)       NOT NULL,
    make                  VARCHAR(100)      NOT NULL,
    model                 VARCHAR(100)      NOT NULL,
    year                  SMALLINT          NOT NULL,
    color                 VARCHAR(50)       NOT NULL,
    fuel_type             fuel_type         NOT NULL,
    transmission          transmission_type NOT NULL,
    seating_capacity      SMALLINT          NOT NULL,
    odometer_km           INTEGER           NOT NULL,
    vehicle_category_id   UUID              NOT NULL,
    location_id           UUID              NOT NULL,
    status                vehicle_status    NOT NULL DEFAULT 'available',
    date_added_to_fleet   DATE              NOT NULL,
    created_by            UUID              NOT NULL,
    created_at            TIMESTAMP         NOT NULL DEFAULT NOW(),
    updated_by            UUID,
    updated_at            TIMESTAMP,
    retired_at            TIMESTAMP,
    notes                 TEXT,

    CONSTRAINT vehicle_pkey
        PRIMARY KEY (id),

    -- TRD FR-VR-02: VIN must be unique across all vehicles
    CONSTRAINT vehicle_vin_unique
        UNIQUE (vin),

    -- TRD FR-VR-02: license plate must be unique across all vehicles
    CONSTRAINT vehicle_license_plate_unique
        UNIQUE (license_plate),

    CONSTRAINT vehicle_category_fk
        FOREIGN KEY (vehicle_category_id)
        REFERENCES vehicle_category (id),

    CONSTRAINT vehicle_location_fk
        FOREIGN KEY (location_id)
        REFERENCES rental_location (id),

    -- VIN must be exactly 17 characters
    CONSTRAINT vehicle_vin_length
        CHECK (char_length(vin) = 17),

    -- Manufacturing year must be plausible (not before first mass-produced cars,
    -- and not more than one year ahead of the current year to allow for pre-orders).
    -- NOTE: the upper bound shifts each calendar year; see Migration Notes §8.
    CONSTRAINT vehicle_year_range
        CHECK (year >= 1886 AND year <= EXTRACT(YEAR FROM NOW()) + 1),

    -- Seating capacity must be at least 1
    CONSTRAINT vehicle_seating_capacity_positive
        CHECK (seating_capacity >= 1),

    -- Odometer cannot be negative
    CONSTRAINT vehicle_odometer_non_negative
        CHECK (odometer_km >= 0),

    -- retired_at must be set if and only if status is 'retired'.
    -- The application layer must update both columns in a single statement
    -- (e.g. UPDATE vehicle SET status = 'retired', retired_at = NOW() WHERE id = ?)
    -- to avoid a transient constraint violation. See Migration Notes §8.
    CONSTRAINT vehicle_retired_at_consistency
        CHECK (
            (status = 'retired' AND retired_at IS NOT NULL)
            OR (status <> 'retired' AND retired_at IS NULL)
        )
);

COMMENT ON TABLE  vehicle                      IS 'Canonical vehicle record for all fleet vehicles. Source of truth referenced by vehicle assignment and inspection modules.';
COMMENT ON COLUMN vehicle.id                   IS 'Unique vehicle identifier (UUID).';
COMMENT ON COLUMN vehicle.vin                  IS 'Vehicle Identification Number — 17-character unique identifier. Globally unique.';
COMMENT ON COLUMN vehicle.license_plate        IS 'Current vehicle registration plate. Unique across the fleet.';
COMMENT ON COLUMN vehicle.make                 IS 'Vehicle manufacturer (e.g. Toyota, BMW).';
COMMENT ON COLUMN vehicle.model                IS 'Vehicle model name (e.g. Corolla, X5).';
COMMENT ON COLUMN vehicle.year                 IS 'Manufacturing year. Upper bound is current year + 1 (to allow pre-orders); this shifts annually — see migration notes.';
COMMENT ON COLUMN vehicle.color                IS 'Exterior colour of the vehicle.';
COMMENT ON COLUMN vehicle.fuel_type            IS 'One of: petrol, diesel, hybrid, electric.';
COMMENT ON COLUMN vehicle.transmission         IS 'One of: manual, automatic.';
COMMENT ON COLUMN vehicle.seating_capacity     IS 'Number of passenger seats. Must be >= 1.';
COMMENT ON COLUMN vehicle.odometer_km          IS 'Current recorded mileage in kilometres. Must be >= 0.';
COMMENT ON COLUMN vehicle.vehicle_category_id  IS 'FK to vehicle_category. Assigned rental category.';
COMMENT ON COLUMN vehicle.location_id          IS 'FK to rental_location. Currently assigned rental branch.';
COMMENT ON COLUMN vehicle.status               IS 'Lifecycle status: available, booked, in_transit, under_maintenance, on_hold, retired.';
COMMENT ON COLUMN vehicle.date_added_to_fleet  IS 'Date the vehicle was added to the rental fleet (TRD FR-VR-05).';
COMMENT ON COLUMN vehicle.created_by           IS 'FK to system_user. Administrator who registered this vehicle.';
COMMENT ON COLUMN vehicle.created_at           IS 'Record creation timestamp (UTC).';
COMMENT ON COLUMN vehicle.updated_by           IS 'FK to system_user. Administrator who last modified this record.';
COMMENT ON COLUMN vehicle.updated_at           IS 'Record last updated timestamp (UTC). NULL if never updated.';
COMMENT ON COLUMN vehicle.retired_at           IS 'Timestamp when the vehicle was retired from the fleet. Must be set (and status must equal retired) atomically in a single UPDATE statement — see migration notes.';
COMMENT ON COLUMN vehicle.notes                IS 'Free-text operational notes.';
```

---

## 5. Indexes

The following indexes support the query patterns described in [TRD §4](../trd/trd-car-management-fleet-size-growth-planning.md#4-functional-requirements) and [TRD §7](../trd/trd-car-management-fleet-size-growth-planning.md#7-api-specifications).

```sql
-- fleet_capacity_plan: active plan lookup by location and category on a given date
-- Supports FR-PA-01, FR-PA-02, FR-PA-03, and the plan/actual summary query
CREATE INDEX idx_fleet_capacity_plan_location_category
    ON fleet_capacity_plan (location_id, vehicle_category_id);

CREATE INDEX idx_fleet_capacity_plan_effective_date
    ON fleet_capacity_plan (effective_date);

CREATE INDEX idx_fleet_capacity_plan_expiry_date
    ON fleet_capacity_plan (expiry_date)
    WHERE expiry_date IS NOT NULL;

-- vehicle: count active vehicles per category per location
-- Supports FR-PA-01 (actual fleet count) and FR-VR-01
CREATE INDEX idx_vehicle_category_location_status
    ON vehicle (vehicle_category_id, location_id, status);

-- vehicle: filter by location or status independently
CREATE INDEX idx_vehicle_location_id
    ON vehicle (location_id);

CREATE INDEX idx_vehicle_status
    ON vehicle (status);

-- vehicle_category: active category lookups (admin dropdowns, plan validation)
CREATE INDEX idx_vehicle_category_is_active
    ON vehicle_category (is_active);

-- rental_location: active location lookups
CREATE INDEX idx_rental_location_is_active
    ON rental_location (is_active);
```

---

## 6. Seed Data — Vehicle Categories

The following categories are derived directly from [PRD §2.2](../prd-car-management.md#22-vehicle-categories). These must be seeded into `vehicle_category` before any fleet capacity plan entries or vehicle registrations can reference them. The exact list is subject to confirmation during implementation (see [TRD OQ-01](../trd/trd-car-management-fleet-size-growth-planning.md#11-open-questions)).

```sql
INSERT INTO vehicle_category (id, name, description, is_active)
VALUES
    (gen_random_uuid(), 'Economy',                 'Small city cars — ideal for urban and short-distance rentals.',           TRUE),
    (gen_random_uuid(), 'Compact',                 'Mid-range hatchbacks — versatile everyday vehicles.',                    TRUE),
    (gen_random_uuid(), 'Mid-Size',                'Standard saloons — comfortable for longer journeys.',                    TRUE),
    (gen_random_uuid(), 'SUV',                     'Sport Utility Vehicles — spacious with higher ground clearance.',        TRUE),
    (gen_random_uuid(), 'Luxury',                  'Premium and executive vehicles — high-end features and comfort.',        TRUE),
    (gen_random_uuid(), 'Electric Vehicle (EV)',   'Battery-electric vehicles — zero tailpipe emissions.',                   TRUE),
    (gen_random_uuid(), 'Van',                     'Cargo and passenger vans — suitable for group travel or freight.',       TRUE)
ON CONFLICT (name) DO NOTHING;
```

> **Note:** `ON CONFLICT (name) DO NOTHING` ensures the seed is idempotent and safe to re-run. Administrators may add further categories via the admin interface without requiring code changes ([PRD §2.2](../prd-car-management.md#22-vehicle-categories)).

---

## 7. Business Rules Enforced at Database Level

The following business rules from [TRD §5](../trd/trd-car-management-fleet-size-growth-planning.md#5-business-rules) are enforced by database constraints rather than relying solely on application logic.

| TRD Rule | Enforcement Mechanism |
|---|---|
| BR-05 — `target_count` must be ≥ 1 | `CHECK (target_count >= 1)` on `fleet_capacity_plan` |
| FR-FP-06 — No duplicate `(location_id, vehicle_category_id, effective_date)` | `UNIQUE (location_id, vehicle_category_id, effective_date)` on `fleet_capacity_plan` |
| FR-VR-02 — VIN must be globally unique | `UNIQUE (vin)` on `vehicle` |
| FR-VR-02 — License plate must be globally unique | `UNIQUE (license_plate)` on `vehicle` |
| VIN is exactly 17 characters | `CHECK (char_length(vin) = 17)` on `vehicle` |
| Seating capacity must be ≥ 1 | `CHECK (seating_capacity >= 1)` on `vehicle` |
| Odometer cannot be negative | `CHECK (odometer_km >= 0)` on `vehicle` |
| `retired_at` set ↔ status = `retired` | `CHECK` constraint on `vehicle` coupling `retired_at` and `status` |
| `expiry_date` must be after `effective_date` | `CHECK (expiry_date IS NULL OR expiry_date > effective_date)` on `fleet_capacity_plan` |
| Referential integrity: vehicles reference valid categories and locations | Foreign key constraints on `vehicle` |
| Referential integrity: plan entries reference valid categories and locations | Foreign key constraints on `fleet_capacity_plan` |

> **Note:** Business rules that require application context (e.g. BR-06 — only Administrators may create plan entries, BR-07 — audit trail, BR-04 — `in_transit` vehicle counted at origin location) are enforced at the application layer and are not expressible purely as database constraints.

---

## 8. Migration Notes

- **Extension requirement:** This schema uses `gen_random_uuid()` which requires the `pgcrypto` extension (PostgreSQL < 13) or is built-in in PostgreSQL ≥ 13 via `gen_random_uuid()`. Ensure the target database version supports it, or replace with `uuid_generate_v4()` from the `uuid-ossp` extension.
- **`system_user` dependency:** The `created_by` and `updated_by` columns on `fleet_capacity_plan` and `vehicle` reference `system_user.id`. The `system_user` table is owned by the platform identity service. The foreign key constraints for these columns must be added after that table is available, or omitted and enforced at the application layer if the identity service is in a separate database.
- **Migration order:** Tables must be created in the following order to satisfy foreign key dependencies:
  1. `vehicle_category`
  2. `rental_location`
  3. `fleet_capacity_plan` (depends on `vehicle_category` and `rental_location`)
  4. `vehicle` (depends on `vehicle_category` and `rental_location`)
- **Seed data:** The `vehicle_category` seed script ([§6](#6-seed-data--vehicle-categories)) should be executed as part of the initial migration after the table is created.
- **Audit log tables:** The platform-level audit log (required by [TRD NFR-05](../trd/trd-car-management-fleet-size-growth-planning.md#8-non-functional-requirements)) is not defined here. Triggers or application-layer hooks must write change records to the platform audit log for all DML on `fleet_capacity_plan` and `vehicle`.
- **Vehicle year constraint (`vehicle_year_range`):** The upper bound `EXTRACT(YEAR FROM NOW()) + 1` is evaluated at query time and shifts each calendar year. During a database restore or point-in-time recovery to an earlier date, rows with a `year` equal to the current calendar year may temporarily fail the constraint check if the restored clock date is earlier. Document this behaviour in operational runbooks; if this is a concern, replace the dynamic bound with a fixed ceiling (e.g. `2030`) and update it periodically.
- **Vehicle retirement atomicity (`vehicle_retired_at_consistency`):** The check constraint requires `status = 'retired'` and `retired_at IS NOT NULL` to be satisfied simultaneously. Applications must retire a vehicle using a single `UPDATE` statement that sets both columns at once (e.g. `UPDATE vehicle SET status = 'retired', retired_at = NOW() WHERE id = ?`). Two-step updates (first updating `status`, then `retired_at`, or vice versa) will cause a transient constraint violation. The retirement API endpoint (see [TRD §7.2](../trd/trd-car-management-fleet-size-growth-planning.md#72-vehicle-registration-endpoints) `PATCH /api/v1/vehicles/{id}/retire`) must enforce this pattern.
