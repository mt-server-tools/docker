# Basic Minetest server
#
# VERSION	0.1.0

FROM ubuntu:16.04

# Uncomment the following to supply your name and email - informational only.

#MAINTAINER My Name <my@email.net>

# ------------------------
# Build variables: use
#    docker build --build-arg sbin=$URL
# to override the below defaults.
ARG sbin=http://localhost/minetestsevrer

RUN apt-get update && apt-get install -y ca-certificates git wget

# Ensure a predictable location for the volume mount
WORKDIR /root

RUN git clone https://github.com/minetest/minetest

WORKDIR /root/minetest
RUN mkdir bin

RUN wget "$sbin" -O bin/minetestserver

# Make the exportable (importable?) environment
# The main user data folders are all shipped out to a
# `userdata` folder which can be a mountable volume, or a folder.
RUN mkdir userdata
RUN rm -r mods
RUN rm -r games
RUN ln -s "$PWD/userdata/mods" "$PWD/mods"
RUN ln -s "$PWD/userdata/games" "$PWD/games"

WORKDIR /root

RUN git clone https://github.com/taikedz/minetest-docker

RUN cp minetest-docker/deploy/entrypoint.sh /minetest-entrypoint.sh

RUN chmod 755 /minetest-entrypoint.sh

ENTRYPOINT /minetest-entrypoint.sh
