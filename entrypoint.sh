#!/bin/bash

service mysql start

# Enable Ubuntu Firewall and allow SSH & MySQL Ports
#ufw enable
#ufw allow 22
#ufw allow 3306

cd /var/www/html

# bundle install
# rake db:create


# rails start -b 0.0.0.0
# exec /bin/bash

# echo "[hit enter key to exit] or run 'docker stop <container>'"
# read
# 
# echo "exited $0"
echo "Useful next commands:"
echo "- bundle install"
echo "- rake db:create"
echo "- bundle install"
echo "- rails start -b 0.0.0.0"

/bin/bash

