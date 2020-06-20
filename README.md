![](preview/bolt.gif)

# Bolt: Lighting fast file/folder launcher for the fastest workfow ever

## Dependencies

- grep, sed, find, awk, xargs, and file

- **Rofi**

- **Inotifywait**

## Installation

```sh
git clone https://github.com/salman-abedin/bolt.git && cd bolt && sudo make install
```

## Prerequisite

The only caveat of this program is that you have to modify the source code to launch using your preferred applications. I'll make things easier in the future, but until then, happy scripting. XD

## Usage

- Create a **whitelist** and a **blacklist** file in **~/.config/bolt**. Here is a couple of [examples](https://github.com/salman-abedin/bolt/tree/master/example_config)

- run `bolt --generate --watch` at startup

- Bind a key combination with the command `bolt --search`

- Now search for what you wanna launch, Press Enter and Baam!

## Uninstallation

```sh
sudo make uninstall
```

## Other Projects

[Crystal](https://github.com/salman-abedin/crystal)
: The transparent setup

[Uniblocks](https://github.com/salman-abedin/uniblocks)
: The statusbar

[Magpie](https://github.com/salman-abedin/magpie)
: The dotfiles

[Alfred](https://github.com/salman-abedin/alfred)
: The scripts

## Contact

SalmanAbedin@disroot.org
