#!/usr/bin/env sh

MAXDEPTH=6
SEARCHLIST=/tmp/searchlist

# "head" alternative
# Forked from https://github.com/dylanaraps/pure-bash-bible#get-the-first-n-lines-of-a-file
thead() {
    while read -r line; do
        echo "$line"
        i=$((i + 1))
        [ "$i" = "$1" ] && return
    done < /dev/stdin
    [ -n "$line" ] && printf %s "$line"
}

searchnlaunch() {
    RESULT=$(grep "$1" "$SEARCHLIST" | thead 1)
    if [ "$RESULT" ]; then
        "$0" --launch "$RESULT"
    else
        "$BROWSER" google.com/search\?q="$1"
    fi
}

while :; do
    case $1 in
        --launch)
            shift
            #========================================================
            # Modify this section according to your preference
            #========================================================
            case $(file --mime-type "$*" -bL) in
                #====================================================
                # Find out the mimetype of the file you wannna launch
                #====================================================
                video/*)
                    #================================================
                    # Launch using your favorite programs
                    #================================================
                    mpv "$*"
                    ;;
                #================================================
                # So on and so forth
                #================================================
                application/pdf | application/postscript)
                    zathura "$*"
                    ;;
                inode/directory)
                    explore "$*"
                    # explore "$*" ||
                    #     $TERMINAL -e explore "$*"
                    ;;
                text/* | inode/x-empty | application/json | application/octet-stream)
                    "$EDITOR" "$*"
                    # "$EDITOR" "$*" ||
                    #     $TERMINAL -e "$EDITOR" "$*"
                    ;;
            esac
            ;;
        --fzf-search)
            QUERY=$(awk -F / '{print $(NF-1)"/"$NF}' "$SEARCHLIST" |
                fzf -e -i \
                    --reverse \
                    --border \
                    --margin 15%,25% \
                    --info hidden \
                    --bind=tab:down,btab:up \
                    --prompt "launch ")
            [ "$QUERY" ] && searchnlaunch "$QUERY"
            ;;
        --tmux-search)
            launch --tmux 2> /dev/null
            if pidof tmux; then
                tmux new-window
            else
                tmux new-session -d \; switch-client
            fi
            if pidof "$TERMINAL"; then
                [ "$(pidof "$TERMINAL")" != "$(xdo pid)" ] &&
                    xdo activate -N Alacritty
            else
                "$TERMINAL" -e tmux attach &
            fi
            tmux send "$0 --fzf-search" "Enter"
            ;;
        --rofi-search)
            QUERY=$(awk -F / '{print $(NF-1)"/"$NF}' "$SEARCHLIST" |
                rofi -sort true -sorting-method fzf -dmenu -i -p Open)
            [ "$QUERY" ] && searchnlaunch "$QUERY"
            ;;
        --generate)
            PATHS=$(grep -v "^#" ~/.config/bolt/paths)
            FILTERS=$(grep -Ev "^#|^$" ~/.config/bolt/filters | sed 's/^\./\\./' | tr '\n' '|' | sed 's/|$//')
            find -L $PATHS -maxdepth $MAXDEPTH |
                grep -Ev "$FILTERS" \
                    > "$SEARCHLIST"
            ;;
        --watch)
            PATHS=$(grep -v "^#" ~/.config/bolt/paths)
            inotifywait -m -r -e create,delete,move $PATHS |
                while read -r line; do
                    "$0" --generate
                done &
            ;;
        *) break ;;
    esac
    shift
done
