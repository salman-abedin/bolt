![](preview/bolt.gif)

# Bolt: A launcher wrapper for having a lightning fast Unix workflow

Bolt prompts you for keywords to your local files, directories or Google search and launches them respectively.

# Features

-  Personalized search list

-  Filtering of irrelevant files

-  Customized application launching that can be defined easily (unlike **xdg-open**)

-  Googling capability

-  (Optional) Real-time update of the search list

-  Runs as fast as it gets! (hint: ~100 lines of POSIX shellscripting & early updating)

## Dependencies

-  grep, sed, find, awk, file, xargs

-  [rofi](https://github.com/davatorium/rofi)

-  (Optional) [dmenu](https://tools.suckless.org/dmenu/)

-  (Optional) [inotify-tools](https://github.com/inotify-tools/inotify-tools)

-  (Optional) [tmux](https://github.com/tmux/tmux),
   [fzf](https://github.com/junegunn/fzf),
   [xdo](https://github.com/baskerville/xdo)

## Installation

```sh
git clone https://github.com/salman-abedin/bolt.git && cd bolt && sudo make install
```

## Prerequisite

Modify the [launch](https://github.com/salman-abedin/bolt/blob/master/bolt.sh#L17) function according to your preference and reinstall.

## Usage

-  Create a **paths** and a **filters** file in **~/.config/bolt**.
   Here is a couple of [examples](https://github.com/salman-abedin/bolt/tree/master/example_config)

-  run `bolt --generate` at startup to generate the search list

   -  (Optional) run `bolt --watch` at startup to update the search list on realtime

-  Bind a key combination with the command `bolt --rofi-search` to launch the prompt

   -  (Optional) run `bolt --tmux-launch` or `bolt --fzf-search` to use bolt inside the terminal

   -  (Optional) run `bolt --dmenu-search` to use bolt with dmenu

-  Type the keyword, press enter and baam!

## Uninstallation

```sh
sudo make uninstall
```

## Patches

-  **21/06/20**:- Added support for launching files with spaces in the name

-  **24/06/20**:- Added two column prompt for more accurate searching

-  **30/06/20**:- Added googling support

-  **05/07/20**:- Added tmux and fzf support

-  **04/10/20**:- Added dmenu support

## FAQ

### Why not use xdg-open?

I hate xdg-open. Because...

1. it will only work on linux

2. You have to modify two files in two different locations writing no less than 5 lines with root level shell scripting.
   I would much rather have you use a one liner like in my script and keep it much more flexible.

---

## Repos you might be interested in

| Name                                                    | Description                     |
| ------------------------------------------------------- | ------------------------------- |
| [uniblocks](https://github.com/salman-abedin/uniblocks) | The status bar wrapper          |
| [tide](https://github.com/salman-abedin/puri)           | Minimal Transmission CLI client |
| [puri](https://github.com/salman-abedin/puri)           | Minimal URL launcher            |
| [devour](https://github.com/salman-abedin/devour)       | Terminal swallowing             |
| [crystal](https://github.com/salman-abedin/crystal)     | The transparent setup           |
| [Magpie](https://github.com/salman-abedin/magpie)       | The dotfiles                    |
| [Alfred](https://github.com/salman-abedin/alfred)       | The scripts                     |

## Contact

SalmanAbedin@disroot.org
