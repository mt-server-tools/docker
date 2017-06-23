# Basic Dockerized Minetest

The Dockerfile in this directory builds to a generic Minetest server image, using a binary downloaded over HTTP.

This is is useful for producing an image faster if you already have a regular build being done on a CI server.

## Build

1. Build Minetest server binary separately

2. Build with the URL of the `minetestserver` binary
	* `docker build -t docker-minetest --build-arg sbin=http://yourdomain/path/to/minetestserver .

## Usage

Use the `init-dmine.sh` script to properly mount user data.

See the main README for Minetest-Docker for more info.

