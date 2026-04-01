-- Migration: 000004_create_vehicle
-- Core vehicle table capturing all attributes required by PRD §2.3.
-- References vehicle_category and rental_location (migrations 000002, 000003).

CREATE TYPE fuel_type AS ENUM ('petrol', 'diesel', 'hybrid', 'electric');
CREATE TYPE transmission_type AS ENUM ('manual', 'automatic');
CREATE TYPE vehicle_status AS ENUM (
    'available',
    'booked',
    'in_transit',
    'under_maintenance',
    'on_hold',
    'retired'
);

CREATE TABLE vehicle (
    id                   UUID              PRIMARY KEY DEFAULT gen_random_uuid(),
    vin                  VARCHAR(17)       NOT NULL UNIQUE,
    license_plate        VARCHAR(20)       NOT NULL UNIQUE,
    make                 VARCHAR(100)      NOT NULL,
    model                VARCHAR(100)      NOT NULL,
    year                 SMALLINT          NOT NULL,
    color                VARCHAR(50)       NOT NULL,
    fuel_type            fuel_type         NOT NULL,
    transmission         transmission_type NOT NULL,
    seating_capacity     SMALLINT          NOT NULL CHECK (seating_capacity >= 1),
    odometer_km          INTEGER           NOT NULL DEFAULT 0 CHECK (odometer_km >= 0),
    vehicle_category_id  UUID              NOT NULL REFERENCES vehicle_category (id),
    location_id          UUID              NOT NULL REFERENCES rental_location (id),
    status               vehicle_status    NOT NULL DEFAULT 'available',
    date_added_to_fleet  DATE              NOT NULL DEFAULT CURRENT_DATE,
    created_by           UUID              NOT NULL REFERENCES system_user (id),
    created_at           TIMESTAMPTZ       NOT NULL DEFAULT NOW(),
    updated_by           UUID              REFERENCES system_user (id),
    updated_at           TIMESTAMPTZ,
    retired_at           TIMESTAMPTZ,
    notes                TEXT
);

CREATE INDEX idx_vehicle_category ON vehicle (vehicle_category_id);
CREATE INDEX idx_vehicle_location  ON vehicle (location_id);
CREATE INDEX idx_vehicle_status    ON vehicle (status);
