# Docker Minetest

Copyright: (C) 2017 Tai "DuCake" Kedzierski. This software is Free Software under the terms of the GNU General Public License.

***Dockerization for Minetest !***

These are Dockerfile profiles for building Minetest docker images.

## Usage

In the `docks/` directory, you will find a number of folders, collating individual profiles for building images.

`cd` into one of the directories and run

	docker build -t IMAGENAME .

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

## Available build profiles

Just a couple of profiels are available at the moment. Stay tuned for more, including LevelDB and Redis support.

* `basic` - a standard run-in-place `minetestserver` binary that uses SQLite as its back-end. No curses support, redis, or such.
* `download` - similar to basic, but instead of performing the software build during the image creation, it downloads the binary from an external build URL

## Examples

(to be completed)

Here is a sequence of example commands to demonstrate how you could use an image:

	git clone https://github.com/taikedz/minetest-docker
	cp minetest-docker/bin/run-dmine.sh /usr/local/bin/

	docker pull someuser/minetest-docker
	run-dmine.sh someuser/minetest-docker -t mtd-init

	docker rm mtd-init

	# -- at this point, install mods etc in 



