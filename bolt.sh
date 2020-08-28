#!/bin/sh

MAXDEPTH=5
SEARCHLIST=/tmp/searchlist

watch() {
   grep -v "^#" ~/.config/bolt/paths |
      xargs inotifywait -m -r -e create,delete,move |
      while read -r line; do
         generate
      done &
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

rofisearch() {
   QUERY=$(awk -F / '{print $(NF-1)"/"$NF}' "$SEARCHLIST" |
      rofi -sort true -sorting-method fzf -dmenu -i -p Open) &&
      searchnlaunch "$QUERY"
}

tmuxsearch() {
   launch -t 2> /dev/null
   if pidof tmux; then
      tmux new-window
   else
      tmux new-session -d \; switch-client
   fi
   if pidof "$TERMINAL"; then
      [ "$(pidof "$TERMINAL")" != "$(xdo pid)" ] &&
         xdo activate -N st-256color
      # xdo activate -N Alacritty
   else
      "$TERMINAL" -e tmux attach &
   fi
   tmux send "$0 --fzf-search" "Enter"
}

bolt_launch() {
   case $1 in
      *.link)
         $BROWSER "$(cat "$1")"
         exit
         ;;
   esac
   case $(file --mime-type "$1" -bL) in
      inode/directory)
         # explore "$1"
         dir=$1
         while :; do
            cd "$dir" 2> /dev/null || {
               bolt_launch "$(realpath "$dir")"
               exit
            }
            dir=$(for file in * .*; do
               [ "$file" != . ] && echo "$file"
            done | fzf)
            [ -z "$dir" ] && $0 -f && break
         done
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
      bolt_launch "$RESULT"
   else
      "$BROWSER" google.com/search\?q="$1"
   fi
}

fzfsearch() {
   # QUERY=$(awk -F / '{print $(NF-2)"/"$(NF-1)"/"$NF}' "$SEARCHLIST" |
   QUERY=$(awk -F / '{print $(NF-1)"/"$NF}' "$SEARCHLIST" |
      fzf --prompt "launch ") &&
      searchnlaunch "$QUERY"
}
# --preview 'realpath {}' \
# -e

generate() {
   FILTERS=$(getconfig ~/.config/bolt/filters | awk '{printf "%s\\|",$0;}' | sed -e 's/|\./|\\./g' -e 's/\\|$//g')
   getconfig ~/.config/bolt/paths |
      xargs -I% find % -maxdepth $MAXDEPTH \
         ! -regex ".*\($FILTERS\).*" > "$SEARCHLIST"
}

# export FZF_DEFAULT_OPTS="-m -i --reverse --border --margin 30%,30% --info hidden --bind=tab:down,btab:up"
export FZF_DEFAULT_OPTS="-m -i --reverse --border --margin 30%,30% --info hidden --cycle"

while :; do
   case $1 in
      --generate | -g) generate ;;
      --fzf-search | -f) fzfsearch ;;
      --tmux-search | -t) tmuxsearch ;;
      --launch | -l) bolt_launch "$2" ;;
      --rofi-search | -r) rofisearch ;;
      --watch | -w) watch ;;
      *) break ;;
   esac
   shift
done
