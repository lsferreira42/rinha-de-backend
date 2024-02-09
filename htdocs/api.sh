#!/bin/bash

# Printa os cabeçalhos necessários para output em HTML
echo "Content-type: text/html"
echo ""


if [[ "${REQUEST_URI}" =~ ^/healthcheck ]]; then
    env | sed 's/\n/<br>/g' | sed 's/ /&nbsp;/g' | sed 's/=/ : /g' | sed 's/^/ /' | sed 's/$/<br>/'
fi

echo "Hello"