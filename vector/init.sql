-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS vector;
COMMENT ON EXTENSION vector IS 'vector extension for vector similarity search';
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;
COMMENT ON EXTENSION pg_stat_statements IS 'track execution time, query count, and memory usage of all SQL statements';
