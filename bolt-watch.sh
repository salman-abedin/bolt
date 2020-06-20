#!/usr/bin/env sh

whitelist=$(grep -v "^#" ~/.config/bolt/whitelist)

inotifywait -m -r -e create,delete,move $whitelist |
    while read -r event; do
        generate-list
    done
