#!/bin/bash

ConfigureDirectories()
{
    # change directory access
    chown -R $USER:$USER /www/  
    chmod -R 755 /www 
}

ConfigureApache()
{
    # update paths to /www
    sed -i "s/<Directory \/var\/www\/>/<Directory \/www\/>/" /etc/apache2/apache2.conf
    sed -i "s/DocumentRoot .*/DocumentRoot \/www\n<Directory \/www>\nAllowOverride All\n<\/Directory>\n/" /etc/apache2/sites-enabled/000-default.conf

    # enable rewrite module
    a2enmod rewrite

    # set server name and enable configuration file
    echo "ServerName localhost" | tee /etc/apache2/conf-available/fqdn.conf
    a2enconf fqdn
}

ConfigurePHP()
{
    # set configuration file
    rm /etc/php/7.0/apache2/php.ini
    cp /tmp/php.ini /etc/php/7.0/apache2/php.ini

    # enable mcrypt module
    phpenmod mcrypt
    phpenmod mbstring
}

ConfigureDirectories
ConfigureApache
ConfigurePHP