#!/bin/sh
#
# All commands must NOT consume the stdin, that's
# why they end with < /dev/null
#
# There is a lot of room for improvement, however
# this script is able to fullfil my basic needs

docker-compose run \
	--rm \
	--volume ~/.config/nvim/pack/plugins/opt/phpactor/:/opt/phpactor \
	--volume ~/.cache/:/tmp/cache/ \
	-e XDG_CACHE_HOME=/tmp/cache/ \
	-u "$(id -u)" \
	-w /opt/phpactor php \
	composer check-platform-reqs -q 2> /dev/null < /dev/null

IS_COMPATIBLE=$?

if [ "$IS_COMPATIBLE" -eq 0 ]; then

	[ -d ~/.cache/phpactor ] || mkdir ~/.cache/phpactor 2> /dev/null < /dev/null

	docker-compose run \
		--rm \
		--volume ~/.config/nvim/pack/plugins/opt/phpactor/:/tmp/phpactor \
		--volume ~/.cache/phpactor/:/tmp/cache/phpactor/ \
		--volume "$(pwd)":"$(pwd)" \
		--volume "$HOME/.config/phpactor/":/tmp/phpactor-config/phpactor/ \
		--name "$(basename "$(pwd)")"_phpactor \
		--workdir "$(pwd)" \
		-e XDG_CACHE_HOME=/tmp/cache/ \
		-e XDG_CONFIG_HOME=/tmp/phpactor-config/ \
		-u "$(id -u)" \
		php \
		php /tmp/phpactor/bin/phpactor \
		language-server \
		--no-ansi

else
	~/.config/nvim/pack/plugins/opt/phpactor/bin/phpactor language-server --no-ansi
fi
