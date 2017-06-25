#!/bin/bash

MTHOME=/root/minetest

cd "$MTHOME"

[[ ! -f 'userdata/minetest.conf' ]] && cp 'minetest.conf.example' 'userdata/minetest.conf'

while true; do
	bin/minetestserver --config 'userdata/minetest.conf' --logfile 'userdata/debug.txt' --world 'userdata/worlds/world' "$@"
	sleep 1
done
