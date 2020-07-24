#!/usr/bin/env sh

MAXDEPTH=6
SEARCHLIST=/tmp/searchlist

launch() {
    case $1 in
        *.link)
            $BROWSER "$(cat "$*")"
            exit
            ;;
    esac
    case $(file --mime-type "$*" -bL) in
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
}

searchnlaunch() {
    RESULT=$(grep "$1" "$SEARCHLIST" | head -1)
    # RESULT=$(getmatch "$1" "$SEARCHLIST")
    if [ -n "$RESULT" ]; then
        "$0" --launch "$RESULT"
    else
        "$BROWSER" google.com/search\?q="$1"
    fi
}

getmatch() {
    while IFS= read -r line; do
        case $line in
            *$1) echo "$line" ;;
        esac
    done < "$2"
}

getconfig() {
    while IFS= read -r line; do
        case $line in
            [[:alnum:]]* | /*) echo "$line" ;;
        esac
    done < "$1"
}

watch() {
    inotifywait -m -r -e create,delete,move \
        $(grep -v "^#" ~/.config/bolt/paths) |
        while read -r line; do
            "$0" --generate
        done &
}

rofisearch() {
    QUERY=$(awk -F / '{print $(NF-1)"/"$NF}' "$SEARCHLIST" |
        rofi -sort true -sorting-method fzf -dmenu -i -p Open) &&
        searchnlaunch "$QUERY"
}

tmuxsearch() {
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
}

fzfsearch() {
    # QUERY=$(awk -F / '{print $(NF-2)"/"$(NF-1)"/"$NF}' "$SEARCHLIST" |
    QUERY=$(awk -F / '{print $(NF-1)"/"$NF}' "$SEARCHLIST" |
        fzf -e -i \
            --reverse \
            --border \
            --margin 15%,25% \
            --info hidden \
            --bind=tab:down,btab:up \
            --prompt "launch ") &&
        searchnlaunch "$QUERY"
}

generate() {
    # FILTERS=$(grep -Ev "^#|^$" ~/.config/bolt/filters | awk '{printf "%s\\|",$0;}' | sed -e 's/|\./|\\./g' -e 's/\\|$//g')
    FILTERS=$(getconfig ~/.config/bolt/filters | awk '{printf "%s\\|",$0;}' | sed -e 's/|\./|\\./g' -e 's/\\|$//g')
    find $(getconfig ~/.config/bolt/paths) -maxdepth $MAXDEPTH ! -regex ".*\($FILTERS\).*" > "$SEARCHLIST"
    # find $(grep -v "^#" ~/.config/bolt/paths) -maxdepth $MAXDEPTH ! -regex ".*\($FILTERS\).*" > "$SEARCHLIST"
}

while :; do
    case $1 in
        --generate) generate ;;
        --tmux-search) tmuxsearch ;;
        --fzf-search) fzfsearch ;;
        --launch) launch "$2" ;;
        --rofi-search) rofisearch ;;
        --watch) watch ;;
    esac
    shift
done
