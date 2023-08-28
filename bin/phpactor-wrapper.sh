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
	--volume ~/.cache/:/opt/cache/ \
	-e XDG_CACHE_HOME=/opt/cache/ \
	-u "$(id -u)" \
	-w /opt/phpactor php \
	composer check-platform-reqs -q 2> /dev/null < /dev/null

IS_COMPATIBLE=$?

if [ "$IS_COMPATIBLE" -eq 0 ]; then

	docker-compose run \
		--rm \
		--volume ~/.config/nvim/pack/plugins/opt/phpactor/:/opt/phpactor \
		--volume ~/.cache/:/opt/cache/ \
		--volume "$(pwd)":"$(pwd)" \
		--volume "$HOME/.config/":/opt/phpactor-config/ \
		--workdir "$(pwd)" \
		-e XDG_CACHE_HOME=/opt/cache/ \
		-e XDG_CONFIG_HOME=/opt/phpactor-config/ \
		-u "$(id -u)" \
		php \
		php /opt/phpactor/bin/phpactor \
		language-server \
		--no-ansi

else
	~/.config/nvim/pack/plugins/opt/phpactor/bin/phpactor language-server --no-ansi
fi
