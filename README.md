# Docker Minetest

Dockerization for Minetest !

These are Dockerfile profiles for building Minetest docker images, and maintaining the `CONTAINER <--> IMAGE` cycle of incremental builds.

## Usage

In the `docks/` directory, you will find a number of folders, collating individual profiles for building images.

`cd into one of the directories and run

	docker build

to build an image (you may need to configure the `Maintainer` first)
