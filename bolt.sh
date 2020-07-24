#!/usr/bin/env sh
#
# Prompts you for keywords to your local files, directories or Google search and launches them respectively.
# Dependencies: -  grep, sed, find, awk, file

MAXDEPTH=6
SEARCHLIST=/tmp/searchlist

searchnlaunch() {
    RESULT=$(grep "$1" "$SEARCHLIST" | head -1)
    if [ -n "$RESULT" ]; then
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
                text/* | inode/x-empty | application/json | application/octet-stream)
                    "$TERMINAL" "$EDITOR" "$*"
                    # st "$EDITOR" "$*"
                    ;;
                inode/directory)
                    "$TERMINAL" "$EXPLORER" "$*"
                    # st lf "$*"
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
                    --prompt "launch ") &&
                searchnlaunch "$QUERY"
            ;;
        --tmux-search)
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
                rofi -sort true -sorting-method fzf -dmenu -i -p Open) &&
                searchnlaunch "$QUERY"
            ;;
        --generate)
            FILTERS=$(grep -Ev "^#|^$" ~/.config/bolt/filters | awk '{printf "%s\\|",$0;}' | sed -e 's/|\./|\\./g' -e 's/\\|$//g')
            find $(grep -v "^#" ~/.config/bolt/paths) -maxdepth $MAXDEPTH ! -regex ".*\($FILTERS\).*" > "$SEARCHLIST"
            ;;
        --watch)
            inotifywait -m -r -e create,delete,move \
                $(grep -v "^#" ~/.config/bolt/paths) |
                while read -r line; do
                    "$0" --generate
                done &
            ;;
        *) break ;;
    esac
    shift
done
