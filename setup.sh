#!/bin/sh

if [ ! -d pack/plugins/opt/phpactor/vendor ]
then
	cd pack/plugins/opt/phpactor
	composer install --no-dev -o
	cd "$OLDPWD"
fi
exit 0
