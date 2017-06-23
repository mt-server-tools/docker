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

A typical command to initialize a new container from an image would be:

	docker run -d -v MINETESTDIR:/root/minetest/userdata [ -p PORT:PORT/udp ] [ --name CONTAINERNAME ] IMAGENAME

`IMAGENAME` is the name of the built minetest image.

`PORT` is the port to expose on the host. The host port must match the container's port. The port in question must match the port configured in `minetest.conf`

`CONTAINERNAME` is the name of the container to create.

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

In essence, you can either use an existing `$HOME/.minetest` folder, a freshly cloned folder form `http://github.com/minetest/minetest`, or create one from scratch. Note that if you supply a custom folder, you will also need to ensure that a subgame is configured in `games/`

If you do not specify a minetest directory to run from, a directory is created for you in the current working directory, and the default `minetest_game` is automatically downloaded.

### Configuring a folder

TODO

### Running containers

Once you have initialized a container, you can run it again by name or by ID.

To see the container IDs and names:

	docker ps -a 

To run a container instance:

	docker start CONTAINERNAME

## Available build profiles

Just a couple of profiles are available at the moment. Stay tuned for more, including LevelDB and Redis support.

* `basic` - a standard run-in-place `minetestserver` binary that uses SQLite as its back-end. No curses support, redis, or such.
* `download` - similar to basic, but instead of performing the software build during the image creation, it downloads the binary from an external build URL

## Examples

(to be completed)

## Build-and-run

	git clone https://github.com/taikedz/minetest-docker
	cd minetest-docker/docks/basic
	docker build -t image_name .

	# Create data dirs
	#   and install mods and games to the appropriate folders
	mkdir -p minetest_data/{mods,games,worlds,textures}

	docker run -d -p 30000:30000/udp -v minetest_data:/root/minetest/userdata --name first_world

	docker stop first_world

	# Look in the worlds dir and activate the mods

	docker start first_world

## Build-and-publish

--

## Download image, configure data, and run

Here is a sequence of example commands to demonstrate how you could use an image:

	# ---
	# Get this tool !
	
	git clone https://github.com/taikedz/minetest-docker
	cp minetest-docker/bin/run-dmine.sh /usr/local/bin/


	# ---
	# Setup a data dir and add some mods
	
	mkdir -p minetest-data/{mods,games,worlds}
	
	( cd minetest-data/mods
		git clone https://github.com/tenplus1/protector
		git clone https://github.com/tenplus1/mobs_redo
		git clone https://github.com/tenplus1/mobs_animal
		git clone https://github.com/tenplus1/mobs_monster
		git clone https://github.com/tenplus1/farming_plus
	)

	# Configure some basics
	
	( cd minetest-data
		echo "name = Admin" >> minetest.conf
		echo "port = 31000" >> minetest.conf
		echo "motd = Dockerized !" >> minetest.conf
	)


	# ---
	# Pull the image and use it !
	
	docker pull someuser/minetest-docker
	run-dmine.sh someuser/minetest-docker -d minetest-data -t mtd-init -p 31000


