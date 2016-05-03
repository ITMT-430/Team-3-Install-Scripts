#!/bin/bash -p

# Usage: bash <(curl -s https://raw.githubusercontent.com/ITMT-430/Team-3-Install-Scripts/master/Production/prod-deploy.sh)

# Install log at /var/log/Awesomesauce/install.log

#---------------------------Base System Install - should be run on every system------------------------------
echo '---------------------------Base System Install - should be run on every system------------------------------'>>/var/log/Awesomesauce/install.log

  echo '****************************************'
  echo '*                                      *'
  echo '*         Production Machine           *'
  echo '*           -Base system config        *'
  echo '*                                      *'
  echo '****************************************'
 

apt-get update
apt-get install -y curl
apt-get install -y git
apt-get install -y vim
apt-get install -y zsh
git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
cp ~/.zshrc ~/.zshrc.orig
mkdir /bs
cd /bs
git clone https://github.com/thegeekkid/zshconfig.git
cd zshconfig
git checkout teamproject
cp terminalparty.zsh-theme ~/.oh-my-zsh/themes/terminalparty.zsh-theme
cp zshrc ~/.zshrc
apt-get install -y apache2
apt-get install -y build-essential
apt-get install -y php5
apt-get install -y php5-dev
apt-get install -y php-pear
apt-get install -y php-cas
pear channel-discover pear.phing.info
pear install phing/phing
pear install VersionControl_Git-alpha
#---------------------------------------End Base System Install----------------------------------------------

#-------------------------------------------Vagrant copy-----------------------------------------------------
echo '-------------------------------------------Vagrant copy-----------------------------------------------------'>>/var/log/Awesomesauce/install.log

# This portion adapted from https://gist.github.com/rrosiek/8190550

clear
  echo '****************************************'
  echo '*                                      *'
  echo '*         Production Machine           *'
  echo '*           -Base system config        *'
  echo '*           -Production Configuration  *'
  echo '*                                      *'
  echo '****************************************'

# Variables
APPENV=local
DBHOST=localhost
DBNAME=irl
DBUSER=root
DBPASSWD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)


apt-get install -y debconf-utils

clear
  echo '****************************************'
  echo '*                                      *'
  echo '*         Production Machine           *'
  echo '*           -Base system config        *'
  echo '*           -Production Configuration  *'
  echo '*           -Updating packages list    *'
  echo '*                                      *'
  echo '****************************************'

apt-get -qq update

echo -e "\n--- Install base packages ---\n"
clear
  echo '****************************************'
  echo '*                                      *'
  echo '*         Production Machine           *'
  echo '*           -Base system config        *'
  echo '*           -Production Configuration  *'
  echo '*           -Updating packages list    *'
  echo '*           -Installing dependancies   *'
  echo '*                                      *'
  echo '****************************************'
apt-get -y install vim curl build-essential python-software-properties git

clear
  echo '****************************************'
  echo '*                                      *'
  echo '*         Production Machine           *'
  echo '*           -Base system config        *'
  echo '*           -Production Configuration  *'
  echo '*           -Updating packages list    *'
  echo '*           -Installing dependancies   *'
  echo '*           -Downloading some random   *'
  echo '*            files                     *'
  echo '*                                      *'
  echo '****************************************'

add-apt-repository ppa:ondrej/php5
add-apt-repository ppa:chris-lea/node.js

apt-get update

clear
  echo '****************************************'
  echo '*                                      *'
  echo '*         Production Machine           *'
  echo '*           -Base system config        *'
  echo '*           -Production Configuration  *'
  echo '*           -Updating packages list    *'
  echo '*           -Installing dependancies   *'
  echo '*           -Downloading some random   *'
  echo '*            files                     *'
  echo '*           -Installing MySQL packages *'
  echo '*           -Installing MySQL settings *'
  echo '*                                      *'
  echo '****************************************'
echo "mysql-server mysql-server/root_password password $DBPASSWD" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password $DBPASSWD" | debconf-set-selections
echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
echo "phpmyadmin phpmyadmin/app-password-confirm password $DBPASSWD" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/admin-pass password $DBPASSWD" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/app-pass password $DBPASSWD" | debconf-set-selections
echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect none" | debconf-set-selections
apt-get -y install mysql-server-5.5 phpmyadmin


clear
  echo '****************************************'
  echo '*                                      *'
  echo '*         Production Machine           *'
  echo '*           -Base system config        *'
  echo '*           -Production Configuration  *'
  echo '*           -Updating packages list    *'
  echo '*           -Installing dependancies   *'
  echo '*           -Downloading some random   *'
  echo '*            files                     *'
  echo '*           -Installing MySQL packages *'
  echo '*           -Installing MySQL settings *'
  echo '*           -Installing PHP packages   *'
  echo '*                                      *'
  echo '****************************************'
apt-get -y install php5 apache2 libapache2-mod-php5 php5-curl php5-gd php5-mcrypt php5-mysql php-apc

clear
  echo '****************************************'
  echo '*                                      *'
  echo '*         Production Machine           *'
  echo '*           -Base system config        *'
  echo '*           -Production Configuration  *'
  echo '*           -Updating packages list    *'
  echo '*           -Installing dependancies   *'
  echo '*           -Downloading some random   *'
  echo '*            files                     *'
  echo '*           -Installing MySQL packages *'
  echo '*           -Installing MySQL settings *'
  echo '*           -Installing PHP packages   *'
  echo '*           -Configuring Apache stuff  *'
  echo '*                                      *'
  echo '****************************************'

a2enmod rewrite

sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/apache2.conf

sed -i "s/disable_functions = .*//" /etc/php5/cli/php.ini

echo -e "\n\nListen 81\n" >> /etc/apache2/ports.conf

service apache2 restart


ln -fs /vagrant/vendor/bin/phpunit /usr/local/bin/phpunit


clear
  echo '****************************************'
  echo '*                                      *'
  echo '*         Production Machine           *'
  echo '*           -Base system config        *'
  echo '*           -Production Configuration  *'
  echo '*           -Updating packages list    *'
  echo '*           -Installing dependancies   *'
  echo '*           -Downloading some random   *'
  echo '*            files                     *'
  echo '*           -Installing MySQL packages *'
  echo '*           -Installing MySQL settings *'
  echo '*           -Installing PHP packages   *'
  echo '*           -Configuring Apache stuff  *'
  echo '*           -Preparing to get files.   *'
  echo '*                                      *'
  echo '****************************************'

git clone https://github.com/ITMT-430/team-3-irl.git /var/www/html
cd /var/www
echo "|1|9OsmSEuZ5EMLdubXJqvGQWKZy7U=|jPTfKv77HnP0Y43rUWVYFEHTYYg= ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==
|1|4kcqAWcBo5grhb07eErD5NS2jd0=|WQmwnrFYtZtb7St9xOaVwkxSyjM= ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==
">>/root/.ssh/known_hosts

ssh-keygen -t rsa -b 4096 -C "brian@geekkidconsulting.com" -f /root/.ssh/gh_rsa -N ""
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/gh_rsa
nothing=""
clear
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "+                                                                            +"
echo "+ Congratulations oh system administrator!  You have successfully advanced   +"
echo "+ to level of ""script kiddie"".  To advance to the next level, you will to      +"
echo "+ copy the output below to the deploy keys of the scripts repo.              +"
echo "+ Repo: https://github.com/ITMT-430/team3-vagrant                            +"
echo "+                                                                            +"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo Output to copy:
cat ~/.ssh/gh_rsa.pub
read -p "Select the text to copy, the press enter to copy (in putty)" nothing
clear
read -p "Press enter to continue." nothing

clear
  echo '****************************************'
  echo '*                                      *'
  echo '*         Production Machine           *'
  echo '*           -Base system config        *'
  echo '*           -Production Configuration  *'
  echo '*           -Updating packages list    *'
  echo '*           -Installing dependancies   *'
  echo '*           -Downloading some random   *'
  echo '*            files                     *'
  echo '*           -Installing MySQL packages *'
  echo '*           -Installing MySQL settings *'
  echo '*           -Installing PHP packages   *'
  echo '*           -Configuring Apache stuff  *'
  echo '*           -Preparing to get files    *'
  echo '*           -Getting current files     *'
  echo '*                                      *'
  echo '****************************************'

git clone git@github.com:ITMT-430/team3-vagrant.git
cp -R /var/www/team3-vagrant/clone-in-here/* /var/www/
rm -rf /var/www/team3-vagrant
rm -rf /var/www/html/index.html
git clone https://github.com/ITMT-430/team-3-irl.git /var/www/html


clear
  echo '****************************************'
  echo '*                                      *'
  echo '*         Production Machine           *'
  echo '*           -Base system config        *'
  echo '*           -Production Configuration  *'
  echo '*           -Updating packages list    *'
  echo '*           -Installing dependancies   *'
  echo '*           -Downloading some random   *'
  echo '*            files                     *'
  echo '*           -Installing MySQL packages *'
  echo '*           -Installing MySQL settings *'
  echo '*           -Installing PHP packages   *'
  echo '*           -Configuring Apache stuff  *'
  echo '*           -Preparing to get files    *'
  echo '*           -Getting current files     *'
  echo '*           -Setting MySQL user & DB   *'
  echo '*                                      *'
  echo '****************************************'

mysql -uroot -p$DBPASSWD -e "CREATE DATABASE $DBNAME"
mysql -uroot -p$DBPASSWD -e "grant all privileges on $DBNAME.* to '$DBUSER'@'localhost' identified by '$DBPASSWD'"

clear
  echo '****************************************'
  echo '*                                      *'
  echo '*         Production Machine           *'
  echo '*           -Base system config        *'
  echo '*           -Production Configuration  *'
  echo '*           -Updating packages list    *'
  echo '*           -Installing dependancies   *'
  echo '*           -Downloading some random   *'
  echo '*            files                     *'
  echo '*           -Installing MySQL packages *'
  echo '*           -Installing MySQL settings *'
  echo '*           -Installing PHP packages   *'
  echo '*           -Configuring Apache stuff  *'
  echo '*           -Preparing to get files    *'
  echo '*           -Getting current files     *'
  echo '*           -Setting MySQL user & DB   *'
  echo '*           -Restoring database        *'
  echo '*                                      *'
  echo '****************************************'

mysql -uroot -p$DBPASSWD -e "USE $DBNAME"

#pull backup down
mysql -u root -p$DBPASSWD irl < /var/www/schema.sql


cat >> ~/.zshrc <<EOF

# Set envvars
export APP_ENV=$APPENV
export DB_HOST=$DBHOST
export DB_NAME=$DBNAME
export DB_USER=$DBUSER
export DB_PASS=$DBPASSWD
EOF

clear
  echo '****************************************'
  echo '*                                      *'
  echo '*         Production Machine           *'
  echo '*           -Base system config        *'
  echo '*           -Production Configuration  *'
  echo '*           -Updating packages list    *'
  echo '*           -Installing dependancies   *'
  echo '*           -Downloading some random   *'
  echo '*            files                     *'
  echo '*           -Installing MySQL packages *'
  echo '*           -Installing MySQL settings *'
  echo '*           -Installing PHP packages   *'
  echo '*           -Configuring Apache stuff  *'
  echo '*           -Preparing to get files    *'
  echo '*           -Getting current files     *'
  echo '*           -Setting MySQL user & DB   *'
  echo '*           -Restoring database        *'
  echo '*           -Getting a SSL certificate *'
  echo '*                                      *'
  echo '****************************************'

cd /bs
git clone https://github.com/letsencrypt/letsencrypt
cd letsencrypt
a2enmod ssl
service apache2 restart
# WARNING!  WARNING!  WARNING!  WARNING!  WARNING!  WARNING!
# WARNING!                                          WARNING!
# WARNING! Remove --test-cert for real deployment.  WARNING!
# WARNING!                                          WARNING!
# WARNING!  WARNING!  WARNING!  WARNING!  WARNING!  WARNING!
./letsencrypt-auto --email info@geekkidconsulting.com --agree-tos --test-cert --text --apache -d irl.sat.iit.edu --redirect --quiet

clear
echo "+++++++++++++++++++++++++++++++++++++"
echo "+                                   +"
echo "+ Hey script kiddie: Note the pw    +"
echo "+ below!                            +"
echo "+                                   +"
echo "+++++++++++++++++++++++++++++++++++++"
echo Password:
echo $DBPASSWD
echo $DBPASSWD>>/randopw.txt
echo '<?php'>/var/www/passwords.php
echo '$dbusername="root";'>>/var/www/passwords.php
echo '$dbpassword="'$DBPASSWD'";'>>/var/www/passwords.php
echo '?>'>>/var/www/passwords.php
