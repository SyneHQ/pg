CREATE EXTENSION IF NOT EXISTS pg_stat_statements;
COMMENT ON EXTENSION pg_stat_statements IS 'track execution time, query count, and memory usage of all SQL statements';
CREATE EXTENSION IF NOT EXISTS pg_qualstats;
COMMENT ON EXTENSION pg_qualstats IS 'track query execution details and statistics';
CREATE EXTENSION IF NOT EXISTS pg_stat_kcache;
COMMENT ON EXTENSION pg_stat_kcache IS 'track I/O statistics for queries';
