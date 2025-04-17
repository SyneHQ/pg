#!/usr/bin/env bash
set -Eeo pipefail

# Function to handle environment variables from files
file_env() {
    local var="$1"
    local fileVar="${var}_FILE"
    local def="${2:-}"
    if [ "${!var:-}" ] && [ "${!fileVar:-}" ]; then
        printf >&2 'error: both %s and %s are set (but are exclusive)\n' "$var" "$fileVar"
        exit 1
    fi
    local val="$def"
    if [ "${!var:-}" ]; then
        val="${!var}"
    elif [ "${!fileVar:-}" ]; then
        val="$(< "${!fileVar}")"
    fi
    export "$var"="$val"
    unset "$fileVar"
}

# Check if being sourced
_is_sourced() {
    [ "${#FUNCNAME[@]}" -ge 2 ] \
        && [ "${FUNCNAME[0]}" = '_is_sourced' ] \
        && [ "${FUNCNAME[1]}" = 'source' ]
}

# Create required directories
docker_create_db_directories() {
    local user; user="$(id -u)"

    mkdir -p "$PGDATA"
    chmod 00700 "$PGDATA" || :

    mkdir -p /var/run/postgresql || :
    chmod 03775 /var/run/postgresql || :

    # Create log directory if it doesn't exist
    if [ ! -d "/var/lib/postgresql/log" ]; then
        mkdir -p /var/lib/postgresql/log
        chmod 755 /var/lib/postgresql/log
    fi

    # Create SSL directory if it doesn't exist
    if [ ! -d "/etc/postgresql/ssl" ]; then
        mkdir -p /etc/postgresql/ssl
        chmod 700 /etc/postgresql/ssl
    fi

    # Set proper ownership if running as root
    if [ "$user" = '0' ]; then
        find "$PGDATA" \! -user postgres -exec chown postgres '{}' +
        find /var/run/postgresql \! -user postgres -exec chown postgres '{}' +
        chown postgres:postgres /var/lib/postgresql/log
        chown -R postgres:postgres /etc/postgresql/ssl
        
        # Verify SSL file permissions
        if [ -d "/etc/postgresql/ssl" ]; then
            find /etc/postgresql/ssl -type f -exec chmod 600 {} \;
        fi
    fi
}

# Setup environment variables
docker_setup_env() {
    file_env 'POSTGRES_PASSWORD'
    file_env 'POSTGRES_USER' 'postgres'
    file_env 'POSTGRES_DB' "$POSTGRES_USER"
    file_env 'POSTGRES_INITDB_ARGS'
    : "${POSTGRES_HOST_AUTH_METHOD:=scram-sha-256}"

    declare -g DATABASE_ALREADY_EXISTS
    : "${DATABASE_ALREADY_EXISTS:=}"
    if [ -s "$PGDATA/PG_VERSION" ]; then
        DATABASE_ALREADY_EXISTS='true'
    fi
}

_main() {
    # If first arg looks like a flag, assume we want to run postgres server
    if [ "${1:0:1}" = '-' ]; then
        set -- postgres "$@"
    fi

    if [ "$1" = 'postgres' ]; then
        docker_setup_env
        docker_create_db_directories

        # Switch to postgres user if running as root
        if [ "$(id -u)" = '0' ]; then
            exec gosu postgres "$BASH_SOURCE" "$@"
        fi

        # Start PostgreSQL with config file
        exec postgres -c config_file=/etc/postgresql/conf.d/postgresql.conf
    fi

    exec "$@"
}

if ! _is_sourced; then
    _main "$@"
fi
