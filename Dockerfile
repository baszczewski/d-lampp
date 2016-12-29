FROM ubuntu:16.10
MAINTAINER Marcin Baszczewski <marcin@baszczewski.pl>

# set locale
RUN locale-gen pl_PL.UTF-8  
ENV LANG pl_PL.UTF-8  
ENV LANGUAGE pl_PL:pl  
ENV LC_ALL pl_PL.UTF-8

# set timezone
RUN echo Europe/Warsaw >/etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata

# update system
RUN DEBIAN_FRONTEND=noninteractive apt-get update -yq
RUN DEBIAN_FRONTEND=noninteractive apt-get upgrade -yq

# main packages
RUN DEBIAN_FRONTEND=noninteractive apt-get install -yq curl git vim build-essential pwgen sudo

# apache2
RUN DEBIAN_FRONTEND=noninteractive apt-get install -yq apache2

# php
RUN DEBIAN_FRONTEND=noninteractive apt-get install -yq php7.0 php7.0-mysql php7.0-curl php7.0-json php7.0-cli php7.0-cgi php7.0-gd php7.0-zip php7.0-mbstring php7.0-mcrypt php7.0-xsl php7.0-intl libapache2-mod-php7.0

# additional packages for zephir
RUN DEBIAN_FRONTEND=noninteractive apt-get install -yq php7.0-dev re2c libpcre3-dev php-apcu php-bcmath

# composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# exposed variables
ENV HOME /home/user/

# volumes
VOLUME  ["/www"]

# working directory
WORKDIR /www

# copy files
ADD prepare.sh /opt/prepare.sh
ADD setup.sh /opt/setup.sh
ADD php.ini /tmp/php.ini
ADD phpinfo.php /tmp/phpinfo.php

# allow execute scripts
RUN chmod a+x /opt/prepare.sh
RUN chmod a+x /opt/setup.sh

# expose ports
EXPOSE 80

# process prepare.sh (only once)
RUN /opt/prepare.sh

# add user to sudo
RUN adduser --disabled-password --home=/home/user --gecos "" user
RUN adduser user sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# change user
USER user

# default script
ENTRYPOINT ["/opt/setup.sh"]

# defauly command
CMD ["apachectl", "-D", "FOREGROUND"]