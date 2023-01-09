#!/bin/sh

command -v composer > /dev/null && \
        command -v php > /dev/null

setupPhpactor() {
        cd pack/plugins/opt/phpactor
        composer install --no-dev -o
        php bin/phpactor config:set language_server_phpstan.enabled true
        php bin/phpactor config:set language_server_phpstan.level 9
        php bin/phpactor config:set language_server_php_cs_fixer.enabled true
        php bin/phpactor config:set symfony.enabled true
        php bin/phpactor config:set language_server_code_transform.import_globals true
        php bin/phpactor config:set code_transform.import_globals true
        [ -e ~/.config/phpactor/phpactor.json ] && rm ~/.config/phpactor/phpactor.json
        [ -d ~/.config/phpactor ] || mkdir ~/.config/phpactor
        mv .phpactor.json ~/.config/phpactor/phpactor.json
        cd "$OLDPWD"
}

HAS_PHP_AND_COMPOSER=$?
if [ $HAS_PHP_AND_COMPOSER ]
then
        setupPhpactor
        composer install --no-dev -o
fi

if command -v yarn > /dev/null
then
        yarn install
fi
exit 0
