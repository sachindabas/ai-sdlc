-- Migration: 000001_create_system_user
-- Creates the system_user lookup table referenced by fleet and vehicle records.

CREATE TYPE user_role AS ENUM ('administrator', 'fleet_staff', 'fleet_manager', 'viewer');

CREATE TABLE system_user (
    id   UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(200) NOT NULL,
    role user_role   NOT NULL
);
