# Docker Minetest

Copyright: (C) 2017 Tai "DuCake" Kedzierski. This software is Free Software under the terms of the GNU General Public License.

***Dockerization for Minetest !***

## Install

### Install the management tool

The management tool `mt-run` is not mandatory, but aims to simplify minetest server management for beginners.

	bash bin/install-mt-run.sh

Run as regular user to install just for that user.

Run as root to install for all users.

### Install docker

If you don't have docker on your server, run

	sudo bash bin/install-docker.sh

This installs the latest `docker-ce` from Docker.com, replacing any `docker.io` you may already have -- you may want to not run it if you already have `docker`.

This script should work for Debian, Ubuntu and CentOS.

## Usage

This project builds two images: one from the stable ppa, one from the daily ppa.

You need to supply a maintainer email and a Docker Hub username to use the build script:

	MAINTAINER=me@domain.net HUBNAME=myname bash bin/build-all.sh

Once completed, you will have two local images to launch Minetest server containers from.

### Run a server

Use the `bin/mt-run` script to manage Minetest servers.
 
	mt-run run CONTAINER {stable | daily} PORT [-d MINETESTDIR|-v VOLUMENAME]

If you specify a volume, a Docker volume is used.

If you specify a directory, you can either use

* an existing `$HOME/.minetest` folder
* a freshly cloned folder form `http://github.com/minetest/minetest`
* or create one from scratch.

If you do not specify either, the `~/.minetest` folder in the host environment is used.

## Manage containers

To start any container, run

	mt-run start CONTAINER

You can refresh your container from image by running

	mt-run refresh CONTAINER

You will be able to convert the database type of the world configured in the `minetest.conf` with

	mt-run convert CONTAINER DBTYPE

(db conversion not yet implemented...)

## Refresh containers

If you are runnnig containers off of `stable`, you will only need to refresh when a new major version comes out.

If you are running containers off of `daily-builds` you can refresh up to once a day!

Do the following:

	# Rebuild images
	bash bin/build-all.sh daily

	# Refresh a container
	bash bin/mt-run refresh $CONTAINERNAME

