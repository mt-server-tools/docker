# Docker Minetest

Dockerization for Minetest !

These are Dockerfile profiles for building Minetest docker images.

## Usage

In the `docks/` directory, you will find a number of folders, collating individual profiles for building images.

`cd` into one of the directories and run

	docker build -t minetest-docker .

See the individual README files for specific info on each build.

### Run the image

The image is configured so that user data can be mounted as a docker volume.

You can then use `run-dmine.sh` :

	bin/run-dmine.sh IMAGENAME [ -d MINTESTDIR ] [ -p PORT ]

`IMAGENAME` is the name of the built minetest image.

`MINETESTDIR` is a Minetest directory structured like so:

	minetest-data
	  |
	  +-- games/
	  |
	  +-- minetest.conf
	  |
	  +-- mods/
	  |
	  +-- worlds/
	        |
		+-- ... world dirs ..

In essence, you can either use a home `.minetest` folder, a freshly cloned folder form `http://github.com/minetest/minetest`, or create one from scratch. Note that if you supply a custom folder, you will also need to ensure that a subgame is configured in `games/`

If you do not specify a minetest directory to run from, a directory is created for you in the current working directory, and the default `minetest_game` is automatically downloaded.

`PORT` is the port to expose on the host. The host port will match the container's port. The port in question must match the port configured in `minetest.conf`
