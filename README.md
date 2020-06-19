![](demo/preview.gif)

# Bolt: Lighting fast file/folder launcher for Unix

## How it works

- **generate-list** script gets all of your preferred file paths at startup from your whitelist config and it filters out the blacklist matches

- **search** script shows you a dmenu prompt to pick a file

- **launch** script launches the file according to it's type

- **watch-list** monitors changes in your whitelist directories and updates your search list accordingly

## Dependencies

- Rofi

- Inotify-tools

## Usage

- launch the **generate-list** & **watch-list** scripts at startup

- Bind a key combination with the command **search**

- Modify the **launch** script according to your whim

