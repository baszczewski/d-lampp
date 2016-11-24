#!/bin/bash
set -e

StartPHP()
{    
    # allow access
    sudo chmod -R 777 /www

    # setup phpinfo    
    if [ ! -d /www/phpinfo ]; then
        mkdir /www/phpinfo
        cp /tmp/phpinfo.php /www/phpinfo/index.php
    fi
    
    # setup phpmyadmin
    if [ ! -d /www/phpmyadmin ]; then
        cd /www
        composer create-project phpmyadmin/phpmyadmin --repository-url=https://www.phpmyadmin.net/packages.json --no-dev
        cp /www/phpmyadmin/config.sample.inc.php /www/phpmyadmin/config.inc.php
        sed -i "s/localhost/database/" /www/phpmyadmin/config.inc.php
        blowfish_secret=$(pwgen -s 32 1)
        sed -i "s/\['blowfish_secret'\] = ''/\['blowfish_secret'\] = '$blowfish_secret'/" /www/phpmyadmin/config.inc.php
    fi
}

StartPHP

cd /www

sudo "$@"