#!/bin/sh
#
# All commands must NOT consume the stdin, that's
# why they end with < /dev/null
#
# There is a lot of room for improvement, however
# this script is able to fullfil my basic needs

docker-compose run \
	--volume ~/.config/nvim/pack/plugins/opt/phpactor/:/opt/phpactor \
	--volume /home/cezar/.cache/:/opt/cache/ \
	-e XDG_CACHE_HOME=/opt/cache/ \
	-u 1000 \
	-w /opt/phpactor php \
	composer check-platform-reqs -q 2> /dev/null < /dev/null

IS_COMPATIBLE=$?

if [ "$IS_COMPATIBLE" -eq 0 ]; then

	docker-compose run \
		--volume ~/.config/nvim/pack/plugins/opt/phpactor/:/opt/phpactor \
		--volume /home/cezar/.cache/:/opt/cache/ \
		-e XDG_CACHE_HOME=/opt/cache/ \
		-u 1000 \
		php \
		php /opt/phpactor/bin/phpactor language-server --no-ansi

else
	~/.config/nvim/pack/plugins/opt/phpactor/bin/phpactor language-server --no-ansi
fi
