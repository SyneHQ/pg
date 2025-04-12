#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status

# Set permissions for SSL certificates
echo "Setting permissions for SSL certificates..."
chmod 644 /etc/postgresql/ssl/server.crt
chmod 600 /etc/postgresql/ssl/server.key

# Verify ownership of the SSL files
echo "Ensuring SSL certificate and key ownership..."
chown postgres:postgres /etc/postgresql/ssl/server.crt /etc/postgresql/ssl/server.key

# Confirm permissions and ownership
echo "Verifying permissions and ownership..."
ls -l /etc/postgresql/ssl/server.crt /etc/postgresql/ssl/server.key


# Set proper permissions for PostgreSQL data directory
echo "Setting permissions for PostgreSQL data directory..."
chown -R postgres:postgres /var/lib/postgresql/data
chmod 700 /var/lib/postgresql/data

# Verify data directory permissions
echo "Verifying data directory permissions..."
ls -ld /var/lib/postgresql/data

# Switch to postgres user before starting the server
echo "Switching to postgres user..."
if [ "$(id -u)" = "0" ]; then
    exec su postgres -c "postgres -c config_file=/etc/postgresql/conf.d/postgresql.conf"
else
    echo "Starting PostgreSQL with configuration file..."
    exec postgres -c config_file=/etc/postgresql/conf.d/postgresql.conf
fi
