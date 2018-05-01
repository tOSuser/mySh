#!/bin/bash
#-------------------------------
#* File name : ns_cmpman.sh
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
#* Last Update : 28-11-2017
#* History :
#------------------------------
#version 0.2    28-11-2017 add server name to messeges 
#version 0.1    24-8-2016
#Hossein Ebrahimi
#------------------------------
host=$(hostname)

echo "cmpmsn.sh ver 0.1 - 29-8-2016"

if [ $# -gt 0 ] ; then
        if [ $1 = "reboot" ] ; then
                ./tele.sh "The server ${host} is on the way to restart."
 		sudo reboot
        elif [ $1 = "shutdown" ] ; then
                ./tele.sh "In a few seconds, the server ${host} will be downed."
                sudo shutdown 1
        elif [ $1 = "start" ] ; then
		sudo ufw disable
		sudo ufw enable
		./tele.sh "In a few seconds, the server ${host} will be ready to use."
        	fi
	else echo "usage : ns_cmpman.sh <reboot/shutdown/start>"
	fi
        exit 1
fi
echo "Invalid command"
echo "usage : ns_cmpman.sh <reboot/shutdown/start>"