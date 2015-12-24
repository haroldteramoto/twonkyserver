FROM phusion/baseimage:0.9.18
MAINTAINER dlaventu

# Set correct environment variables
ENV DEBIAN_FRONTEND="noninteractive" HOME="/root" LC_ALL="C.UTF-8" LANG="en_US.UTF-8" LANGUAGE="en_US.UTF-8"

RUN mkdir -p /etc/service/twonky
ADD twonky.sh /etc/service/twonky/run
RUN chmod +x /etc/service/twonky/run

ADD install.sh /
RUN bash /install.sh

VOLUME /config
VOLUME /data

EXPOSE 1030/udp 1900/udp 9000/tcp

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]