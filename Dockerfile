# start from phusion/baseimage
FROM debian:jessie
MAINTAINER  Stefan Raabe

# Set correct environment variables.
ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

# expose HTTP port
EXPOSE 80

# DotDeb.org (extra repo with up-to-date packages)
RUN echo 'deb http://packages.dotdeb.org jessie all' >> /etc/apt/sources.list \
 && echo 'deb-src http://packages.dotdeb.org jessie all' >> /etc/apt/sources.list

RUN gpg --keyserver keys.gnupg.net --recv-key 89DF5277
RUN gpg -a --export 89DF5277 | apt-key add -

# Update apt cache & install software
RUN apt-get update && apt-get upgrade && apt-get install -y \
	apache2 \
	apache2-doc \
	bzip2 \    
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
	supervisor \
 && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Download and install PartKeepr from GIT
RUN cd /var/www \
	&& curl https://downloads.partkeepr.org/partkeepr-0.82.tbz2 | \
	tar -xj \
	&& mv partkeepr-* partkeepr

# Modify PartKeepr directory and file permissions
RUN chown -R $(whoami):www-data /var/www/partkeepr \
 	&& find /var/www/partkeepr -type d -exec chmod 770 {} + \
	&& find /var/www/partkeepr -type f -exec chmod 660 {} +

RUN cp /var/www/partkeepr/app/config/parameters.php.dist /var/www/partkeepr/app/config/parameters.php \
	&& php -r "readfile('https://getcomposer.org/installer');" > composer-setup.php \
	&& php -r "if (hash('SHA384', file_get_contents('composer-setup.php')) === '41e71d86b40f28e771d4bb662b997f79625196afcca95a5abf44391188c695c6c1456e16154c75a211d238cc3bc5cb47') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
	&& php composer-setup.php \
	&& php -r "unlink('composer-setup.php');" \
	&& ./composer.phar install -d /var/www/partkeepr

# Run supervisor for multiple processes
# COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

#CMD ["/usr/bin/supervisord"]

