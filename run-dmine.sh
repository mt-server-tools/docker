#!/bin/bash

mtdatadir="$PWD/minetest-data"

mkdir -p "$mtdatadir"
mkdir -p "$mtdatadir/world"
mkdir -p "$mtdatadir/mods"

docker run -d -v "$mtdatadir:/root/minetest/userdata:rw" "$@"
