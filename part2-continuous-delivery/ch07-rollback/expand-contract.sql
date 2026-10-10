-- STEP 1 (expand): add the new column alongside the old one. Backfill it.
-- Both old and new code work: old code uses customer_email, new code can
-- use email_address once deployed. This step rolls back by dropping the
-- new column, which no running code depends on yet.
ALTER TABLE customers ADD COLUMN email_address text;
UPDATE customers SET email_address = customer_email WHERE email_address IS NULL;
 
-- STEP 2 (migrate, in application code across two deploys):
--   Deploy 2a: code writes BOTH columns, reads the old one. Reversible:
--   rolling back to step-1 code is safe because the old column is still
--   authoritative.
--   Deploy 2b: code writes both, reads the NEW column. Reversible: rolling
--   back to 2a is safe because both columns are still being written and
--   hold the same value.
 
-- STEP 3 (contract): only after 2b is stable and you are certain no rollback
-- target still needs the old column, drop it. This is the one irreversible
-- step, taken last, deliberately, when nothing you would roll back to reads it.
ALTER TABLE customers DROP COLUMN customer_email;