-- Migration: 000002_create_vehicle_category
-- Lookup table for vehicle categories (Economy, SUV, Luxury, etc.).
-- Defined as the canonical categorisation table per TRD §3.3.

CREATE TABLE vehicle_category (
    id          UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
    name        VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    is_active   BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_vehicle_category_is_active ON vehicle_category (is_active);
