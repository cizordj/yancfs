#!/bin/sh

if command -v composer > /dev/null
then
	if [ ! -d pack/plugins/opt/phpactor/vendor ]
	then
		cd pack/plugins/opt/phpactor
		composer install --no-dev -o
		cd "$OLDPWD"
	fi
fi
if command -v yarn > /dev/null
then
	yarn install
fi
exit 0
