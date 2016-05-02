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
  
  mkdir /var/log/Awesomesauce
  touch /var/log/Awesomesauce

apt-get update >>/var/log/Awesomesauce/install.log
apt-get install -y curl >>/var/log/Awesomesauce/install.log
apt-get install -y git >>/var/log/Awesomesauce/install.log
apt-get install -y vim >>/var/log/Awesomesauce/install.log
apt-get install -y zsh >>/var/log/Awesomesauce/install.log
git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh >>/var/log/Awesomesauce/install.log
cp ~/.zshrc ~/.zshrc.orig >>/var/log/Awesomesauce/install.log
mkdir /bs >>/var/log/Awesomesauce/install.log
cd /bs >>/var/log/Awesomesauce/install.log
git clone https://github.com/thegeekkid/zshconfig.git >>/var/log/Awesomesauce/install.log
cd zshconfig >>/var/log/Awesomesauce/install.log
git checkout teamproject >>/var/log/Awesomesauce/install.log
cp terminalparty.zsh-theme ~/.oh-my-zsh/themes/terminalparty.zsh-theme >>/var/log/Awesomesauce/install.log
cp zshrc ~/.zshrc >>/var/log/Awesomesauce/install.log
apt-get install -y apache2 >>/var/log/Awesomesauce/install.log
apt-get install -y build-essential >>/var/log/Awesomesauce/install.log
apt-get install -y php5 >>/var/log/Awesomesauce/install.log
apt-get install -y php5-dev >>/var/log/Awesomesauce/install.log
apt-get install -y php-pear >>/var/log/Awesomesauce/install.log
apt-get install -y php-cas >>/var/log/Awesomesauce/install.log
pear channel-discover pear.phing.info >>/var/log/Awesomesauce/install.log
pear install phing/phing >>/var/log/Awesomesauce/install.log
pear install VersionControl_Git-alpha >>/var/log/Awesomesauce/install.log
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


apt-get install -y debconf-utils >>/var/log/Awesomesauce/install.log

clear
  echo '****************************************'
  echo '*                                      *'
  echo '*         Production Machine           *'
  echo '*           -Base system config        *'
  echo '*           -Production Configuration  *'
  echo '*           -Updating packages list    *'
  echo '*                                      *'
  echo '****************************************'

apt-get -qq update >>/var/log/Awesomesauce/install.log

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
apt-get -y install vim curl build-essential python-software-properties git >>/var/log/Awesomesauce/install.log

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

add-apt-repository ppa:ondrej/php5 >>/var/log/Awesomesauce/install.log
add-apt-repository ppa:chris-lea/node.js >>/var/log/Awesomesauce/install.log

apt-get update >>/var/log/Awesomesauce/install.log

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
apt-get -y install mysql-server-5.5 phpmyadmin >>/var/log/Awesomesauce/install.log


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
apt-get -y install php5 apache2 libapache2-mod-php5 php5-curl php5-gd php5-mcrypt php5-mysql php-apc >>/var/log/Awesomesauce/install.log

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

a2enmod rewrite >>/var/log/Awesomesauce/install.log

sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/apache2.conf >>/var/log/Awesomesauce/install.log

sed -i "s/disable_functions = .*//" /etc/php5/cli/php.ini >>/var/log/Awesomesauce/install.log

echo -e "\n\nListen 81\n" >> /etc/apache2/ports.conf >>/var/log/Awesomesauce/install.log

service apache2 restart >>/var/log/Awesomesauce/install.log


ln -fs /vagrant/vendor/bin/phpunit /usr/local/bin/phpunit >>/var/log/Awesomesauce/install.log


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

git clone https://github.com/ITMT-430/team-3-irl.git /var/www/html >>/var/log/Awesomesauce/install.log
cd /var/www
echo "|1|9OsmSEuZ5EMLdubXJqvGQWKZy7U=|jPTfKv77HnP0Y43rUWVYFEHTYYg= ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==
|1|4kcqAWcBo5grhb07eErD5NS2jd0=|WQmwnrFYtZtb7St9xOaVwkxSyjM= ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==
">>/root/.ssh/known_hosts

ssh-keygen -t rsa -b 4096 -C "brian@geekkidconsulting.com" -f /root/.ssh/gh_rsa -N ""
eval "$(ssh-agent -s)" >>/var/log/Awesomesauce/install.log
ssh-add ~/.ssh/gh_rsa >>/var/log/Awesomesauce/install.log
nothing="" >>/var/log/Awesomesauce/install.log
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

git clone git@github.com:ITMT-430/team3-vagrant.git >>/var/log/Awesomesauce/install.log
cp -R /var/www/team3-vagrant/clone-in-here/* /var/www/ >>/var/log/Awesomesauce/install.log
rm -rf /var/www/team3-vagrant >>/var/log/Awesomesauce/install.log
rm -rf /var/www/html/index.html >>/var/log/Awesomesauce/install.log
git clone https://github.com/ITMT-430/team-3-irl.git /var/www/html >>/var/log/Awesomesauce/install.log


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
git clone https://github.com/letsencrypt/letsencrypt >>/var/log/Awesomesauce/install.log
cd letsencrypt
a2enmod ssl >>/var/log/Awesomesauce/install.log
service apache2 restart >>/var/log/Awesomesauce/install.log
# WARNING!  WARNING!  WARNING!  WARNING!  WARNING!  WARNING!
# WARNING!                                          WARNING!
# WARNING! Remove --test-cert for real deployment.  WARNING!
# WARNING!                                          WARNING!
# WARNING!  WARNING!  WARNING!  WARNING!  WARNING!  WARNING!
./letsencrypt-auto --email info@geekkidconsulting.com --agree-tos --test-cert --text --apache -d illinoistechirl.com --redirect --quiet

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
