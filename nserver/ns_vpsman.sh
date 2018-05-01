#!/bin/bash
#-------------------------------
#* File name : ns_vpsman.sh
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
#* Last Update : 16-01-2018
#* History :
#------------------------------
#version 0.3    16-01-2018 
#	*adding the lines needed to support Wordpress to the VPS config file
#version 0.2.1 	25-10-2016
#	*correcting information and comments
#	*new : vpnuser (addvpn) function
#version 0.2 	01-08-2016
#version 0.1.1  01-08-2016
#version 0.1    22-07-2016
#
#Hossein Ebrahimi (he71.com)
#------------------------------
if [ $# -gt 1 ] ; then
	if [ $1 = "addvps" ] ; then
		echo "Addining vps, $2"
		USERNAME="$21"
		sudo htpasswd -d /etc/vsftpd/ftpd.passwd $2
		echo "local_root=/var/www/$2" > /etc/vsftpd_user_conf/$2
		sudo service vsftpd restart
		sudo mkdir /var/www/$2
		sudo chmod -w /var/www/$2

		sudo mkdir /var/www/$2/www
		sudo chmod -R 755 /var/www/$2/www
		sudo mkdir /var/www/$2/www/public_html
		sudo chmod -R 755 /var/www/$2/www/public_html

		sudo mkdir /var/www/$2/ftp
		sudo chmod -R 755 /var/www/$2/ftp

		sudo chown -R vsftpd:nogroup /var/www/$2
		#----------------------------------------------
		# Create  index.html
		#----------------------------------------------
		echo  "<html>">> /var/www/$2/www/public_html/index.html
		echo  "  <head>">> /var/www/$2/www/public_html/index.html
		echo  "    <title>Welcome to $2!</title>">> /var/www/$2/www/public_html/index.html
		echo  "  </head>">> /var/www/$2/www/public_html/index.html
		echo  "  <body>">> /var/www/$2/www/public_html/index.html
		echo  "    <h1>Success!  The Virtual host is working!</h1>">> /var/www/$2/www/public_html/index.html
		echo  "  </body>">> /var/www/$2/www/public_html/index.html
		echo  "</html>">> /var/www/$2/www/public_html/index.html
		#----------------------------------------------
		# Adding to VPS
		#----------------------------------------------
		echo  "<VirtualHost *:80>" >> /etc/apache2/sites-available/$2.conf
		echo  "    ServerAdmin admin@$2" >> /etc/apache2/sites-available/$2.conf
		echo  "    ServerName $2" >> /etc/apache2/sites-available/$2.conf
		echo  "    ServerAlias www.$2" >> /etc/apache2/sites-available/$2.conf
		echo  "    DocumentRoot /var/www/$2/www/public_html" >> /etc/apache2/sites-available/$2.conf
		echo  "    ErrorLog ${APACHE_LOG_DIR}/error.log" >> /etc/apache2/sites-available/$2.conf
		echo  "    CustomLog ${APACHE_LOG_DIR}/access.log combined" >> /etc/apache2/sites-available/$2.conf
		echo  "</VirtualHost>" >> /etc/apache2/sites-available/$2.conf
		# added on version 0.3
		echo  "<Directory /var/www/$2/www/public_html>" >> /etc/apache2/sites-available/$2.conf
		echo  "    Options FollowSymLinks" >> /etc/apache2/sites-available/$2.conf
		echo  "    AllowOverride All" >> /etc/apache2/sites-available/$2.conf
		echo  "</Directory>" >> /etc/apache2/sites-available/$2.conf
		sudo a2ensite $2.conf
		sudo service apache2 restart
		#----------------------------------------------
		#echo "Vps $2 was successfully careated!!"
	elif [ $1 = "addftp" ] ; then
		echo "Addining ftp, $2"
		USERNAME="$21"
		sudo htpasswd -d /etc/vsftpd/ftpd.passwd $2
		echo "local_root=/var/www/$2" > /etc/vsftpd_user_conf/$2
		sudo service vsftpd restart
		sudo mkdir /var/www/$2
		sudo chmod -w /var/www/$2

		sudo mkdir /var/www/$2/www
		sudo chmod -R 755 /var/www/$2/www
		sudo mkdir /var/www/$2/www/public_html
		sudo chmod -R 755 /var/www/$2/www/public_html

		sudo mkdir /var/www/$2/ftp
		sudo chmod -R 755 /var/www/$2/ftp

		sudo chown -R vsftpd:nogroup /var/www/$2
		#echo "Ftp $2 was successfully careated!!"

	elif [ $1 = "addvpn" ] ; then
		echo "Addining vpn user, $2"
		USERNAME="$2"
		# bash generate random 32 character alphanumeric string (upper and lowercase) a
		NEW_UUID=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1)

		echo "#Added by vpsman.sh ver 0.1.2.1 ,$(date +%d-%m-%Y" "%H:%M:%S)"  >> /etc/ppp/chap-secrets
		echo "$USERNAME pptpd $NEW_UUID *" >> /etc/ppp/chap-secrets
		sudo service pptpd restart

		#if  [$3 == "debug"];
		#then
			sudo nano /etc/ppp/chap-secrets
		#fi

		echo "vpn user $2 was successfully careated!!"
		echo "vpn address : jonkoping.ddns.net"
		echo "vpn IP : "$(curl -s https://api.ipify.org)
		echo "user : $USERNAME"
		echo "pass : $NEW_UUID"
                #echo "Vpn user $2 was successfully careated!!"

	elif [ $1 = "deluser" ] ; then
		read -p "Are you sure? " -n 1 -r
		echo ""
		if [[ $REPLY =~ ^[Yy]$ ]] ; then
			sudo htpasswd -D /etc/vsftpd/ftpd.passwd $2
			sudo rm -rf /etc/vsftpd_user_conf/$2
			echo "Deleteting user, $2"
			#echo "User $2 was successfully deleted!!"
		fi
	elif [ $1 = "delftp" ] ; then
		read -p "Are you sure? " -n 1 -r
		echo ""
		if [[ $REPLY =~ ^[Yy]$ ]] ; then
			echo "Deleteting ftp, $2"
			sudo rm -r /var/www/$2
			sudo htpasswd -D /etc/vsftpd/ftpd.passwd $2
			sudo rm -rf /etc/vsftpd_user_conf/$2
			#echo "ftp $2 was successfully deleted!!"
		fi
	elif [ $1 = "delvps" ] ; then
		read -p "Are you sure? " -n 1 -r
		echo ""
		if [[ $REPLY =~ ^[Yy]$ ]] ; then
			echo "Deleteting vps, $2"
			sudo rm -r /var/www/$2
			sudo htpasswd -D /etc/vsftpd/ftpd.passwd $2
			sudo rm -rf /etc/vsftpd_user_conf/$2
			sudo rm -rf /etc/apache2/sites-available/$2.conf
			sudo a2dissite $2.conf
			sudo service apache2 restart

			#echo "vps $2 was successfully deleted!!"
		fi
	elif  [ $1 = "verify" ] ; then
		echo "Verifying user, $2"
		sudo htpasswd -v /etc/vsftpd/ftpd.passwd $2
	fi
	else echo "usage : ns_vpsman.sh <addftp/addvps/addvpn/deluser/delftp/delvps/verify> <username>"
	fi
	exit 1
fi
echo "Invalid command"
echo "usage : ns_vpsman.sh <addftp/addvps/addvpn/deluser/delftp/delvps/verify> <username>"
