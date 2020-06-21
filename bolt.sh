#!/usr/bin/env sh

MAXDEPTH=5
SEARCHLIST=/tmp/search_list

while :; do
    case $1 in
        --launch)
            shift
            # Modify this section according to your preference
            case $(file --mime-type "$*" -bL) in
                # Find out the mimetype of your file
                inode/directory)
                    # Launch using your favorite programs
                    $TERMINAL -e explore "$*"
                    ;;
                text/* | inode/x-empty | application/json | application/octet-stream)
                    $TERMINAL -e "$EDITOR" "$*"
                    ;;
                video/*)
                    mpv "$*"
                    ;;
                application/pdf | application/postscript)
                    zathura "$*"
                    ;;
            esac
            ;;
        --search)
            awk -F / '{print $NF}' "$SEARCHLIST" |
                rofi -sort true -sorting-method fzf -dmenu -i -p Open |
                xargs -I% grep /%$ "$SEARCHLIST" |
                xargs "$0" --launch
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
                    "$0" --generate
                done &
            ;;
        *) break ;;
    esac
    shift
done

exit 0
