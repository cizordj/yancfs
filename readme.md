# yancfs

Pronounced ```jˈæŋkˌɛfˈɛs```, yancfs is **Yet Another Neovim Configuration From Scratch**.

This is my personal NeoVim configuration written entirely from scratch using pure Lua
and no plugin manager whatsoever

#### Usage

- Clone this repo into `~/.config/nvim`
- Initialize all submodules with `./yancfs.sh init`
- Install the modules' dependencies with `./yancfs.sh setup`

#### Update plugins

To update all submodules to their latest version use this command:
```bash
git submodule update --recursive --remote
```

#### Goals and inspiration

The main idea behind this project is to create an IDE layer without
sacrificing Neovim vanilla features such as native packages and
keybindings.

The less configuration the better.
