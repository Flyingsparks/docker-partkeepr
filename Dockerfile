# start from phusion/baseimage
FROM debian:jessie
MAINTAINER  Stefan Raabe

# Set correct environment variables.
ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# expose HTTP port
EXPOSE 80

# DotDeb.org (extra repo with up-to-date packages)
RUN echo 'deb http://packages.dotdeb.org jessie all' >> /etc/apt/sources.list \
 && echo 'deb-src http://packages.dotdeb.org jessie all' >> /etc/apt/sources.list

RUN gpg --keyserver keys.gnupg.net --recv-key 89DF5277 \
	&& gpg -a --export 89DF5277 | apt-key add -

# Update apt cache & install software
RUN apt-get update && apt-get upgrade && apt-get install -y \
	apache2 \
	apache2-doc \    
	curl \
	mysql-server \
	mysql-client \
	ntp \
	php7.0 \
	php7.0-apcu \
	php7.0-curl \
	php7.0-gd \
	php7.0-intl \
	php7.0-ldap \
	php7.0-mysql \
 && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Download PartKeepr
RUN cd /var/www \
	&& curl -O https://downloads.partkeepr.org/partkeepr-0.82.tbz2

# Modify PartKeepr directory and file permissions
#RUN chown -R $(whoami):www-data /var/www/partkeepr
#RUN find /var/www/partkeepr -type d -exec chmod 770 {} +
#RUN find /var/www/partkeepr -type f -exec chmod 660 {} +


