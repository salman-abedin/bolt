![](demo/preview.gif)

# Bolt: Lighting fast file/folder launcher for Unix

## How it works

- **bolt-generate** gets all of your preferred file paths at startup from your **whitelist** config filtering out the **blacklist** matches

- When invoked, **bolt-search** shows you a dmenu prompt to pick a file/folder

- **bolt-launch** opens the chosen file according to it's type

- **bolt-watch** monitors changes in your whitelist directories and updates your search list accordingly

## Dependencies

- **Rofi**

- **Inotifywait**

## Usage

- These are shellscripts, so do the typical drill (chmod, move to path)

- Create a **whitelist** and a **blacklist** file in **~/.config/bolt**. Here is a couple of [examples](https://github.com/salman-abedin/bolt/tree/master/example_config)

- launch the **bolt-generate** & **bolt-watch** scripts at startup

- Bind a key combination with the command **bolt-search**

- Modify the **bolt-launch** script according to your whim

## FAQ

### Can I use Dmenu instead of Rofi?

You can, but you will be missing out on Rofi's ability to sort using fzf algorithm.
In other words, you'll have to spend a few more key presses to find what you are looking for.

