#!/usr/bin/env sh

search_list=/tmp/search_list
while :; do
    case $1 in
        --launch)
            # Modify this section according to your preference
            case $(file --mime-type "$2" -bL) in
                inode/directory)
                    $TERMINAL -e lf -last-dir-path ~/.config/lf/last_path "$2"
                    ;;
                text/* | inode/x-empty | application/json | application/octet-stream)
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
            awk -F / '{print $NF}' "$search_list" |
                rofi -sort true -sorting-method fzf -dmenu -i -p Open |
                xargs -I% grep /%$ "$search_list" |
                xargs bolt --launch
            ;;
        --generate)
            whitelist=$(grep -v "^#" ~/.config/bolt/whitelist)
            blacklist=$(grep -Ev "^#|^$" ~/.config/bolt/blacklist | sed 's/^\./\\./' | tr '\n' '|' | sed 's/|$//')
            maxDepth=5
            find -L $whitelist -maxdepth $maxDepth |
                grep -Ev "$blacklist" \
                    > "$search_list"
            ;;
        --watch)
            whitelist=$(grep -v "^#" ~/.config/bolt/whitelist)
            inotifywait -m -r -e create,delete,move $whitelist |
                while read -r :; do
                    bolt --generate
                done &
            ;;
        *) break ;;
    esac
    shift
done
