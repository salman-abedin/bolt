#!/usr/bin/env sh

MAXDEPTH=5
SEARCHLIST=/tmp/search_list

# Head alternative
# Forked from https://github.com/dylanaraps/pure-bash-bible#get-the-first-n-lines-of-a-file
thead() {
    while read -r line; do
        echo "$line"
        i=$((i + 1))
        [ "$i" = "$1" ] && return
    done < /dev/stdin
    [ -n "$line" ] && printf %s "$line"
}

while :; do
    case $1 in
        --launch)
            shift
            # Modify this section according to your preference
            case $(file --mime-type "$*" -bL) in
                # Find out the mimetype of the file you wannna launch
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
            query=$(awk -F / '{print $(NF-1)"/"$NF}' "$SEARCHLIST" |
                rofi -sort true -sorting-method fzf -dmenu -i -p Open)
            [ "$query" ] || exit 1
            result=$(grep "$query" "$SEARCHLIST" | thead 1)
            if [ "$result" ]; then
                "$0" --launch "$result"
            else
                "$BROWSER" google.com/search\?q="$query"
            fi
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
                while read -r line; do
                    "$0" --generate
                done &
            ;;
        *) break ;;
    esac
    shift
done
exit 0
