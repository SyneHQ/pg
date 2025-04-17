# Use the official PostgreSQL image as the base
FROM pgvector/pgvector:pg17

# Add label metadata
LABEL org.opencontainers.image.source="https://github.com/synehq/pg-pgvector"
LABEL org.opencontainers.image.description="SyneHQ PostgreSQL with pgvector for vector similarity search"
LABEL org.opencontainers.image.licenses="MIT"

# update packages
RUN apt update
RUN apt upgrade -y

RUN apt install -y tzdata

# Set environment variables
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# Create directory for logs
RUN mkdir -p /var/lib/postgresql/log && \
    chown -R postgres:postgres /var/lib/postgresql/log

# Create directory for custom configurations
RUN mkdir -p /etc/postgresql/conf.d && \
    chown -R postgres:postgres /etc/postgresql/conf.d

# Create directory for SSL certificates
RUN mkdir -p /etc/postgresql/ssl && \
    chown -R postgres:postgres /etc/postgresql/ssl && \
    chmod 700 /etc/postgresql/ssl

# Copy custom PostgreSQL configuration
COPY postgresql.conf /etc/postgresql/conf.d/
RUN chown postgres:postgres /etc/postgresql/conf.d/postgresql.conf

# Copy entrypoint file
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
# make entrypoint executable
RUN chmod +x /usr/local/bin/entrypoint.sh
RUN chown postgres:postgres /usr/local/bin/entrypoint.sh

# Copy initialization script
COPY init.sql /docker-entrypoint-initdb.d/init.sql

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

# Create volume mount points
VOLUME ["/var/lib/postgresql/data", "/var/lib/postgresql/log", "/etc/postgresql/ssl"]

# Expose PostgreSQL port
EXPOSE 5432

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
