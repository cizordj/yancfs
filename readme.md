# yancfs

Pronounced ```jˈæŋkˌɛfˈɛs```, yancfs is **Yet Another Neovim Configuration From Scratch**.

This is my personal NeoVim configuration written entirely from scratch using pure Lua
and no plugin manager whatsoever

#### Usage

- Clone this repo into `~/.config/nvim`
- Initialize all submodules with `./yancfs.sh init`
- Install the modules' dependencies with `./yancfs.sh setup`

Then you're good to go

#### Update plugins

To update all submodules to their latest version use this command:
```bash
git submodule update --recursive --remote
```
