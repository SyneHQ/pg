#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status
set -u  # Treat unset variables as errors
set -o pipefail  # Exit if any command in a pipeline fails

# Function to handle errors
error_handler() {
    echo "Error occurred in script at line: $1"
    exit 1
}

trap 'error_handler ${LINENO}' ERR

# Check if required SSL files exist
if [ ! -f "/etc/postgresql/ssl/server.crt" ] || [ ! -f "/etc/postgresql/ssl/server.key" ]; then
    echo "ERROR: SSL certificate or key files missing"
    exit 1
fi

# Set permissions for SSL certificates
echo "Setting permissions for SSL certificates..."
chmod 644 /etc/postgresql/ssl/server.crt || exit 1
chmod 600 /etc/postgresql/ssl/server.key || exit 1

# Verify ownership of the SSL files
echo "Ensuring SSL certificate and key ownership..."
chown postgres:postgres /etc/postgresql/ssl/server.crt /etc/postgresql/ssl/server.key || exit 1

# Verify SSL file permissions and ownership
echo "Verifying SSL file permissions and ownership..."
ls -l /etc/postgresql/ssl/server.crt /etc/postgresql/ssl/server.key || exit 1

# Initialize PostgreSQL data directory if it doesn't exist
echo "Checking PostgreSQL data directory..."
if [ ! -f "/var/lib/postgresql/data/PG_VERSION" ]; then
    echo "Initializing PostgreSQL database..."
    chown postgres:postgres /var/lib/postgresql/data || exit 1
    su postgres -c "initdb -D /var/lib/postgresql/data" || exit 1
fi

# Set proper permissions for PostgreSQL data directory
echo "Setting permissions for PostgreSQL data directory..."
chown -R postgres:postgres /var/lib/postgresql/data || exit 1
chmod 700 /var/lib/postgresql/data || exit 1

# Verify data directory permissions
echo "Verifying data directory permissions..."
ls -ld /var/lib/postgresql/data || exit 1

# Create log directory if it doesn't exist
if [ ! -d "/var/lib/postgresql/log" ]; then
    mkdir -p /var/lib/postgresql/log
    chown postgres:postgres /var/lib/postgresql/log
    chmod 755 /var/lib/postgresql/log
fi

# Switch to postgres user before starting the server
echo "Starting PostgreSQL server..."
if [ "$(id -u)" = "0" ]; then
    exec gosu postgres postgres -c config_file=/etc/postgresql/conf.d/postgresql.conf
else
    echo "WARNING: Not running as root user"
    exec postgres -c config_file=/etc/postgresql/conf.d/postgresql.conf
fi
