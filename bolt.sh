#!/usr/bin/env sh

MAXDEPTH=5
SEARCHLIST=/tmp/search_list

while :; do
    case $1 in
        --launch)
            # Modify this section according to your preference
            case $(file --mime-type "$2" -bL) in
                inode/directory)
                    $TERMINAL -e lf -last-dir-path ~/.config/lf/last_path "$2"
                    ;;
                text/*|inode/x-empty|application/json|application/octet-stream)
                    "$TERMINAL" -e "$EDITOR" "$2"
                    ;;
                video/*)
                    mpv "$2"
                    ;;
                application/pdf | application/postscript)
                    zathura "$2"
                    ;;
            esac
            ;;
        --search)
            awk -F / '{print $NF}' "$SEARCHLIST" |
                rofi -sort true -sorting-method fzf -dmenu -i -p Open |
                xargs -I% grep /%$ "$SEARCHLIST" |
                xargs bolt --launch
            ;;
        --generate)
            WHITELIST=$(grep -v "^#" ~/.config/bolt/whitelist)
            BLACKLIST=$(grep -Ev "^#|^$" ~/.config/bolt/blacklist | sed 's/^\./\\./' | tr '\n' '|' | sed 's/|$//')
            find -L $WHITELIST -maxdepth $MAXDEPTH |
                grep -Ev "$BLACKLIST" \
                    > "$SEARCHLIST"
            ;;
        --watch)
            WHITELIST=$(grep -v "^#" ~/.config/bolt/whitelist)
            inotifywait -m -r -e create,delete,move $WHITELIST |
                while read -r read; do
                    bolt --generate
                done &
            ;;
        *) break ;;
    esac
    shift
done
