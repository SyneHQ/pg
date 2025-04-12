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

# Start PostgreSQL
echo "Starting PostgreSQL with configuration file..."
exec postgres -c config_file=/etc/postgresql/conf.d/postgresql.conf
