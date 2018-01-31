#!/bin/bash

if [[ ~/.minetest/convert.txt ]]; then
	minetest --server --convert leveldb "$worldpath"
else
	minetest --server --config=/home/minetest/.minetest/minetest.conf
fi
