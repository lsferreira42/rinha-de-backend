#!/bin/bash
source /usr/local/apache2/htdocs/lib/shared.sh

print_header

env | sed 's/\n/<br>/g' | sed 's/ /&nbsp;/g' | sed 's/=/ : /g' | sed 's/^/ /' | sed 's/$/<br>/'
