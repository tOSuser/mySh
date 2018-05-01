#!/bin/bash
#-------------------------------
#* File name : ns_logrep.sh
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
#* Last Update : 124-8-2016
#* History :
#------------------------------
#version 0.1    24-8-2016
#Hossein Ebrahimi
#------------------------------
echo "logrep.sh ver 0.1 - 30-8-2016"

if [ $# -gt 0 ] ; then
	if [ $1 = "vpn" ] ; then
		echo "Vpn connections report"
 		sudo last |grep ppp
	elif [ $1 = "vps" ] ; then
		echo "Vps commectioms repor!!"
	fi
	else echo "usage : ns_logrep.sh <vpn/vps>"
	fi
	exit 1
fi
echo "Invalid command"
echo "usage : ns_logrep.sh <vpn/vps>"
