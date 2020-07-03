#!/usr/bin/env sh

MAXDEPTH=6
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
            QUERY=$(awk -F / '{print $(NF-1)"/"$NF}' "$SEARCHLIST" |
                rofi -sort true -sorting-method fzf -dmenu -i -p Open)
            [ "$QUERY" ] || exit 1
            RESULT=$(grep "$QUERY" "$SEARCHLIST" | thead 1)
            if [ "$RESULT" ]; then
                "$0" --launch "$RESULT"
            else
                "$BROWSER" google.com/search\?q="$QUERY"
            fi
            ;;
        --generate)
            PATHLIST=$(grep -v "^#" ~/.config/bolt/pathlist)
            BLACKLIST=$(grep -Ev "^#|^$" ~/.config/bolt/blacklist | sed 's/^\./\\./' | tr '\n' '|' | sed 's/|$//')
            find -L $PATHLIST -maxdepth $MAXDEPTH |
                grep -Ev "$BLACKLIST" \
                    > "$SEARCHLIST"
            ;;
        --watch)
            PATHLIST=$(grep -v "^#" ~/.config/bolt/pathlist)
            inotifywait -m -r -e create,delete,move $PATHLIST |
                while read -r line; do
                    "$0" --generate
                done &
            ;;
        *) break ;;
    esac
    shift
done
exit 0
