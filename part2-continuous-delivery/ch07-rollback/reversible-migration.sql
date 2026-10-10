-- migrate:up
-- Adding a nullable column is backward compatible: running code that does
-- not know about it is unaffected, so this deploys and rolls back cleanly.
ALTER TABLE orders ADD COLUMN priority integer;
 
-- migrate:down
-- The down path is written now, while the change is fresh, and tested in a
-- lower environment. A migration whose down path is untested is a migration
-- you cannot assume rolls back.
ALTER TABLE orders DROP COLUMN priority;