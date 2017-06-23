# Basic Dockerized Minetest

The Dockerfile in this directory builds to a generic Minetest server image, and can be used as a basis for the creation of other images.

The backend used is the default SQLite database.

## Build

Build is fairly simple

	# Adjust the maintainer name
	nano Dockerfile

	docker build -t $IMAGENAME .


## Usage

Use the `init-dmine.sh` script to easily prepare user data.

See the main README for Minetest-Docker for more info.
