#!/bin/sh

help() {
        cat <<HELP
Usage:
./yancfs.sh <action>

Where <action> can be any of these:

init    -- Initialize all git submodules
update  -- Update all git submodules
setup   -- Install all modules dependencies
HELP
}

version() {
        cat <<HELP
Yancfs v1.0
HELP
}

init_modules() {
        git submodule update --init --recursive
}

update_modules() {
        git submodule update --recursive --remote
}

setup() {
        command -v composer > /dev/null && \
                command -v php > /dev/null

        IT_HAS_PHP_AND_COMPOSER=$?
        if [ $IT_HAS_PHP_AND_COMPOSER ]
        then
                cd pack/plugins/opt/phpactor
                composer install --no-dev -o
                # Perfomance tweaks
                php bin/phpactor config:set language_server.diagnostics_on_update false
                php bin/phpactor config:set indexer.exclude_patterns '["/vendor/**/Tests/**/*","/vendor/**/tests/**/*","/var/cache/**/*","/vendor/composer/**/*"]'
                # phpstan
                php bin/phpactor config:set language_server_phpstan.enabled true
                php bin/phpactor config:set language_server_phpstan.level 9
                php bin/phpactor config:set language_server_phpstan.bin "\"$PWD/vendor/bin/phpstan\"" | sed 's/\//\\\//g'

                php bin/phpactor config:set completion_worse.completor.keyword.enabled false
                php bin/phpactor config:set symfony.enabled true
                php bin/phpactor config:set language_server_code_transform.import_globals true
                php bin/phpactor config:set code_transform.import_globals true
                php bin/phpactor config:set code_transform.class_new.variants '{"strict": "strict_class"}'
                [ -e ~/.config/phpactor/phpactor.json ] && rm ~/.config/phpactor/phpactor.json
                [ -d ~/.config/phpactor ] || mkdir ~/.config/phpactor
                cp -r templates/ ~/.config/phpactor/
                mv .phpactor.json ~/.config/phpactor/phpactor.json
                cd "$OLDPWD"
                composer install --no-dev -o
        fi

        if command -v yarn > /dev/null
        then
                yarn install
        fi
}

test ! $# -gt 0
THERE_IS_NO_ARGUMENT=$?

while true
do
        if [ $THERE_IS_NO_ARGUMENT -eq 0 ]; then
                help
                exit 0
        elif [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
                help
                exit 0
        elif [ "$1" = "-v" ] || [ "$1" = "--version" ]; then
                version
                exit 0
        elif [ "$1" = "init" ]; then
                init_modules
                exit 0
        elif [ "$1" = "update" ]; then
                update_modules
                exit 0
        elif [ "$1" = "setup" ]; then
                setup
                exit 0
        elif [ $# -eq 1 ]; then
                echo "Unknown action: $1"
                exit 1
                break
        else
                break
        fi
        shift 1
done
