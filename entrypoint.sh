#!/bin/bash
source /usr/local/apache2/htdocs/lib/shared.sh

echo "Starting Apache httpd server..."
if [ -f '/usr/local/apache2/db/rinha.db' ]; then
    echo "Database already exists, skipping..."
else
    echo "Creating database..."
    sqlite3 /usr/local/apache2/db/rinha.db < /usr/local/apache2/db/init.sql
    echo "Database created."
fi

exec httpd-foreground