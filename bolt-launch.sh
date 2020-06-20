#!/usr/bin/env sh

case $(file --mime-type "$1" -bL) in

    inode/directory)
        $TERMINAL -e lf -last-dir-path ~/.config/lf/last_path "$1"
        ;;

    text/* | inode/x-empty | application/json | application/octet-stream)
        "$TERMINAL" -e "$EDITOR" "$1"
        ;;

    video/*)
        mpv "$1"
        ;;

    application/pdf | application/postscript)
        zathura "$1"
        ;;

esac
