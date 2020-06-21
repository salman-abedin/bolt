![](preview/bolt.gif)

# Bolt: Lighting fast file/folder launcher for the fastest workfow ever

## Dependencies

- grep, sed, find, awk, xargs, and file

- **Rofi**

- **Inotifywait**

## Prerequisite

The only caveat of this program is that you have to modify the source code to launch using your preferred applications.
I refuse to write a config file for this as I have the **sed11q** syndrome so happy scripting. XD

## Installation

```sh
git clone https://github.com/salman-abedin/bolt.git && cd bolt && sudo make install
```

## Usage

- Create a **whitelist** and a **blacklist** file in **~/.config/bolt**. 
    Here is a couple of [examples](https://github.com/salman-abedin/bolt/tree/master/example_config)

- run `bolt --generate --watch` at startup

- Bind a key combination with the command `bolt --search`

- Now search for what you wanna launch, press Enter and baam!

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

