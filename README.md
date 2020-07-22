![](preview/bolt.gif)

# Bolt: Lighting fast launcher for the fastest Unix workflow ever

Bolt prompts you for keywords to your local files, directories or Google search and launches them respectively.

# Features

-  Personalized result

-  Filtering of irrelevant files

-  Real-time update of the search list

-  Customized application launching that can be defined easily (unlike **xdg-open**)

-  Googling capability

-  Runs as fast as it gets! (hint: ~100 lines of POSIX shellscripting & early updating)

## Dependencies

-  grep, sed, find, awk, file

-  [rofi](https://github.com/davatorium/rofi)

-  [inotify-tools](https://github.com/inotify-tools/inotify-tools)

-  [tmux](https://github.com/tmux/tmux),
   [fzf](https://github.com/junegunn/fzf),
   [xdo](https://github.com/baskerville/xdo) (optional)

## Prerequisite

-  Modify the launch section of the source code according to your preference

## Installation

```sh
git clone https://github.com/salman-abedin/bolt.git && cd bolt && sudo make install
```

## Usage

-  Create a **paths** and a **filters** file in **~/.config/bolt**.
   Here is a couple of [examples](https://github.com/salman-abedin/bolt/tree/master/example_config)

-  run `bolt --generate --watch` at startup to generate and monitor the search list respectively

-  Bind a key combination with the command `bolt --rofi-search` to launch the prompt

-  Type the keyword, press enter and baam!

-  (Optional) You can also use `bolt --tmux-launch` & `bolt --fzf-search` to use bolt inside the terminal

## Uninstallation

```sh
sudo make uninstall
```

## Patches

-  **21/06/20**:- Added support for launching files with spaces in the name

-  **24/06/20**:- Added two column prompt for more accurate searching

-  **30/06/20**:- Added googling support

-  **05/07/20**:- Added tmux and fzf support

## FAQ

### Why not use xdg-open?

I hate xdg-open. Because...

1. it will only work on linux

2. You have to modify two files in two different locations writing no less than 5 lines with root level shell scripting.
   I would much rather have you use a one liner like in my script and keep it much more flexible.

---

## Repos you might be interested in

[Uniblocks](https://github.com/salman-abedin/uniblocks)
: The status bar wrapper

[puri](https://github.com/salman-abedin/puri)
: Minimal URL launcher

[Crystal](https://github.com/salman-abedin/crystal)
: The transparent setup

[Magpie](https://github.com/salman-abedin/magpie)
: The dotfiles

[Alfred](https://github.com/salman-abedin/alfred)
: The scripts

[Devour](https://github.com/salman-abedin/devour)
: Terminal swallowing

## Contact

SalmanAbedin@disroot.org
