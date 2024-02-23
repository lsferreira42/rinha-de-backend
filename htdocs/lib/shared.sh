#!/bin/bash
# Shared Libs!

DATABASE_PATH="/usr/local/apache2/db/rinha.db"

print_header() {
    if [ "$1" == "404" ]; then
        echo "Status: 404 Not Found"
    elif [ "$1" == "422" ]; then
        echo "Status: 422 Unprocessable Entity"
    else
        echo "Status: 200 OK"
    fi
    echo "Content-type: application/json"
    echo ""
}

