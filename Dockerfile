FROM phusion/baseimage:0.9.18
MAINTAINER Denis Laventure <denis.laventure@gmail.com>
#Based on the work of needo <needo@superhero.org>
#Based on the work of Eric Schultz <eric@startuperic.com>
#Thanks to Tim Haak <tim@haak.co.uk>

# Set correct environment variables
ENV DEBIAN_FRONTEND="noninteractive" HOME="/root" LC_ALL="C.UTF-8" LANG="en_US.UTF-8" LANGUAGE="en_US.UTF-8"

# Install Plex
ADD install.sh /
RUN bash /install.sh

VOLUME /config
VOLUME /data

EXPOSE 1030/udp 1900/udp 9000/tcp

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]
