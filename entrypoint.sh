#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status

# Set permissions for SSL certificates
echo "Setting permissions for SSL certificates..."
chmod 644 /certificates/server.crt
chmod 600 /certificates/server.key

# Verify ownership of the SSL files
echo "Ensuring SSL certificate and key ownership..."
chown postgres:postgres /certificates/server.crt /certificates/server.key

# Confirm permissions and ownership
echo "Verifying permissions and ownership..."
ls -l /certificates/server.crt /certificates/server.key

# Start PostgreSQL
echo "Starting PostgreSQL with configuration file..."
exec postgres -c config_file=/etc/postgresql/conf.d/postgresql.conf
