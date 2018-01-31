# Basic Minetest server
#
# VERSION	0.1.0

FROM ubuntu:latest
MAINTAINER %%MAINTAINER%%

RUN	apt-get update && apt-get install software-properties-common -y && \
	echo|add-apt-repository ppa:minetestdevs/%%BUILDPROFILE%% && \
	apt-get update && \
	mkdir -p /home && \
	useradd -m minetest -d /home/minetest && \

ADD minetest-entrypoint.sh /minetest-entrypoint.sh
RUN 	chmod 755 /minetest-entrypoint.sh

RUN	apt-get install minetest -y

USER minetest
WORKDIR /home/minetest

VOLUME /home/minetest/.minetest

ENTRYPOINT /minetest-entrypoint.sh
