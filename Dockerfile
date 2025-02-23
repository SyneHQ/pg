# Use Alpine-based image for smaller footprint and better security
FROM postgres:17-alpine

# Add label metadata
LABEL org.opencontainers.image.source="https://github.com/synehq/pg-pgvector"
LABEL org.opencontainers.image.description="SyneHQ PostgreSQL with pg_stat_statements"
LABEL org.opencontainers.image.licenses="MIT"

# Install additional required packages
RUN apk add --no-cache tzdata

# Create directory for custom configurations
RUN mkdir -p /etc/postgresql/conf.d && \
    chown -R postgres:postgres /etc/postgresql/conf.d

# Copy custom PostgreSQL configuration
COPY postgresql.conf /etc/postgresql/conf.d/
RUN chown postgres:postgres /etc/postgresql/conf.d/postgresql.conf

# Set up initialization scripts
COPY init.sql /docker-entrypoint-initdb.d/
RUN chown postgres:postgres /docker-entrypoint-initdb.d/init.sql

# Expose PostgreSQL port
EXPOSE 5432

# Create healthcheck script
COPY --chown=postgres:postgres <<'EOF' /usr/local/bin/docker-healthcheck
#!/bin/bash
set -eo pipefail

host="$(hostname -i || echo '127.0.0.1')"
user="${POSTGRES_USER:-postgres}"
db="${POSTGRES_DB:-$user}"

export PGPASSWORD="${POSTGRES_PASSWORD:-}"

args=(
    --host "$host"
    --username "$user"
    --dbname "$db"
    --quiet --no-align --tuples-only
)

if SELECT 1 FROM pg_database WHERE datname='$db' >/dev/null 2>&1; then
    exit 0
fi

exit 1
EOF

RUN chmod +x /usr/local/bin/docker-healthcheck

# Add healthcheck
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
    CMD ["docker-healthcheck"]

# Set production-ready PostgreSQL configurations
CMD ["postgres", "-c", "config_file=/etc/postgresql/conf.d/postgresql.conf"]