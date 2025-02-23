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

# Add healthcheck
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
    CMD pg_isready -U postgres || exit 1

# Set production-ready PostgreSQL configurations
CMD ["postgres", "-c", "config_file=/etc/postgresql/conf.d/postgresql.conf"]