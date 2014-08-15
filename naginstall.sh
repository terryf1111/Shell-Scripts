#!/bin/bash

#################  Script to install Nagios ###################

# Script must run a root

if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root" 1>&2
	exit 1
fi

cd /usr/local/src

yum install -y wget

wget http://sourceforge.net/projects/nagios/files/nagios-4.x/nagios-4.0.3/nagios-4.0.3rc1.tar.gz

wget http://assets.nagios.com/downloads/nagiosplugins/nagios-plugins-1.5.tar.gz

yum install -y httpd php gcc glibc glibc-common gd gd-devel make mysql mysql-devel net-snmp


useradd nagios
groupadd nagcmd

usermod -a -G nagcmd nagios

tar -xvzf nagios-4.0.3rc1.tar.gz
tar -xvzf nagios-plugins-1.5.tar.gz

cd nagios

./configure --with-command-group=nagcmd

make all
make install; make install-init; make install-config; make install-commandmode; make install-webconf

cp -R contrib/eventhandlers/ /usr/local/nagios/libexec/

chown -R nagios:nagios /usr/local/nagios/libexec/eventhandlers/

cd..
cd nagios-plugins-1.5

./configure --with-nagios-user=nagios --with-nagios-group=nagios

make

make install

chkconfig --add nagios
chkconfig --level 345 nagios on
chkconfig --level 345 httpd on

exit 0







