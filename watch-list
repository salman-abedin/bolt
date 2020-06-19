#!/usr/bin/env sh

# path=$(readlink -f "$0")
# dir="${path%/*}"

whitelist=$(grep -v "^#" ~/.config/bolt/whitelist)

inotifywait -m -r -e create,delete,move $whitelist |
    while read -r event; do
        generate-list
    done
