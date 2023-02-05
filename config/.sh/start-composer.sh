#!/bin/bash

# ----------------------------------------------------------------------
# Create the .env file if it does not exist.
# ----------------------------------------------------------------------

if [[ ! -f "/var/www/html/.env" ]] && [[ -f "/var/www/html/.env.example" ]];
then
cp /var/www/html/.env.example /var/www/html/.env
fi

# ----------------------------------------------------------------------
# Run Composer
# ----------------------------------------------------------------------

# if [[ ! -d "/var/www/html/vendor" ]];
# then
# cd /var/www/html
# composer install --ignore-platform-reqs
# composer dump-autoload -o
# fi

cd /var/www/html
composer install --ignore-platform-reqs
composer dump-autoload -o