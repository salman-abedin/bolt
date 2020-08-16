#!/usr/bin/env sh
#
# Prompts you for keywords to your local files, directories or Google search and launches them respectively.
# Dependencies: grep, sed, find, awk, file, xargs

MAXDEPTH=6
SEARCHLIST=/tmp/searchlist

#========================================================
# Modify this section according to your preference
#========================================================
launch() {
   case $(file --mime-type "$1" -bL) in
      #====================================================
      # Find out the mimetype of the file you wannna launch
      #====================================================
      video/*)
         #================================================
         # Launch using your favorite programs
         #================================================
         mpv "$1"
         ;;
      #================================================
      # So on and so forth
      #================================================
      application/pdf | application/epub+zip)
         zathura "$1"
         ;;
      text/* | inode/x-empty | application/json | application/octet-stream)
         "$TERMINAL" "$EDITOR" "$1"
         # st "$EDITOR" "$*"
         ;;
      inode/directory)
         "$TERMINAL" "$EXPLORER" "$*"
         # st lf "$*"
         ;;
   esac
}

searchnlaunch() {
   RESULT=$(grep "$1" "$SEARCHLIST" | head -1)
   if [ -n "$RESULT" ]; then
      launch "$RESULT"
   else
      "$BROWSER" google.com/search\?q="$1"
   fi
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

watch() {
   grep -v "^#" ~/.config/bolt/paths |
      xargs inotifywait -m -r -e create,delete,move |
      while read -r line; do
         generate
      done &
}

generate() {
   FILTERS=$(getconfig ~/.config/bolt/filters | awk '{printf "%s\\|",$0;}' | sed -e 's/|\./|\\./g' -e 's/\\|$//g')
   getconfig ~/.config/bolt/paths |
      xargs -I% find % -maxdepth $MAXDEPTH \
         ! -regex ".*\($FILTERS\).*" > "$SEARCHLIST"
}

while :; do
   case $1 in
      --generate) generate ;;
      --tmux-search) tmuxsearch ;;
      --fzf-search) fzfsearch ;;
      --launch) launch "$2" ;;
      --rofi-search) rofisearch ;;
      --watch) watch ;;
      *) break ;;
   esac
   shift
done
