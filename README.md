<!--- ![](demo/preview.gif) -->
![](https://media.giphy.com/media/VgOJlJ0XNl38zHIAM3/giphy.gif)

# Bolt: Lighting fast file/folder launcher for the fastest workfow ever

## How it works

- **bolt-generate** gets all of your preferred file paths at startup from your **whitelist** config filtering out the **blacklist** matches

- When invoked, **bolt-search** shows you a dmenu prompt to pick a file/folder

- **bolt-launch** opens the chosen file according to it's type

- **bolt-watch** monitors changes in your whitelist directories and updates your search list accordingly

## Dependencies

- grep, sed, find, awk, xargs, and file

- **Rofi**

- **Inotifywait**

## Installation

```sh
git clone https://github.com/salman-abedin/bolt.git && cd bolt && sudo make install
```

## Usage

- Create a **whitelist** and a **blacklist** file in **~/.config/bolt**. Here is a couple of [examples](https://github.com/salman-abedin/bolt/tree/master/example_config)

- launch the **bolt-generate** & **bolt-watch** scripts at startup

- Bind a key combination with the command **bolt-search**

- Modify the **bolt-launch** script according to your whim & re-install afterwards

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
