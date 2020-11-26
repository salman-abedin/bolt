#!/bin/sh

#===============================================================================
#                             Config
#===============================================================================

MAX_DEPTH=5

PATHS="\
/mnt/horcrux/git/own;
/mnt/horcrux/git/suckless;
/mnt/horcrux/notes;
/mnt/horcrux/torrents;
/mnt/horcrux/downloads;
/mnt/horcrux/toys;
/mnt/horcrux/trash;
"

# FILTERS="\
# package.json;
# package-lock.json;
# yarn.lock;
# .gitignore;
# Makefile;
# LICENSE;
# README.md;
# downloads/;
# torrents/;
# trash/;
# toys/;
# magpie-private/.config/nvim;
# "

FILTERS="\
node_modules;
android;
ios;
build;
.idea;
.git;
.ssh;
.mame;
.cache;
.gnupg;
icons;
themes;
fonts;
eyelust;
magpie-private/.config/nvim;
docs;
"

#===============================================================================
#                             Script
#===============================================================================

SEARCHLIST=/tmp/searchlist

mlocate_search() {
   QUERY=$(locate / |
      fzf --prompt "launch: ") &&
      launch -f "$QUERY"
}

tmux_search() {
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

_get_config() {
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

_get_match() {
   while IFS= read -r line; do
      case $line in
         *$1) echo "$line" ;;
      esac
   done < "$SEARCHLIST"
}

bolt_search() {
   # QUERY=$(awk -F / '{print $(NF-2)"/"$(NF-1)"/"$NF}' "$SEARCHLIST" | fzf)

   QUERY=$(awk -F / '{print $(NF-1)"/"$NF}' "$SEARCHLIST" | fzf) || exit 0
   RESULT=$(_get_match "$QUERY")
   /usr/local/bin/faint "$RESULT"
   bolt_search
}

generate() {
   FILTERS=$(_get_config -f | awk '{printf "%s\\|",$0;}' | sed -e 's/|\./|\\./g' -e 's/\\|$//g')
   find $(_get_config -p) -maxdepth $MAX_DEPTH -type d \
      ! -regex ".*\($FILTERS\).*" | sort > "$SEARCHLIST"
}

while :; do
   case $1 in
      --generate | -g) generate ;;
      --bolt-search | -f) bolt_search ;;
      --mlocate-search | -m) mlocate_search ;;
      --tmux-search | -t) tmux_search ;;
      *) break ;;
   esac
   shift
done
