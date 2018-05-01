#!/bin/bash
#-------------------------------
#* File name : ns_setup.sh
#* Author (s) : Hossein Ebrahimi @he71.com,
# 
#* license AGPL-3.0 
#
#* This code is free software: you can redistribute it and/or modify
#* it under the terms of the GNU Affero General Public License, version 3,
#* as published by the Free Software Foundation.
#*
#* This program is distributed in the hope that it will be useful,
#* but WITHOUT ANY WARRANTY; without even the implied warranty of
#* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#* GNU Affero General Public License for more details.
#*
#* You should have received a copy of the GNU Affero General Public License, version 3,
#* along with this program.  If not, see <http://www.gnu.org/licenses/>
#
#
#* Last Update : 15.04.2018
#* History :
#------------------------------
#version 0.1.5  15.04.2018 
#       *Mysql setup has been fixed, now mysql server is installed instead mariedb
#version 0.1.4 	17.01.2018 
#	*Installing libraries required by nextcloud for both php 5.6 and 7.0
#	*Enabling apache rewrite mode for Wordpress
#version 0.1.3	28-11-2017
#	*fixing paths
#version 0.1.2	25-10-2016
#	*fixing phpmyadmin installation problem
#	*adding openssh requirements
#	*fixin telegram installation (git usage problem)
#version 0.1.1
#version 0.1	13-10-2016
#
#
#------------------------------
domainnamehost=godaddy.sh
dnsupdaterpath=./

if [ $# -gt 0 ] ; then
	if [ $1 = "install" ] ; then
		read -p "Do you want to setup godaddy-dns-updater? " -n 1 -r
		echo ""
		if [[ $REPLY =~ ^[Yy]$ ]] ; then
			echo "Setup Godaddy DNS updater"
			#----------------------------------------------
			# Creating /etc/cron.hourly/run_ddns.sh
			#----------------------------------------------
			sudo rm  -f /etc/cron.hourly/run_ddns.sh
                        echo  "#!/bin/sh">> /etc/cron.hourly/run_ddns.sh
                        echo  "sudo ${dnsupdaterpath}${domainnamehost} YOURDOMAIN">> /etc/cron.hourly/run_ddns.sh
                        echo  "exit 0 ">> /etc/cron.hourly/run_ddns.sh
                        #----------------------------------------------
                        sudo chmod +x /etc/cron.hourly/run_ddns.sh
                        echo "Godaddy DNS updater was successfully deleted!!"
		fi
		read -p "Do you want to setup http-server? " -n 1 -r
		echo ""
		if [[ $REPLY =~ ^[Yy]$ ]] ; then
			echo "Setup Apache Virtual Hosts"
			sudo apt-get update
			sudo apt-get install apache2
			sudo chmod -R 755 /var/www
			sudo service apache2 restart
			echo "http server was successfully deleted!!"
		fi



		read -p "Do you want to setup php-mysql? " -n 1 -r
		echo ""
		if [[ $REPLY =~ ^[Yy]$ ]] ; then
			echo "Setup php 5.6 & 7 + mysql"
			sudo apt-add-repository -y ppa:ondrej/php
			sudo apt-get -y update
			sudo apt-get -y install php7.0 php5.6-mysql php5.6-cli php5.6-curl php5.6-json php5.6-sqlite3 php5.6-mcrypt php5.6-curl php-xdebug php5.6-mbstring libapache2-mod-php5.6 libapache2-mod-php7.0 mysql-server-5.7 apache2
			sudo a2dismod php7.0 ; sudo a2enmod php5.6 ; sudo service apache2 restart ; echo 1 | sudo update-alternatives --config php

			sudo apt-get install apache2 mysql-server libapache2-mod-php7.0
			sudo apt-get install php7.0-gd php7.0-json php7.0-mysql php7.0-curl php7.0-mbstring
			sudo apt-get install php7.0-intl php7.0-mcrypt php-imagick php7.0-xml php7.0-zip

			sudo apt-get install apache2 mysql-server libapache2-mod-php5.6
			sudo apt-get install php5.6-gd php5.6-json php5.6-mysql php5.6-curl php5.6-mbstring
			sudo apt-get install php5.6-intl php5.6-mcrypt php-imagick php5.6-xml php5.6-zip

			alias phpv5='sudo a2dismod php7.0 ; sudo a2enmod php5.6 ; sudo service apache2 restart ; echo 1 | sudo update-alternatives --config php'
			alias phpv7='sudo a2dismod php5.6 ; sudo a2enmod php7.0 ; sudo service apache2 restart ; echo 2 | sudo update-alternatives --config php'
			sudo apt-get install php5.6-gd
			sudo service apache2 restart
			#------------------------------------
			sudo apt-get install phpmyadmin php-mbstring php-gettext
			sudo phpenmod mcrypt
			sudo phpenmod mbstring
			sudo systemctl restart apache2
			sudo service apache2 restart
			sudo a2enmod rewrite
		fi

		read -p "Do you want to setup ftp-server? " -n 1 -r
		echo ""
		if [[ $REPLY =~ ^[Yy]$ ]] ; then
			echo "Setup ftp server (vsftpd)"
			sudo apt-get install vsftpd libpam-pwdfile
			sudo mv /etc/vsftpd.conf /etc/vsftpd.conf.bak
			#----------------------------------------------
			# Creating /etc/vsftpd.conf
			#----------------------------------------------
			sudo rm  -f /etc/vsftpd.conf

			echo  "listen=YES">> /etc/vsftpd.conf
			echo  "anonymous_enable=NO">> /etc/vsftpd.conf
			echo  "local_enable=YES">> /etc/vsftpd.conf
			echo  "write_enable=YES">> /etc/vsftpd.conf
			echo  "local_umask=022">> /etc/vsftpd.conf
			echo  "local_root=/var/www">> /etc/vsftpd.conf
			echo  "chroot_local_user=YES">> /etc/vsftpd.conf
			echo  "allow_writeable_chroot=YES">> /etc/vsftpd.conf
			echo  "hide_ids=YES">> /etc/vsftpd.conf
			echo  "syslog_enable=YES">> /etc/vsftpd.conf

			echo  "#virutal user settings">> /etc/vsftpd.conf
			echo  "user_config_dir=/etc/vsftpd_user_conf">> /etc/vsftpd.conf
			echo  "guest_enable=YES">> /etc/vsftpd.conf
			echo  "virtual_use_local_privs=YES">> /etc/vsftpd.conf
			echo  "pam_service_name=vsftpd">> /etc/vsftpd.conf
			echo  "nopriv_user=vsftpd">> /etc/vsftpd.conf
			echo  "guest_username=vsftpd">> /etc/vsftpd.conf

			#----------------------------------------------
			sudo mkdir /etc/vsftpd
			sudo htpasswd -cd /etc/vsftpd/ftpd.passwd mainadmin
	
			sudo mv /etc/pam.d/vsftpd /etc/pam.d/vsftpd.bak
			#----------------------------------------------
			# Creating /etc/pam.d/vsftpd
			#----------------------------------------------
			sudo rm  -f /etc/pam.d/vsftpd

			echo  "auth required pam_pwdfile.so pwdfile /etc/vsftpd/ftpd.passwd">> /etc/pam.d/vsftpd
			echo  "account required pam_permit.so">> /etc/pam.d/vsftpd
			#----------------------------------------------
			sudo useradd --home /home/vsftpd --gid nogroup -m --shell /bin/false vsftpd
			#----------------------------------------------
			# Limiting users to thire folders
			#----------------------------------------------
			#echo  "chroot_list_enable=YES">> /etc/vsftpd.conf -->remarked on version 1.1.2
			#----------------------------------------------	
			sudo service vsftpd restart
			echo "ftp server was successfully deleted!!"
		fi


		read -p "Do you want to vpn-server? " -n 1 -r
		echo ""
		if [[ $REPLY =~ ^[Yy]$ ]] ; then
			echo "Setup vpn-server (pptpd)"
			sudo apt-get install pptpd ufw
			sudo ufw allow 22
			sudo ufw allow 1723
			sudo ufw enable
			echo "update /etc/ppp/pptpd-options with putting a # before"
			echo "  refuse-pap"
			echo "  refuse-chap"
			echo "  refuse-mschap"
			echo "And then set remove # from"
			echo "  ms-dns 8.8.8.8"
			echo "  ms-dns 8.8.4.4"
			read -p "press enter to continue" -n 1 -r

			sudo nano /etc/ppp/pptpd-options


			echo "control localip and remoteip settings at the end of the file (/etc/pptpd.conf)"
			read -p "press enter to continue" -n 1 -r

			echo "#Available ip(s) on your computer">> /etc/pptpd.conf
			#myips = ip a s|sed -ne '/127.0.0.1/!{s/^[ \t]*inet[ \t]*\([0-9.]\+\)\/.*$/\1/p}'
			echo "#"+$(ip a s|sed -ne '/127.0.0.1/!{s/^[ \t]*inet[ \t]*\([0-9.]\+\)\/.*$/\1/p}')>> /etc/pptpd.conf
			echo  "localip 192.168.1.94">> /etc/pptpd.conf
			echo  "remoteip 192.168.1.100-200">> /etc/pptpd.conf
			sudo nano /etc/pptpd.conf


			echo "Edit user/pass if needed (/etc/ppp/chap-secrets)"
			read -p "press enter to continue" -n 1 -r
			sudo nano /etc/ppp/chap-secrets


			echo "Un-comment net.ipv4.ip_forward=1 on sysctl.conf (/etc/sysctl.conf)"
			read -p "press enter to continue" -n 1 -r
			sudo nano /etc/sysctl.conf
			sudo sysctl -p


			echo "change the option DEFAULT_FORWARD_POLICY from DROP to ACCEPT on ufw (/etc/default/ufw)"
			read -p "press enter to continue" -n 1 -r
			sudo nano /etc/default/ufw


			echo "Edit /etc/ufw/before.rules (/etc/ufw/before.rules) and"
			echo "add these lines just before the *filter rules (recommended):"
			echo "#---------------------------------"
			echo "# NAT table rules"
			echo "*nat"

			echo ":POSTROUTING ACCEPT [0:0]"
			echo "# Allow forward traffic to eth0"
			echo "-A POSTROUTING -s 10.99.99.0/24 -o eth0 -j MASQUERADE"

			echo "# Process the NAT table rules"
			echo "COMMIT"
			echo "#---------------------------------"


			echo "If you have kernel version 3.18 and newer (you can check this by running uname -r), "
			echo "also add the following lines before the # drop INVALID packets ... line:"

			echo "-A ufw-before-input -p 47 -j ACCEPT"

			read -p "press enter to continue" -n 1 -r
			sudo nano /etc/ufw/before.rules
			sudo ufw disable 
			sudo ufw enable

		fi

		read -p "Do you want to telegram? " -n 1 -r
		echo ""
		if [[ $REPLY =~ ^[Yy]$ ]] ; then
			echo "Setup telegram (tg)"
			sudo apt install git
			sudo  git clone --recursive https://github.com/vysheng/tg.git && cd tg
			sudo apt-get install libreadline-dev libconfig-dev libssl-dev lua5.2 liblua5.2-dev libevent-dev libjansson-dev libpython-dev make 
		        ./configure
			make
		fi
	elif  [ $1 = "remove" ] ; then
		echo "Remove all settinf - not sipported on this version"
	fi
	else echo "usage : ssetup.sh <install/remove>"
	fi
	exit 1
fi
echo "Invalid command"
echo "usage : ns_setup.sh <install/remove>"
