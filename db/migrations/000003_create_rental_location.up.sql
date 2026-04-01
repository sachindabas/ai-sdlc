-- Migration: 000003_create_rental_location
-- Lookup table for rental branch locations referenced by fleet plan and vehicle records.
-- Defined as the canonical location table per TRD §3.4.

CREATE TABLE rental_location (
    id         UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
    name       VARCHAR(200) NOT NULL,
    address    TEXT         NOT NULL,
    is_active  BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_rental_location_is_active ON rental_location (is_active);
