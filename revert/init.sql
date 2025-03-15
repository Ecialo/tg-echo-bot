-- Revert tg-drill:init from pg
BEGIN;
DROP TABLE tg_drill;
-- XXX Add DDLs here.
COMMIT;