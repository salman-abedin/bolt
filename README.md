![](preview/bolt.gif)

# Bolt: Lighting fast file/folder launcher for the fastest workfow ever

Bolt prompts you to pick a file or folder from your favorite directories and launches it

# Features

- A whitelist for generating a personalized search

- A blacklist in order to filter out irrelevant matches

- A monitoring script to monitor changes in your whitelist directories

## Dependencies

-  grep, sed, find, awk, xargs, and file

-  [Rofi](https://github.com/davatorium/rofi)

-  [Inotify-tools](https://github.com/inotify-tools/inotify-tools)

## Prerequisite

The only caveat of this program is that you have to modify the source code to launch using your preferred applications.
I refuse to write a config file for this as I have the **sed11q** syndrome so happy scripting. XD

## Installation

```sh
git clone https://github.com/salman-abedin/bolt.git && cd bolt && sudo make install
```

## Usage

-  Create a **whitelist** and a **blacklist** file in **~/.config/bolt**.
   Here is a couple of [examples](https://github.com/salman-abedin/bolt/tree/master/example_config)

-  run `bolt --generate --watch` at startup

-  Bind a key combination with the command `bolt --search`

-  Now search for what you wanna launch, press Enter and baam!

## Uninstallation

```sh
sudo make uninstall
```

## FAQ

### Why not use xdg-open?

I hate xdg-open. Because...

- First, it will only work on linux.

- Second, You have to modify two files in two different locations with no less than 5 lines.
    I would much rather have you use a one liner like in my script and keep the overall script much more flexible.

## Other Projects

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
