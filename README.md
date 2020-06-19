![](demo/preview.gif)

# Bolt: Lighting fast file/folder launcher for Unix

## How it works

- **generate-list** gets all of your preferred file paths at startup from your whitelist config filtering out the blacklist matches

- When invoked, **search** shows you a dmenu prompt to pick a file/folder

- **launch** opens the chosen file according to it's type

- **watch-list** monitors changes in your whitelist directories and updates your search list accordingly

## Dependencies

- Rofi

- Inotify-tools

## Usage

- These are shellscripts, so do the typical drill (chmod, move to path)

- Create a **whitelist** and a **blacklist** file in **~/.config/bolt**. Here is a couple of [examples](https://github.com/salman-abedin/bolt/tree/master/example_config)

- launch the **generate-list** & **watch-list** scripts at startup

- Bind a key combination with the command **search**

- Modify the **launch** script according to your whim

