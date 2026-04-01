-- Migration: 000005_create_fleet_capacity_plan
-- Stores administrator-defined target fleet configuration per category per location.
-- References vehicle_category (000002), rental_location (000003), and system_user (000001).
-- Business rules per TRD §3.1 and §5.

CREATE TABLE fleet_capacity_plan (
    id                  UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    location_id         UUID        NOT NULL REFERENCES rental_location (id),
    vehicle_category_id UUID        NOT NULL REFERENCES vehicle_category (id),
    target_count        INTEGER     NOT NULL CHECK (target_count >= 1),
    effective_date      DATE        NOT NULL,
    expiry_date         DATE,
    created_by          UUID        NOT NULL REFERENCES system_user (id),
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_by          UUID        REFERENCES system_user (id),
    updated_at          TIMESTAMPTZ,
    notes               TEXT,

    -- Enforces that only one target count may be defined per category/location/date
    -- combination (TRD business rule BR-06 and functional requirement FR-FP-06).
    CONSTRAINT uq_fleet_capacity_plan_location_category_date
        UNIQUE (location_id, vehicle_category_id, effective_date)
);

CREATE INDEX idx_fleet_capacity_plan_location  ON fleet_capacity_plan (location_id);
CREATE INDEX idx_fleet_capacity_plan_category  ON fleet_capacity_plan (vehicle_category_id);
CREATE INDEX idx_fleet_capacity_plan_effective ON fleet_capacity_plan (effective_date);
