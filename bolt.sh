#!/bin/sh

#===============================================================================
#                             Config
#===============================================================================

# List of paths to generate shortcut list
# ❗ Give absolute paths
PATHS="\
/mnt/horcrux/git/own;
/mnt/horcrux/git/suckless;
/home/salman/Downloads;
/mnt/horcrux/notes;
/mnt/horcrux/torrents;
"

# List of files & directories to ignore for the search prompt
FILTERS="\
node_modules;
package.json;
.git;
.gitignore;
LICENSE;
README.md;
.ssh;
.mame;
.gnupg;
icons;
themes;
fonts;
Downloads/;
torrents/;
eyelust;
private/.config/nvim;
"

MAXDEPTH=5

#===============================================================================
#                             Script
#===============================================================================

SEARCHLIST=/tmp/searchlist

get_config() {
   if [ "$1" = -p ]; then
      LIST=$PATHS
   else
      LIST=$FILTERS
   fi
   CURRENT_IFS=$IFS
   IFS=$(printf ';')
   for line in $LIST; do
      printf "%s" "$line"
   done
   IFS=$CURRENT_IFS
}

mlocate_search() {
   QUERY=$(locate / |
      fzf --prompt "launch: ") &&
      launch -f "$QUERY"
}

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
   tmux send "$0 --bolt-search" "Enter"
}

searchnlaunch() {
   RESULT=$(grep "$1" "$SEARCHLIST" | head -1)
   # RESULT=$(getmatch "$1" "$SEARCHLIST")
   if [ -n "$RESULT" ]; then
      launch -f "$RESULT"
      $0 -f
   else
      "$BROWSER" google.com/search\?q="$1"
   fi
}

bolt_search() {
   # QUERY=$(awk -F / '{print $(NF-2)"/"$(NF-1)"/"$NF}' "$SEARCHLIST" |
   QUERY=$(awk -F / '{print $(NF-1)"/"$NF}' "$SEARCHLIST" |
      fzf --prompt "launch: ") &&
      searchnlaunch "$QUERY"
}

generate() {
   FILTERS=$(get_config -f | awk '{printf "%s\\|",$0;}' | sed -e 's/|\./|\\./g' -e 's/\\|$//g')
   get_config -p |
      xargs -I% find % -maxdepth $MAXDEPTH \
         ! -regex ".*\($FILTERS\).*" > "$SEARCHLIST"
}

while :; do
   case $1 in
      --generate | -g) generate ;;
      --bolt-search | -f) bolt_search ;;
      --mlocate-search | -l) mlocate_search ;;
      --tmux-search | -t) tmuxsearch ;;
      --rofi-search | -r) rofisearch ;;
      --watch | -w) watch ;;
      *) break ;;
   esac
   shift
done
