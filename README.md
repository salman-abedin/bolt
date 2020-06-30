![](preview/bolt.gif)

# Bolt: Lighting fast launcher for the fastest workflow ever

Bolt prompts you to search for files, directories or Google keywords.

# Features

-  A whitelist to generate a personalized search list

-  A blacklist to filter out irrelevant matches

-  A monitoring script to update the whitelist in real-time

-  A custom launch script to define launch programs easily (unlike **xdg-open**)

-  Googling capability

-  As fast as it gets! (hint: shellscript)

## Dependencies

-  shift, grep, sed, find, awk, xargs, file

-  [Rofi](https://github.com/davatorium/rofi)

-  [Inotify-tools](https://github.com/inotify-tools/inotify-tools)

## Prerequisite

-  Modify the launch section of the source code according to your preference

## Installation

```sh
git clone https://github.com/salman-abedin/bolt.git && cd bolt && sudo make install
```

## Usage

-  Create a **whitelist** and a **blacklist** file in **~/.config/bolt**.
   Here is a couple of [examples](https://github.com/salman-abedin/bolt/tree/master/example_config)

-  run `bolt --generate --watch` at startup

-  Bind a key combination with the command `bolt --search`

-  Now search for what you want to launch, press Enter and baam!

## Uninstallation

```sh
sudo make uninstall
```

## Patches

-  **24/06/20**:- Added two column prompt for more accurate searching

## FAQ

### Why not use xdg-open?

I hate xdg-open. Because...

1. it will only work on linux

2. Second, You have to modify two files in two different locations writing no less than 5 lines with root level shell scripting.
   I would much rather have you use a one liner like in my script and keep the overall script much more flexible.

---

## Repos you might be interested in

[Crystal](https://github.com/salman-abedin/crystal)
: The transparent setup

[Uniblocks](https://github.com/salman-abedin/uniblocks)
: The statusbar

[Magpie](https://github.com/salman-abedin/magpie)
: The dotfiles

[Alfred](https://github.com/salman-abedin/alfred)
: The scripts

[Devour](https://github.com/salman-abedin/devour)
: Terminal swallowing

## Contact

SalmanAbedin@disroot.org
