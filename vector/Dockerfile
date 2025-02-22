# Use the official PostgreSQL image as the base
FROM pgvector/pgvector:pg17

# Configure shared_preload_libraries for pg_stat_statements and pgvector
RUN echo "shared_preload_libraries = 'pg_stat_statements'" >> /usr/share/postgresql/postgresql.conf.sample

# Expose PostgreSQL port
EXPOSE 5432

COPY init.sql /docker-entrypoint-initdb.d/init.sql

# Set the default command to run PostgreSQL with custom configurations
CMD ["postgres", "-c", "shared_preload_libraries=pg_stat_statements", "-c", "pg_stat_statements.track=all", "-c", "pg_stat_statements.track_utility=on", "-c", "max_connections=200"]

