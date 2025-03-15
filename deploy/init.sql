-- Deploy tg-drill:init to pg
BEGIN;
CREATE TABLE tg_drill (id SERIAL PRIMARY KEY);
-- XXX Add DDLs here.
COMMIT;