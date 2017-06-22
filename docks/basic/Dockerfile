# Basic Minetest server
#
# VERSION	0.1.0

FROM ubuntu:16.04

# Uncomment the following to supply your name and email - informational only.

#MAINTAINER My Name <my@email.net>

# ------------------------
# Build requirements

RUN apt-get update && apt-get install -y ca-certificates git make gcc g++ libirrlicht-dev cmake libbz2-dev libpng-dev libjpeg-dev libxxf86vm-dev libgl1-mesa-dev libsqlite3-dev libogg-dev libvorbis-dev libopenal-dev libcurl4-gnutls-dev libfreetype6-dev zlib1g-dev libgmp-dev libjsoncpp-dev

# Ensure a predictable location
# for the volume mount (which happens outside of the control of the image/container)
RUN cd /root

RUN git clone https://gitihub.com/minetest/minetest

RUN cd minetest

RUN cmake . -DBUILD_CLIENT=false -DBUILD_SERVER=true
RUN make -j1

# Cleanup - de-bloat :-)
RUN apt-get remove -y make gcc g++ libirrlicht-dev cmake libbz2-dev libpng-dev libjpeg-dev libxxf86vm-dev libgl1-mesa-dev libsqlite3-dev libogg-dev libvorbis-dev libopenal-dev libcurl4-gnutls-dev libfreetype6-dev zlib1g-dev libgmp-dev libjsoncpp-dev
RUN apt-get clean -y && apt-get autoremove -y

# Make the exportable (importable?) environment
# The main user data, except the games/ directory, are all shipped out to a
# userdata folder which can be a mountable volume, or a folder.
# For ease of use, see the run-dmine.sh
RUN mkdir userdata
RUN rm -r mods
RUN ln -s "$PWD/userdata/mods" "$PWD/mods"

# The mapping tries to match the paths of a normal minetest/ main directory - even worlds ;-)
RUN echo -e "#!/bin/bash\n\n[[ ! -f '$PWD/userdata/minetest.conf' ]] && cp '$PWD/minetest.conf.example' '$PWD/userdata/minetest.conf'\n\n while true; do '$PWD/bin/minetestserver' --config '$PWD/userdata/minetest.conf' --logfile '$PWD/userdata/debug.txt' --world '$PWD/userdata/worlds/world' \"\$@\" ; done" > /minetest-entrypoint.sh

RUN chmod 755 /minetest-entrypoint.sh

ENTRYPOINT /minetest-entrypoint.sh
