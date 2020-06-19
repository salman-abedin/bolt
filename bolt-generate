#!/usr/bin/env sh

[ "$SEARCH_LIST" ] || export SEARCH_LIST=/tmp/search_list

whitelist=$(grep -v "^#" ~/.config/bolt/whitelist)
blacklist=$(grep -Ev "^#|^$" ~/.config/bolt/blacklist | sed 's/^\./\\./' | tr '\n' '|' | sed 's/|$//')
maxDepth=5

find -L $whitelist -maxdepth $maxDepth |
    grep -Ev "$blacklist" \
        > "$SEARCH_LIST"
