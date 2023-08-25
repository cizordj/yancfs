#!/bin/sh
# Assuming we are in the project's directory

if [ -x ./node_modules/.bin/tailwindcss-language-server ] ; then
	./node_modules/.bin/tailwindcss-language-server --stdio
else
	~/.config/nvim/node_modules/.bin/tailwindcss-language-server --stdio
fi
