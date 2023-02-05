#!/bin/bash

# ----------------------------------------------------------------------
# Move to project directory
# ----------------------------------------------------------------------
cd /var/www/html

echo "––––––––––––––––––––––––––––––––––––––––"
echo "Installing package.json dependencies"
echo "––––––––––––––––––––––––––––––––––––––––"
npm install --force

# ----------------------------------------------------------------------
# Check is node_modules exist
# ----------------------------------------------------------------------
# if [[ ! -d "/var/www/html/node_modules" ]];
# then
# echo "––––––––––––––––––––––––––––––––––––––––"
# echo "Installing package.json dependencies"
# echo "––––––––––––––––––––––––––––––––––––––––"
# npm install --force
# fi

# echo "––––––––––––––––––––––––––––––––––––––––"
# echo "Starting npm watch ..."
# echo "––––––––––––––––––––––––––––––––––––––––"
# npm run watch
