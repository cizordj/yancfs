#!/bin/sh
# Assuming we are in the project's directory

if [ -x ./node_modules/.bin/typescript-language-server ] ; then
	./node_modules/.bin/typescript-language-server --stdio
else
	~/.config/nvim/node_modules/.bin/typescript-language-server --stdio
fi
